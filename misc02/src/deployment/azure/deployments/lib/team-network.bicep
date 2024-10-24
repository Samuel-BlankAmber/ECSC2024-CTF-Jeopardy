import { challengeName } from '../../config/ctf.bicep'
import { challengeSubnets } from '../../config/lab.bicep'
import { RgLabIpsName, LabIpName } from './utils.bicep'

param teamId int

module baseNetwork './base-network.bicep' = {
  name: 'base-network'
  params: {
    labIpId: resourceId(RgLabIpsName(challengeName), 'Microsoft.Network/publicIPAddresses', LabIpName(challengeName, teamId))
  }
}
