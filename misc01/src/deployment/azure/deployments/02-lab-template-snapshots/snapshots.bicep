import { challengeName } from '../../config/ctf.bicep'
import { vmMap } from '../../config/lab.bicep'
import { RgLabTemplateName, SnapshotName, DiskName } from '../lib/utils.bicep'

var location = resourceGroup().location

resource snapshots 'Microsoft.Compute/snapshots@2023-10-02' = [
  for vm in vmMap: {
    name: SnapshotName(vm.name)
    sku: {
      name: 'Standard_LRS'
    }
    location: location
    properties: {
      osType: vm.osType
      hyperVGeneration: 'V2'
      supportsHibernation: true
      supportedCapabilities: {
        diskControllerTypes: 'NVME, SCSI'
        acceleratedNetwork: true
        architecture: 'x64'
      }
      creationData: {
        createOption: 'Copy'
        sourceResourceId: resourceId(RgLabTemplateName(challengeName), 'Microsoft.Compute/disks', DiskName(vm.name))
      }
      diskSizeGB: vm.diskSize
      encryption: {
        type: 'EncryptionAtRestWithPlatformKey'
      }
      incremental: false
      networkAccessPolicy: 'DenyAll'
      publicNetworkAccess: 'Disabled'
      dataAccessAuthMode: 'None'
    }
  }
]
