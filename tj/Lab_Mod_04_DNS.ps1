# Exercise 1  Task 2: Create a DNS record in the public DNS zone
Invoke-RestMethod http://ipinfo.io/json | Select-Object -ExpandProperty IP

$rg = Get-AzResourceGroup -Name az1000401b-RG

# Create PIP
New-AzPublicIpAddress -ResourceGroupName $rg.ResourceGroupName -Sku Basic -AllocationMethod Static -Name az1000401b-pip -Location $rg.Location


# Exercise 2 
# ----------
# Task 1: Provision a multi-virtual network environment
$rg1 = Get-AzResourceGroup -Name 'az1000401b-RG'
$rg2 = New-AzResourceGroup -Name 'az1000402b-RG' -Location $rg1.Location

$subnet1 = New-AzVirtualNetworkSubnetConfig -Name subnet1 -AddressPrefix '10.104.0.0/24'
$vnet1 = New-AzVirtualNetwork -ResourceGroupName $rg2.ResourceGroupName -Location $rg2.Location -Name az1000402b-vnet1 -AddressPrefix 10.104.0.0/16 -Subnet $subnet1

$subnet2 = New-AzVirtualNetworkSubnetConfig -Name subnet1 -AddressPrefix '10.204.0.0/24'
$vnet2 = New-AzVirtualNetwork -ResourceGroupName $rg2.ResourceGroupName -Location $rg2.Location -Name az1000402b-vnet2 -AddressPrefix 10.204.0.0/16 -Subnet $subnet2

# Task 2: Create a private DNS zone
$vnet1 = Get-AzVirtualNetwork -Name az1000402b-vnet1
$vnet2 = Get-AzVirtualNetwork -name az1000402b-vnet2

New-AzDnsZone `
    -Name adatum.local `
    -ResourceGroupName $rg2.ResourceGroupName `
    -ZoneType Private `
    -RegistrationVirtualNetworkId @($vnet1.Id) `
    -ResolutionVirtualNetworkId @($vnet2.Id)

Get-AzDnsZone -ResourceGroupName $rg2.ResourceGroupName

# Task 3: Deploy Azure VMs into virtual networks

New-AzResourceGroupDeployment `
    -ResourceGroupName $rg2.ResourceGroupName `
    -TemplateFile "Allfiles\Labfiles\Module_04\Configure_Azure_DNS\az-100-04b_01_azuredeploy.json" `
    -TemplateParameterFile "Allfiles\Labfiles\Module_04\Configure_Azure_DNS\az-100-04_azuredeploy.parameters.json" `
    -AsJob

New-AzResourceGroupDeployment `
    -ResourceGroupName $rg2.ResourceGroupName `
    -TemplateFile "Allfiles\Labfiles\Module_04\Configure_Azure_DNS\az-100-04b_02_azuredeploy.json" `
    -TemplateParameterFile "Allfiles\Labfiles\Module_04\Configure_Azure_DNS\az-100-04_azuredeploy.parameters.json" `
    -AsJob

Get-Job

New-AzDnsRecordSet -ResourceGroupName $rg2.ResourceGroupName -Name www -RecordType A -ZoneName adatum.local -Ttl 3600 -DnsRecords (New-AzDnsRecordConfig -IPv4Address "10.104.0.4")