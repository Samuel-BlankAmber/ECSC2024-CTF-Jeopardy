import { router, challengeWindowsVms } from '../../config/lab.bicep'
import { VmName, DiskName, NicName } from '../lib/utils.bicep'

var labConfig = loadJsonContent('../../../config/config.json')

var location = resourceGroup().location

var userData = {
  teamId: 0
}

resource routerVm 'Microsoft.Compute/virtualMachines@2023-03-01' = {
  name: VmName(router.name)
  location: location
  properties: {
    hardwareProfile: {
      vmSize: router.vmSize
    }
    storageProfile: {
      imageReference: {
        publisher: 'Canonical'
        offer: 'ubuntu-24_04-lts'
        sku: 'server'
        version: 'latest'
      }
      osDisk: {
        osType: 'Linux'
        name: DiskName(router.name)
        createOption: 'FromImage'
        caching: 'ReadWrite'
        writeAcceleratorEnabled: false
        managedDisk: {
          storageAccountType: 'StandardSSD_LRS'
        }
        deleteOption: 'Detach'
        diskSizeGB: router.diskSize
      }
      dataDisks: []
      diskControllerType: 'SCSI'
    }
    osProfile: {
      computerName: router.hostname
      #disable-next-line adminusername-should-not-be-literal
      adminUsername: router.username
      linuxConfiguration: {
        disablePasswordAuthentication: true
        ssh: {
          publicKeys: [
            {
              path: '/home/${router.username}/.ssh/authorized_keys'
              keyData: labConfig.sshKeys.lab.pub
            }
          ]
        }
        provisionVMAgent: true
        patchSettings: {
          patchMode: 'ImageDefault'
          assessmentMode: 'ImageDefault'
        }
        enableVMAgentPlatformUpdates: false
      }
      secrets: []
      allowExtensionOperations: true
    }
    networkProfile: {
      networkInterfaces: [
        {
          id: resourceId('Microsoft.Network/networkInterfaces', NicName(router.name))
          properties: {
            primary: true
          }
        }
      ]
    }
    userData: base64(string(userData))
    diagnosticsProfile: {
      bootDiagnostics: {
        enabled: false
      }
    }
    priority: 'Regular'
    extensionsTimeBudget: 'PT1H30M'
  }
}

resource routerPrep 'Microsoft.Compute/virtualMachines/extensions@2023-03-01' = {
  name: 'prep-router'
  parent: routerVm
  location: location
  properties: {
    autoUpgradeMinorVersion: false
    publisher: 'Microsoft.Azure.Extensions'
    type: 'CustomScript'
    typeHandlerVersion: '2.1'
    settings: {
      commandToExecute: 'sysctl net.ipv4.ip_forward=1 && iptables -t nat -A POSTROUTING -o eth0 -j MASQUERADE'
    }
  }
}

resource windowsVms 'Microsoft.Compute/virtualMachines@2023-03-01' = [
  for vm in challengeWindowsVms: {
    name: 'vm-${vm.name}' // Cannot use VmName here, because Bicep is broken, and the function is not recognized in the prep extension
    location: location
    properties: {
      hardwareProfile: {
        vmSize: vm.vmSize
      }
      storageProfile: {
        imageReference: vm.imageReference
        osDisk: {
          osType: 'Windows'
          name: DiskName(vm.name)
          createOption: 'FromImage'
          caching: 'ReadWrite'
          writeAcceleratorEnabled: false
          managedDisk: {
            storageAccountType: 'StandardSSD_LRS'
          }
          deleteOption: 'Detach'
          diskSizeGB: vm.diskSize
        }
        dataDisks: []
        diskControllerType: 'SCSI'
      }
      osProfile: {
        computerName: vm.hostname
        #disable-next-line adminusername-should-not-be-literal
        adminUsername: labConfig.credentials[vm.name].username
        #disable-next-line use-secure-value-for-secure-inputs
        adminPassword: labConfig.credentials[vm.name].password
        windowsConfiguration: {
          provisionVMAgent: true
          enableAutomaticUpdates: false
          patchSettings: {
            patchMode: 'AutomaticByPlatform'
            assessmentMode: 'ImageDefault'
            enableHotpatching: false
          }
          winRM: {
            listeners: []
          }
          enableVMAgentPlatformUpdates: false
        }
        secrets: []
        allowExtensionOperations: true
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
      priority: 'Regular'
      extensionsTimeBudget: 'PT1H30M'
    }
    dependsOn: [
      routerVm
    ]
  }
]

resource windowsVmPreps 'Microsoft.Compute/virtualMachines/extensions@2023-03-01' = [
  for (vm, i) in challengeWindowsVms: {
    name: 'prep-${vm.name}'
    parent: windowsVms[i]
    location: location
    properties: {
      autoUpgradeMinorVersion: false
      publisher: 'Microsoft.Compute'
      type: 'CustomScriptExtension'
      typeHandlerVersion: '1.10'
      settings: {
        fileUris: [
          'https://raw.githubusercontent.com/ansible/ansible-documentation/devel/examples/scripts/ConfigureRemotingForAnsible.ps1'
        ]
        commandToExecute: 'powershell -ExecutionPolicy Unrestricted -File ConfigureRemotingForAnsible.ps1'
      }
    }
  }
]
