Get-AzContext

# Exercise 2 Task 2: Test network connectivity to an Azure Storage account by using Network Watcher

[System.Net.Dns]::GetHostAddresses($(Get-AzStorageAccount -ResourceGroupName 'az1010301b-RG')[0].StorageAccountName + '.blob.core.windows.net').IPAddressToString