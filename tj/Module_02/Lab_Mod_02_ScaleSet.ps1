Get-AzContext

# Exercise 0
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
