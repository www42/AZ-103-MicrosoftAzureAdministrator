Get-AzContext

# Exercise 0
# ----------
# Task 1: Deploy an Azure VM by using an Azure Resource Manager template

dir Allfiles\Labfiles\Module_02\Virtual_Machines_and_Scale_Sets\az-100-03b_01_azuredeploy.json

New-AzResourceGroup -Name az1000301b-RG -Location westeurope

$Params = @{
    "vmName" = "az1000301b-vm1"
    "vmSize" = "Standard_DS2_v2"
    "adminUsername" = "Student"
    "adminPassword" = "Pa55w.rd1234"
}

New-AzResourceGroupDeployment `
    -ResourceGroupName az1000301b-RG `
    -TemplateFile Allfiles\Labfiles\Module_02\Virtual_Machines_and_Scale_Sets\az-100-03b_01_azuredeploy.json `
    -TemplateParameterObject $Params



# Task 2: Deploy an Azure VM scale set by using an Azure Resource Manager template

dir Allfiles\Labfiles\Module_02\Virtual_Machines_and_Scale_Sets\az-100-03b_02_azuredeploy.json

New-AzResourceGroup -Name az1000302b-RG -Location westeurope

$Params = @{
    "vmssName" = "az1000302bvmss1"
    "vmSize" = "Standard_DS2_v2" 
    "adminUsername" = "Student"
    "adminPassword" = "Pa55w.rd1234"
    "instanceCount" = "1"
}

New-AzResourceGroupDeployment `
    -ResourceGroupName az1000302b-RG `
    -TemplateFile Allfiles\Labfiles\Module_02\Virtual_Machines_and_Scale_Sets\az-100-03b_02_azuredeploy.json `
    -TemplateParameterObject $Params



# Exercise 2
# -----------
# Task 2: Attach data disks to the Azure VM scale set

$vmss = Get-AzVmss -ResourceGroupName 'az1000302b-RG' -VMScaleSetName 'az1000302bvmss1'
Add-AzVmssDataDisk -VirtualMachineScaleSet $vmss -CreateOption Empty -Lun 1 -DiskSizeGB 128 -StorageAccountType 'Standard_LRS'
Update-AzVmss -ResourceGroupName $vmss.ResourceGroupName -VirtualMachineScaleSet $vmss -VMScaleSetName $vmss.Name 


# Task 3: Configure data volumes in the Azure VM scale set
$vmss = Get-AzVmss -ResourceGroupName 'az1000302b-RG' -VMScaleSetName 'az1000302bvmss1'
$publicSettings = @{"fileUris" = (,"https://raw.githubusercontent.com/Azure-Samples/compute-automation-configurations/master/prepare_vm_disks.ps1");"commandToExecute" = "powershell -ExecutionPolicy Unrestricted -File prepare_vm_disks.ps1"}
Add-AzVmssExtension -VirtualMachineScaleSet $vmss -Name "customScript" -Publisher "Microsoft.Compute" -Type "CustomScriptExtension" -TypeHandlerVersion 1.8 -Setting $publicSettings   
Update-AzVmss -ResourceGroupName $vmss.ResourceGroupName -VirtualMachineScaleSet $vmss -VMScaleSetName $vmss.Name 