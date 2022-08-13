################################################################################################
# This script is used to create a virtual machine on Hyper-V                                   #
# Editor : Christopher Mogis                                                                   #
# Date : 13/08/2022                                                                            #
# Version 1.0 - Initial version                                                                #
################################################################################################

#Script Parameters
Param(
[Parameter(Mandatory=$true)]
[ValidateSet("VM1", "VM2")]
[String[]]
$Template
)

#Variables
$VMNumber = Get-Random
$VMName = "CCMT" + $VMNumber
$vSwitchName = "External"
$StoreVM = "C:\VMs\vDisks\$($VMName).vhdx"
$StoreData = "C:\VMs\vDatas\"
$ISO = "C:\Users\cmogi\Downloads\22000.318.211104-1236.co_release_svc_refresh_CLIENTENTERPRISEEVAL_OEMRET_x64FRE_en-us.iso"

#Template 1
If ($Template -eq "VM1")
{
    #Detect If vSwitch is already create
    $vSwitch = (Get-VMSwitch | Where-Object {$_.Name -eq "$vSwitchName"}).Name

    #If vSwitch not exit, create vSwitch
         If ($vSwitchName -ne $vSwitch)
            {
            New-VMSwitch -Name "$($vSwitchName)" -AllowManagementOS $true -NetAdapterName (Get-NetAdapter | Where-Object {$_.Status -eq "Up" -and !$_.Virtual}).Name
            Write-Host "Your vSwitch $($vSwitchName) is created" -foregroundcolor "green"
            }
        else 
            {
            Write-Host "vSwitch already exist." -foregroundcolor "yellow"
            }

    #Create VM
    New-VM -Name $VMName -MemoryStartupBytes 2GB -BootDevice VHD -NewVHDPath $StoreVM -Path $StoreData -NewVHDSizeBytes 60GB -Generation 2 -Switch $vSwitchName
    Write-Host "Your virtual Machine $($VMName) is create" -foregroundcolor "green"
    Set-VMProcessor $VMName -Count 2
    Write-Host "Configure 2 vCPU on $($VMName)" -foregroundcolor "green"
    #Enable-VMTPM -VMName $($VMName)
    #Write-Host "enable TPM module on $($VMName)" -foregroundcolor "green"

    #Add VM drive
    Add-VMDvdDrive -Path $ISO -VMName $VMName
    Write-Host "Vdisk adding to $($VMName)" -foregroundcolor "green"

    #Configuring the boot order to ISO, VHD, and Network
    Set-VMFirmware -VMName $VMName -BootOrder $(Get-VMDvdDrive -VMName $VMName), $(Get-VMHardDiskDrive -VMName $VMName), $(Get-VMNetworkAdapter -VMName $VMName)
    Write-Host "Boot order is configure to $($VMName)" -foregroundcolor "green"
}

#Template 1
If ($Template -eq "VM1")
{
    #Detect If vSwitch is already create
    $vSwitch = (Get-VMSwitch | Where-Object {$_.Name -eq "$vSwitchName"}).Name

    #If vSwitch not exit, create vSwitch
         If ($vSwitchName -ne $vSwitch)
            {
            New-VMSwitch -Name "$($vSwitchName)" -AllowManagementOS $true -NetAdapterName (Get-NetAdapter | Where-Object {$_.Status -eq "Up" -and !$_.Virtual}).Name
            Write-Host "Your vSwitch $($vSwitchName) is created" -foregroundcolor "green"
            }
        else 
            {
            Write-Host "vSwitch already exist." -foregroundcolor "yellow"
            }

    #Create VM
    New-VM -Name $VMName -MemoryStartupBytes 4GB -BootDevice VHD -NewVHDPath $StoreVM -Path $StoreData -NewVHDSizeBytes 80GB -Generation 2 -Switch $vSwitchName
    Write-Host "Your virtual Machine $($VMName) is create" -foregroundcolor "green"
    Set-VMProcessor $VMName -Count 2
    Write-Host "Configure 2 vCPU on $($VMName)" -foregroundcolor "green"
    #Enable-VMTPM -VMName $($VMName)
    #Write-Host "enable TPM module on $($VMName)" -foregroundcolor "green"

    #Add VM drive
    Add-VMDvdDrive -Path $ISO -VMName $VMName
    Write-Host "Vdisk adding to $($VMName)" -foregroundcolor "green"

    #Configuring the boot order to ISO, VHD, and Network
    Set-VMFirmware -VMName $VMName -BootOrder $(Get-VMDvdDrive -VMName $VMName), $(Get-VMHardDiskDrive -VMName $VMName), $(Get-VMNetworkAdapter -VMName $VMName)
    Write-Host "Boot order is configure to $($VMName)" -foregroundcolor "green"
}
