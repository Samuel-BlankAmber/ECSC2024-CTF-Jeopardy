targetScope = 'subscription'

import { challengeName, numberOfTeams, teamStartIndex } from '../../config/ctf.bicep'

module labs '../lib/lab/module.bicep' = [for teamId in range(0, numberOfTeams): {
  name: 'lab-${challengeName}-team-${teamId + teamStartIndex}'
  scope: subscription()
  params: {
    teamId: teamId + teamStartIndex
  }
}]
