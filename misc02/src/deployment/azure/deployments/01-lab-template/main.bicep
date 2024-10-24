targetScope = 'subscription'

import { challengeName } from '../../config/ctf.bicep'
import { RgLabTemplateName } from '../lib/utils.bicep'

var location = deployment().location

resource rg 'Microsoft.Resources/resourceGroups@2020-06-01' = {
  name: RgLabTemplateName(challengeName)
  location: location
}

module network '../lib/new-ip-network.bicep' = {
  name: 'network'
  scope: rg
}

module vms './vms.bicep' = {
  name: 'vms'
  scope: rg
  dependsOn: [
    network
  ]
}

output labIp string = network.outputs.labIp
