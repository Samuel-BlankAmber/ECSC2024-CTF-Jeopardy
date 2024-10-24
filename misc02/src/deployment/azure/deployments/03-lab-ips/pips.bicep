import { challengeName, numberOfTeams, teamStartIndex } from '../../config/ctf.bicep'
import { LabIpName } from '../lib/utils.bicep'

var location = resourceGroup().location

resource labIp 'Microsoft.Network/publicIPAddresses@2020-11-01' = [
  for teamId in range(0, numberOfTeams): {
    name: LabIpName(challengeName, teamId + teamStartIndex)
    location: location
    properties: {
      publicIPAllocationMethod: 'Static'
    }
  }
]

output labIps array = [
  for teamId in range(0, numberOfTeams): {
    teamId: teamId + teamStartIndex
    ipAddress: labIp[teamId].properties.ipAddress
    resourceName: labIp[teamId].name
  }
]
