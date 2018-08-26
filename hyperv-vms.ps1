# This script configures the Hyper-V machines used for docker tutorial step 4
# script worked fine on Win10 1804 after some trial and error

# Variables
$VM0 = "vm0"					#Windows Server VM (use case: AD and DNS only)
$VM1 = "vm1"					#Linux VM1
$VM2 = "vm2"                    #Linux VM2

$VM0RAM = 1GB
$VM1RAM = 1GB
$VM2RAM = 1GB

$VM0VHD = 30GB
$VM1VHD = 10GB
$VM2VHD = 10GB

$VMLOC = "D:\Hyper-V\Virtual Machines"
$VHDLOC = "D:\Hyper-V\Virtual Hard Disks"
$NetworkSwitch1 = "vSwitch1"

$VM0ISO = "Z:\isos\Win-SRV-2016.ISO"
# when string is long, as is above, use a var to declare it once
# otherwise, use it inside the command like in the case of -ControllerNumber (see below)
# whatever saves on typing or space
$VM1ISO = "Z:\isos\CentOS-7-Minimal-1.iso"
$VM2ISO = "Z:\isos\CentOS-7-Minimal-2.iso"


$Gen2 = 2
$linuxSecureBootTemplate = "MicrosoftUEFICertificateAuthority"
$winSecureBootTemplate = "MicrosoftWindows"

# Create VM Folder and Network Switch
mkdir $VMLOC -ErrorAction SilentlyContinue
$TestSwitch = Get-VMSwitch -Name $NetworkSwitch1 -ErrorAction SilentlyContinue; if ($TestSwitch.Count -EQ 0){New-VMSwitch -Name $NetworkSwitch1 -SwitchType External}

# Create Virtual Machines
New-VM -Name $VM0 -Path $VMLOC -MemoryStartupBytes $VM0RAM -NewVHDPath $VHDLOC\$VM0.vhdx -NewVHDSizeBytes $VM0VHD -SwitchName $NetworkSwitch1 -Generation $Gen2
New-VM -Name $VM1 -Path $VMLOC -MemoryStartupBytes $VM1RAM -NewVHDPath $VHDLOC\$VM1.vhdx -NewVHDSizeBytes $VM1VHD -SwitchName $NetworkSwitch1 -Generation $Gen2
New-VM -Name $VM2 -Path $VMLOC -MemoryStartupBytes $VM2RAM -NewVHDPath $VHDLOC\$VM2.vhdx -NewVHDSizeBytes $VM2VHD -SwitchName $NetworkSwitch1 -Generation $Gen2

# Configure Virtual Machines
Add-VMDvdDrive -VMName $VM0 -ControllerNumber 0 -ControllerLocation 1 -Path $VM0ISO
Add-VMDvdDrive -VMName $VM1 -ControllerNumber 0 -ControllerLocation 1 -Path $VM1ISO
Add-VMDvdDrive -VMName $VM2 -ControllerNumber 0 -ControllerLocation 1 -Path $VM2ISO

Set-VMFirmware -VMName $VM0 -FirstBootDevice $(Get-VMDvdDrive -VMName $VM0) -EnableSecureBoot On -SecureBootTemplate $winSecureBootTemplate
Set-VMFirmware -VMName $VM1 -FirstBootDevice $(Get-VMDvdDrive -VMName $VM1) -EnableSecureBoot On -SecureBootTemplate $linuxSecureBootTemplate
Set-VMFirmware -VMName $VM2 -FirstBootDevice $(Get-VMDvdDrive -VMName $VM2) -EnableSecureBoot On -SecureBootTemplate $linuxSecureBootTemplate

#Start-VM $VM0
#Start-VM $VM1
#Start-VM $VM2