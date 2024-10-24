@export()
func RgLabTemplateName(challengeName string) string => 'rg-${challengeName}-lab-template'

@export()
func RgLabTemplateSnapshotsName(challengeName string) string => 'rg-${challengeName}-lab-template-snapshots'

@export()
func LabIpName(challengeName string, teamId int) string => 'lab-ip-${challengeName}-team-${teamId}'

@export()
func RgLabIpsName(challengeName string) string => 'rg-${challengeName}-lab-ips'

@export()
func DiskName(vmName string) string => 'disk-${vmName}'

@export()
func VmName(vmName string) string => 'vm-${vmName}'

@export()
func NicName(vmName string) string => 'nic-${vmName}'

@export()
func SnapshotName(vmName string) string => 'snapshot-${vmName}'
