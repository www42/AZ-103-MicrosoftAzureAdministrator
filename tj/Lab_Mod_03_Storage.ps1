Login-AzAccount
Get-AzContext | fl

# Exercise 1  Task 4  Copy a container and blobs between Azure Storage accounts
$containerName = 'az1000202-container'
$storageAccount1Name = (Get-AzStorageAccount -ResourceGroupName 'az1000202-RG')[0].StorageAccountName
$storageAccount2Name = (Get-AzStorageAccount -ResourceGroupName 'az1000203-RG')[0].StorageAccountName
$storageAccount1Key1 = (Get-AzStorageAccountKey -ResourceGroupName 'az1000202-RG' -StorageAccountName $storageAccount1Name)[0].Value
$storageAccount2Key1 = (Get-AzStorageAccountKey -ResourceGroupName 'az1000203-RG' -StorageAccountName $storageAccount2Name)[0].Value
$context1 = New-AzStorageContext -StorageAccountName $storageAccount1Name -StorageAccountKey $storageAccount1Key1
$context2 = New-AzStorageContext -StorageAccountName $storageAccount2Name -StorageAccountKey $storageAccount2Key1

New-AzStorageContainer -Name $containerName -Context $context2 -Permission Off

$containerToken1 = New-AzStorageContainerSASToken -Context $context1 -ExpiryTime(get-date).AddHours(24) -FullUri -Name $containerName -Permission rwdl
$containerToken2 = New-AzStorageContainerSASToken -Context $context2 -ExpiryTime(get-date).AddHours(24) -FullUri -Name $containerName -Permission rwdl

# azcopy.exe muss installiert sein
azcopy cp $containerToken1 $containerToken2 --recursive=true


$connectTestResult = Test-NetConnection -ComputerName durlach02.file.core.windows.net -Port 445
$connectTestResult
if ($connectTestResult.TcpTestSucceeded) {
    # Save the password so the drive will persist on reboot
    cmd.exe /C "cmdkey /add:`"durlach02.file.core.windows.net`" /user:`"Azure\durlach02`" /pass:`"84fPq65HGuqc4zpYwQwuYiObLbHTkJhLCkFthBlBhaVH+Gm1rnaxQfjFsf2tMMS+bdFe3cKqjDCZBgWjxjQB7Q==`""
    # Mount the drive
    New-PSDrive -Name Z -PSProvider FileSystem -Root "\\durlach02.file.core.windows.net\az10002share1"-Persist
} else {
    Write-Error -Message "Unable to reach the Azure storage account via port 445. Check to make sure your organization or ISP is not blocking port 445, or use Azure P2S VPN, Azure S2S VPN, or Express Route to tunnel SMB traffic over a different port."
}
