import { challengeName } from '../../../config/ctf.bicep'
import { vmMap } from '../../../config/lab.bicep'
import { RgLabTemplateSnapshotsName, VmName, DiskName, NicName, SnapshotName } from '../utils.bicep'

param teamId int

var location = resourceGroup().location

var userData = {
  teamId: teamId
}

resource disks 'Microsoft.Compute/disks@2023-10-02' = [
  for vm in vmMap: {
    name: DiskName(vm.name)
    location: location
    sku: {
      name: 'StandardSSD_LRS'
    }
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
        sourceResourceId: resourceId(
          RgLabTemplateSnapshotsName(challengeName),
          'Microsoft.Compute/snapshots',
          SnapshotName(vm.name)
        )
      }
      diskSizeGB: vm.diskSize
      encryption: {
        type: 'EncryptionAtRestWithPlatformKey'
      }
      networkAccessPolicy: 'DenyAll'
      publicNetworkAccess: 'Disabled'
      dataAccessAuthMode: 'None'
    }
  }
]

resource vms 'Microsoft.Compute/virtualMachines@2023-03-01' = [
  for (vm, i) in vmMap: {
    name: VmName(vm.name)
    location: location
    properties: {
      hardwareProfile: {
        vmSize: vm.vmSize
      }
      storageProfile: {
        osDisk: {
          osType: vm.osType
          name: DiskName(vm.name)
          createOption: 'Attach'
          caching: 'ReadWrite'
          writeAcceleratorEnabled: false
          managedDisk: {
            storageAccountType: 'StandardSSD_LRS'
            id: resourceId('Microsoft.Compute/disks', DiskName(vm.name))
          }
          deleteOption: 'Detach'
          diskSizeGB: vm.diskSize
        }
        dataDisks: []
        diskControllerType: 'SCSI'
      }
      networkProfile: {
        networkInterfaces: [
          {
            id: resourceId('Microsoft.Network/networkInterfaces', NicName(vm.name))
            properties: {
              primary: true
            }
          }
        ]
      }
      diagnosticsProfile: {
        bootDiagnostics: {
          enabled: false
        }
      }
      userData: base64(string(userData))
      priority: 'Regular'
      extensionsTimeBudget: 'PT1H30M'
    }
    dependsOn: [
      disks[i]
    ]
  }
]
