# Version
$PSVersionTable.PSVersion

# az Module
Get-Module -ListAvailable -Name Az*
Get-Module -ListAvailable -Name Az.Accounts
Get-Command -Module Az.Accounts

# Login
Get-Alias Login-AzAccount | % Definition
Login-AzAccount


# Context = Account + Subscription + Tenant
Get-AzContext | fl 
Get-AzSubscription

Select-AzSubscription -SubscriptionId 92f62d80-3c9a-4cfc-871a-97ab95ea9b1d
Get-AzVm
Select-AzSubscription -SubscriptionId cbf00f35-aa27-472f-b3e4-1c879a77fc43
Get-AzVm