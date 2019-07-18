<#
.Synopsis
   Query Azure Site Recovery Services to get list of protected replication items
.DESCRIPTION
   Query Azure Site Recovery Services to get list of protected replication items for each ASR Fabric Server
.EXAMPLE
   Run script without parameters
.EXAMPLE
   Another example of how to use this cmdlet

    THIS CODE AND ANY ASSOCIATED INFORMATION ARE PROVIDED “AS IS” WITHOUT WARRANTY OF ANY KIND, EITHER EXPRESSED OR 
    IMPLIED, INCLUDING BUT NOT LIMITED TO THE IMPLIED WARRANTIES OF MERCHANTABILITY AND/OR FITNESS FOR A PARTICULAR
    PURPOSE. THE ENTIRE RISK OF USE, INABILITY TO USE, OR RESULTS FROM THE USE OF THIS CODE REMAINS WITH THE USER.
#>
<#
Non Interactive Logon
# Variable Declaration
$CLIENT_SECRET = "Service Principal client secret"
$CLIENT_ID = "Service Principal client ID also known as Application ID"
$TENANT_ID = "AAD Tenant ID"
 
Write-Host "Logging you in..."
$secpasswd = ConvertTo-SecureString $CLIENT_SECRET -AsPlainText -Force
$mycreds = New-Object System.Management.Automation.PSCredential ($CLIENT_ID, $secpasswd)
Add-AzureRmAccount -ServicePrincipal -Tenant $TENANT_ID -Credential $mycreds
#>

#Interactively connect to Azure
#$cred = Get-Credential
Connect-AzureRmAccount

Get-AzureRmSubscription -SubscriptionName "Production-AzureDR" | Select-AzureRmSubscription


#Get the list of recovery services vaults in the subscription
$VaultObj = Get-AzureRmRecoveryServicesVault -Name "rvDycomDR"

#Get and import vault settings file
$VaultFileLocation = Get-AzureRmRecoveryServicesVaultSettingsFile -SiteRecovery -Vault $VaultObj
Import-AzureRmRecoveryServicesAsrVaultSettingsFile -Path $VaultFileLocation.FilePath

#Get list of Replicated Protected Items from each Fabric Server
$pentasr01items = Get-AzureRmRecoveryServicesAsrFabric -FriendlyName "dyatl-pentasr01" | Get-AzureRmRecoveryServicesAsrProtectionContainer | Get-AzureRmRecoveryServicesAsrReplicationProtectedItem | Select-Object friendlyname | export-csv "d:\output\ugo\pentasr01_RPI_$((Get-Date).ToString('yyyy-MM-dd')).csv" -NoTypeInformation
$pentasr02items = Get-AzureRmRecoveryServicesAsrFabric -FriendlyName "dyatl-pentasr02" | Get-AzureRmRecoveryServicesAsrProtectionContainer | Get-AzureRmRecoveryServicesAsrReplicationProtectedItem | Select-object friendlyname | export-csv "d:\output\ugo\pentasr02_RPI_$((Get-Date).ToString('yyyy-MM-dd')).csv" -NoTypeInformation 
$pentasr03items = Get-AzureRmRecoveryServicesAsrFabric -FriendlyName "dyatl-pentasr03" | Get-AzureRmRecoveryServicesAsrProtectionContainer | Get-AzureRmRecoveryServicesAsrReplicationProtectedItem | Select-object friendlyname | export-csv "d:\output\ugo\pentasr03_RPI_$((Get-Date).ToString('yyyy-MM-dd')).csv" -NoTypeInformation
$pentasr06items = Get-AzureRmRecoveryServicesAsrFabric -FriendlyName "dyatl-pentasr06" | Get-AzureRmRecoveryServicesAsrProtectionContainer | Get-AzureRmRecoveryServicesAsrReplicationProtectedItem | Select-object friendlyname | export-csv "d:\output\ugo\pentasr06_RPI_$((Get-Date).ToString('yyyy-MM-dd')).csv" -NoTypeInformation
$pentasr09items = Get-AzureRmRecoveryServicesAsrFabric -FriendlyName "dyatl-pentasr09" | Get-AzureRmRecoveryServicesAsrProtectionContainer | Get-AzureRmRecoveryServicesAsrReplicationProtectedItem | Select-object friendlyname | export-csv "d:\output\ugo\pentasr09_RPI_$((Get-Date).ToString('yyyy-MM-dd')).csv" -NoTypeInformation
$pdmzasr01items = Get-AzureRmRecoveryServicesAsrFabric -FriendlyName "dyatl-pdmzasr01" | Get-AzureRmRecoveryServicesAsrProtectionContainer | Get-AzureRmRecoveryServicesAsrReplicationProtectedItem | Select-object friendlyname | export-csv "d:\output\ugo\pdmzasr01_RPI_$((Get-Date).ToString('yyyy-MM-dd')).csv" -NoTypeInformation


#Remove vault settings file
Remove-Item -Path $VaultFileLocation.FilePath