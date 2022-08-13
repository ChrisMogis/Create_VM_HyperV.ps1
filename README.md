# Create_VM_HyperV.ps1
# Presentation
When we want to set up a lab, we are forced to multiply the clicks to create our environment. To make my task easier, I created a script with two virtual machine templates.

**The first model proposes:**
  2vCPU
  2Gb of memory
  60Gb hard drive

**The second model proposes :**
  4vCPU
  4Gb of memory
  80Gb fard drive

# Variables avalables

**VM naming**
Two variables used for create the name of vitrual machine

  **$VMNumber** = Get Random
  **$VMName** = "CCMT" + $VMNumber

**Virtual Switch**
This variable is used to name the virtual switch that will be created when you run the script. (If the virtual switch already exist, the script bypass the creation.)
  **$vSwitchName** = "External-vSwtich"

**Store VM Data and disk**
These variables define the locations where vDisk and virtual machine configuration information will be stored.
  **$StoreVM** = "C:\VMs\vDisks\$($VMName).vhdx"
  **$StoreData** = "C:\VMs\vDatas\"

**ISO of Windows**
This variable indicates where the Windows installation ISO is located.
  **$ISO** = "C:\Users\cmogi\Downloads\22000.318.211104-1236.co_release_svc_refresh_CLIENTENTERPRISEEVAL_OEMRET_x64FRE_en-us.iso"
  
# Script Exécution
The script content two parameters, Template1 and Template2 which correspond to the templates modeled a little more in the article
**Script command line :**
  .\ScriptName.ps1 -Template (VM1 OR VM2)
