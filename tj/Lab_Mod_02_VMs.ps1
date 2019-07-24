# Exercise 1 Task 2

Connect-AzAccount
Get-AzSubscription

$vmName = 'az1000301-vm1'
$vmSize = 'Standard_DS2_v2'

$resourceGroup = Get-AzResourceGroup -Name 'az1000301-RG'
$location = $resourceGroup.Location

$availabilitySet = Get-AzAvailabilitySet -ResourceGroupName $resourceGroup.ResourceGroupName -Name 'az1000301-avset0'
$vnet = Get-AzVirtualNetwork -Name 'az1000301-RG-vnet' -ResourceGroupName $resourceGroup.ResourceGroupName
$subnetid = (Get-AzVirtualNetworkSubnetConfig -Name 'subnet0' -VirtualNetwork $vnet).Id

$nsg = New-AzNetworkSecurityGroup -ResourceGroupName $resourceGroup.ResourceGroupName -Location $location -Name "$vmName-nsg"
$pip = New-AzPublicIpAddress -Name "$vmName-ip" -ResourceGroupName $resourceGroup.ResourceGroupName -Location $location -AllocationMethod Dynamic 
$nic = New-AzNetworkInterface -Name "$($vmName)$(Get-Random)" -ResourceGroupName $resourceGroup.ResourceGroupName -Location $location -SubnetId $subnetid -PublicIpAddressId $pip.Id -NetworkSecurityGroupId $nsg.Id

$adminUsername = 'Student'
$adminPassword = 'Pa55w.rd1234'
$adminCreds = New-Object PSCredential $adminUsername, ($adminPassword | ConvertTo-SecureString -AsPlainText -Force)

$publisherName = 'MicrosoftWindowsServer'
$offerName = 'WindowsServer'
$skuName = '2016-Datacenter'

$osDiskType = (Get-AzDisk -ResourceGroupName $resourceGroup.ResourceGroupName)[0].Sku.Name

$vmConfig = New-AzVMConfig -VMName $vmName -VMSize $vmSize -AvailabilitySetId $availabilitySet.Id
Add-AzVMNetworkInterface -VM $vmConfig -Id $nic.Id
Set-AzVMOperatingSystem -VM $vmConfig -Windows -ComputerName $vmName -Credential $adminCreds 
Set-AzVMSourceImage -VM $vmConfig -PublisherName $publisherName -Offer $offerName -Skus $skuName -Version 'latest'
Set-AzVMOSDisk -VM $vmConfig -Name "$($vmName)_OsDisk_1_$(Get-Random)" -StorageAccountType $osDiskType -CreateOption fromImage
Set-AzVMBootDiagnostic -VM $vmConfig -Disable

$vmConfig
$vmConfig | % AvailabilitySetReference
$vmConfig | % DiagnosticsProfile | % BootDiagnostics
$vmConfig | % HardwareProfile
$vmConfig | % StorageProfile
$vmConfig | % StorageProfile | % OsDisk

New-AzVM -ResourceGroupName $resourceGroup.ResourceGroupName -Location $location -VM $vmConfig


# Exercise 3
$rg = Get-AzResourceGroup -Name az1000301-RG
$customLabel = 'foo1234'
Test-AzDnsAvailability -DomainNameLabel $customLabel -Location $rg.Location