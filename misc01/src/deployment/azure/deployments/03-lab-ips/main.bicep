targetScope = 'subscription'

import { challengeName, numberOfTeams } from '../../config/ctf.bicep'
import { RgLabIpsName } from '../lib/utils.bicep'

var location = deployment().location

resource rg 'Microsoft.Resources/resourceGroups@2020-06-01' = {
  name: RgLabIpsName(challengeName)
  location: location
}

module pips './pips.bicep' = {
  name: 'pips'
  scope: rg
}

output labIps array = pips.outputs.labIps
