// Networking
@export()
@description('The address prefixes for the challenge virtual network')
var vnetAddressPrefixes = [
  '10.0.0.0/8'
]

@export()
@description('The subnets for the challenge virtual network')
var challengeSubnets = [
  {
    name: 'challenge'
    addressPrefix: '10.151.1.0/24'
  }
]

// VMs
var defaultVmSize = 'Standard_B2ls_v2'
var defaultDiskSize = 30
var defaultWindowsImageReference = {
  publisher: 'MicrosoftWindowsServer'
  offer: 'WindowsServer'
  sku: '2022-datacenter-smalldisk-g2'
  version: 'latest'
}

@export()
var router = {
  name: 'router'
  hostname: 'router'
  ip: '10.10.10.10'
  subnet: '10.10.10.0/24'
  vmSize: defaultVmSize
  diskSize: defaultDiskSize
  username: 'deploy'
}

@export()
var challengeWindowsVms = [
  {
    name: 'target'
    hostname: 'jaws'
    ip: '10.151.1.100'
    subnet: 'challenge'
    vmSize: defaultVmSize
    imageReference: defaultWindowsImageReference
    diskSize: defaultDiskSize
    username: 'deploy'
  }
  {
    name: 'dev'
    hostname: 'dev-jaws'
    ip: '10.151.1.101'
    subnet: 'challenge'
    vmSize: defaultVmSize
    imageReference: defaultWindowsImageReference
    diskSize: 60
    username: 'deploy'
  }
]

@export()
var vmMap = concat(
  [
    {
      name: router.name
      vmSize: router.vmSize
      diskSize: router.diskSize
      osType: 'Linux'
    }
  ],
  map(challengeWindowsVms, vm => {
    name: vm.name
    vmSize: vm.vmSize
    diskSize: vm.diskSize
    osType: 'Windows'
  })
)
