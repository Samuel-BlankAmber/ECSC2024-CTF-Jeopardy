targetScope = 'subscription'

import { challengeName } from '../../../config/ctf.bicep'

param teamId int

resource rg 'Microsoft.Resources/resourceGroups@2020-06-01' = {
  name: 'rg-${challengeName}-lab-team-${teamId}'
  location: deployment().location
}

module network '../team-network.bicep' = {
  name: 'network'
  scope: rg
  params: {
    teamId: teamId
  }
}

module vms './vms.bicep' = {
  name: 'vms'
  scope: rg
  params: {
    teamId: teamId
  }
  dependsOn: [
    network
  ]
}
