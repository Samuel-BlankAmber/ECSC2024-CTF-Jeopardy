targetScope = 'subscription'

import { challengeName } from '../../config/ctf.bicep'
import { RgLabTemplateSnapshotsName } from '../lib/utils.bicep'

var location = deployment().location

resource rg 'Microsoft.Resources/resourceGroups@2020-06-01' = {
  name: RgLabTemplateSnapshotsName(challengeName)
  location: location
}

module snapshots './snapshots.bicep' = {
  name: 'snapshots'
  scope: rg
}
