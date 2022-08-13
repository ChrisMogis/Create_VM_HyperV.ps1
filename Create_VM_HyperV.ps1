################################################################################################
# This script is used to create a virtual machine on Hyper-V                                   #
# Editor : Christopher Mogis                                                                   #
# Date : 13/08/2022                                                                            #
# Version 1.0 - Initial version                                                                #
################################################################################################

#Script Parameters
Param(
[Parameter(Mandatory=$true)]
[ValidateSet("Template1", "Template2")]
[String[]]
$Template
)

#Variables
$VMNumber = Get-Random
$VMName = "CCMT" + $VMNumber
$vSwitchName = "External-vSwtich"
$StoreVM = "C:\VMs\vDisks\$($VMName).vhdx"
$StoreData = "C:\VMs\vDatas\"
$ISO = "C:\Users\cmogi\Downloads\22000.318.211104-1236.co_release_svc_refresh_CLIENTENTERPRISEEVAL_OEMRET_x64FRE_en-us.iso"

#Template 1
If ($Template -eq "Template1")
{
    #Detect active network connection and create Virtual Network Switch
    $vSwitch = (Get-VMSwitch -Name $($vSwitchName)).Name

    #If vSwitch not exit, create vSwitch
    If ($vSwitch -ne $vSwitchName)
    {
        {
        New-VMSwitch -Name $vSwitchName -AllowManagementOS $true -NetAdapterName (Get-NetAdapter | Where-Object {$_.Status -eq "Up" -and !$_.Virtual}).Name
        }
    else 
        {
        Write-Host "$vSwitchName already exist."
        }
    }
    #Create VM
    New-VM -Name $VMName -MemoryStartupBytes 2GB -BootDevice VHD -NewVHDPath $StoreVM -Path $StoreData -NewVHDSizeBytes 60GB -Generation 2 -Switch $vSwitchName

    #Add VM drive
    Add-VMDvdDrive -Path $ISO -VMName $VMName

    # Configuring the boot order to ISO, VHD, and Network
    Set-VMFirmware -VMName $VMName -BootOrder $(Get-VMDvdDrive -VMName $VMName), $(Get-VMHardDiskDrive -VMName $VMName), $(Get-VMNetworkAdapter -VMName $VMName)
}

#Template 2
If ($Template -eq "Template2")
{
    #Detect active network connection and create Virtual Network Switch
    $vSwitch = (Get-VMSwitch -Name $($vSwitchName)).Name

    #If vSwitch not exit, create vSwitch
    If ($vSwitch -ne $vSwitchName)
    {
        New-VMSwitch -Name "$($vSwitchName)" -AllowManagementOS $true -NetAdapterName (Get-NetAdapter | Where-Object {$_.Status -eq "Up" -and !$_.Virtual}).Name
    }
    else 
    {
        Write-Host "$($vSwitchName) already exist."
    }
    
    #Create VM
    New-VM -Name "$($VMName)" -MemoryStartupBytes 4GB -BootDevice VHD -NewVHDPath "$($StoreVM)" -Path "$($StoreData)" -NewVHDSizeBytes 80GB -Generation 2 -Switch "$($vSwitchName)"

    #Add VM drive
    Add-VMDvdDrive -Path $ISO -VMName "$($VMName)"

    # Configuring the boot order to ISO, VHD, and Network
    Set-VMFirmware -VMName $VMName -BootOrder $(Get-VMDvdDrive -VMName $VMName), $(Get-VMHardDiskDrive -VMName $VMName), $(Get-VMNetworkAdapter -VMName $VMName)
}