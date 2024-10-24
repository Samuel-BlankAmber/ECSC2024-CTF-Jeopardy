targetScope = 'subscription'

import { challengeName } from '../../config/ctf.bicep'

param teamId int

module labs '../lib/lab/module.bicep' = {
  name: 'lab-${challengeName}-team-${teamId}'
  scope: subscription()
  params: {
    teamId: teamId
  }
}
