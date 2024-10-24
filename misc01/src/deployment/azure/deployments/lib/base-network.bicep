import { router, challengeSubnets, vnetAddressPrefixes, challengeWindowsVms } from '../../config/lab.bicep'
import { NicName } from './utils.bicep'

@description('Lab public IP ID')
param labIpId string

var location = resourceGroup().location

resource rt 'Microsoft.Network/routeTables@2023-09-01' = {
  name: 'rt'
  location: location
  properties: {
    disableBgpRoutePropagation: true
    routes: [
      {
        name: 'default-override-0'
        properties: {
          addressPrefix: '0.0.0.0/0'
          nextHopType: 'VirtualAppliance'
          nextHopIpAddress: router.ip
          hasBgpOverride: false
        }
        type: 'Microsoft.Network/routeTables/routes'
      }
      {
        name: 'default-override-1'
        properties: {
          addressPrefix: '10.0.0.0/8'
          nextHopType: 'VirtualAppliance'
          nextHopIpAddress: router.ip
          hasBgpOverride: false
        }
        type: 'Microsoft.Network/routeTables/routes'
      }
      {
        name: 'default-override-2'
        properties: {
          addressPrefix: '172.16.0.0/12'
          nextHopType: 'VirtualAppliance'
          nextHopIpAddress: router.ip
          hasBgpOverride: false
        }
        type: 'Microsoft.Network/routeTables/routes'
      }
      {
        name: 'default-override-3'
        properties: {
          addressPrefix: '192.168.0.0/16'
          nextHopType: 'VirtualAppliance'
          nextHopIpAddress: router.ip
          hasBgpOverride: false
        }
        type: 'Microsoft.Network/routeTables/routes'
      }
      {
        name: 'default-override-4'
        properties: {
          addressPrefix: '100.64.0.0/10'
          nextHopType: 'VirtualAppliance'
          nextHopIpAddress: router.ip
          hasBgpOverride: false
        }
        type: 'Microsoft.Network/routeTables/routes'
      }
    ]
  }
}

resource nsg 'Microsoft.Network/networkSecurityGroups@2023-09-01' = {
  name: 'nsg'
  location: location
  properties: {
    securityRules: [
      {
        name: 'AllowAnyInbound'
        type: 'Microsoft.Network/networkSecurityGroups/securityRules'
        properties: {
          protocol: '*'
          sourcePortRange: '*'
          destinationPortRange: '*'
          sourceAddressPrefix: '*'
          destinationAddressPrefix: '*'
          access: 'Allow'
          priority: 100
          direction: 'Inbound'
          sourcePortRanges: []
          destinationPortRanges: []
          sourceAddressPrefixes: []
          destinationAddressPrefixes: []
        }
      }
      {
        name: 'DenyIMDS'
        type: 'Microsoft.Network/networkSecurityGroups/securityRules'
        properties: {
          protocol: '*'
          sourcePortRange: '*'
          destinationPortRange: '*'
          sourceAddressPrefix: '*'
          destinationAddressPrefix: 'AzurePlatformIMDS'
          access: 'Deny'
          priority: 110
          direction: 'Outbound'
          sourcePortRanges: []
          destinationPortRanges: []
          sourceAddressPrefixes: []
          destinationAddressPrefixes: []
        }
      }
    ]
  }
}

var subnets = [
  for subnet in challengeSubnets: {
    name: subnet.name
    properties: {
      addressPrefix: subnet.addressPrefix
      networkSecurityGroup: {
        id: nsg.id
      }
      routeTable: {
        id: rt.id
      }
      serviceEndpoints: []
      delegations: []
      privateEndpointNetworkPolicies: 'Enabled'
      privateLinkServiceNetworkPolicies: 'Enabled'
    }
  }
]

resource vnet 'Microsoft.Network/virtualNetworks@2023-09-01' = {
  name: 'vnet'
  location: location
  properties: {
    addressSpace: {
      addressPrefixes: vnetAddressPrefixes
    }
    dhcpOptions: {
      dnsServers: []
    }
    subnets: concat(
      [
        {
          name: 'router'
          properties: {
            addressPrefix: router.subnet
            serviceEndpoints: []
            delegations: []
            privateEndpointNetworkPolicies: 'Enabled'
            privateLinkServiceNetworkPolicies: 'Enabled'
          }
          type: 'Microsoft.Network/virtualNetworks/subnets'
        }
      ],
      subnets
    )
    virtualNetworkPeerings: []
    enableDdosProtection: false
  }
}

resource routerNic 'Microsoft.Network/networkInterfaces@2023-09-01' = {
  name: NicName(router.name)
  location: location
  properties: {
    ipConfigurations: [
      {
        name: 'ipconfig-router'
        type: 'Microsoft.Network/networkInterfaces/ipConfigurations'
        properties: {
          privateIPAddress: router.ip
          privateIPAllocationMethod: 'Static'
          publicIPAddress: {
            id: labIpId
            properties: {
              deleteOption: 'Detach'
            }
          }
          subnet: {
            id: vnet.properties.subnets[0].id
          }
          primary: true
          privateIPAddressVersion: 'IPv4'
        }
      }
    ]
    enableAcceleratedNetworking: false
    enableIPForwarding: true
    disableTcpStateTracking: false
    nicType: 'Standard'
  }
}

resource windowsVmNics 'Microsoft.Network/networkInterfaces@2023-09-01' = [
  for vm in challengeWindowsVms: {
    name: NicName(vm.name)
    location: location
    properties: {
      ipConfigurations: [
        {
          name: 'ipconfig-${vm.name}'
        type: 'Microsoft.Network/networkInterfaces/ipConfigurations'
          properties: {
            privateIPAddress: vm.ip
            privateIPAllocationMethod: 'Static'
            subnet: {
              id: resourceId('Microsoft.Network/virtualNetworks/subnets', 'vnet', vm.subnet)
            }
            primary: true
            privateIPAddressVersion: 'IPv4'
          }
        }
      ]
      enableAcceleratedNetworking: false
      enableIPForwarding: true
      disableTcpStateTracking: false
      nicType: 'Standard'
    }
    dependsOn: [
      vnet
    ]
  }
]
