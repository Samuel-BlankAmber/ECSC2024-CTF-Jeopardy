var location = resourceGroup().location

resource labIp 'Microsoft.Network/publicIPAddresses@2023-09-01' = {
  name: 'pip'
  location: location
  sku: {
    name: 'Basic'
    tier: 'Regional'
  }
  properties: {
    publicIPAddressVersion: 'IPv4'
    publicIPAllocationMethod: 'Static'
  }
}

module baseNetwork './base-network.bicep' = {
  name: 'base-network'
  params: {
    labIpId: labIp.id
  }
}

output labIp string = labIp.properties.ipAddress
