# Variable Declaration
$CLIENT_SECRET = "Service Principal client secret"
$CLIENT_ID = "Service Principal client ID also known as Application ID"
$TENANT_ID = "AAD Tenant ID"
 
Write-Host "Logging you in..."
$secpasswd = ConvertTo-SecureString $CLIENT_SECRET -AsPlainText -Force
$mycreds = New-Object System.Management.Automation.PSCredential ($CLIENT_ID, $secpasswd)
Add-AzureRmAccount -ServicePrincipal -Tenant $TENANT_ID -Credential $mycreds
 
# Clear the contents of log file
Clear-Content -Path FILE_PATH_OF_VMSTATUS_LOG_FILE
 
# Enter the subscriptions where ASR is enabled
$Subscriptions = "An Array of subscription names that the Service Pricipal has access to (recommend Site Recovery Contributor RBAC role)"
foreach ($Subscription in $Subscriptions)
{
    # Select the subscription
    Select-AzureRmSubscription -SubscriptionName $Subscription
 
    # get the list of recovery services vaults in the subscription
    $VaultObjs = Get-AzureRmRecoveryServicesVault
    foreach ($VaultObj in $VaultObjs) 
    {
        # get and import vault settings file
        $VaultFileLocation = Get-AzureRmRecoveryServicesVaultSettingsFile -SiteRecovery -Vault $VaultObj
        Import-AzureRmRecoveryServicesAsrVaultSettingsFile -Path $VaultFileLocation.FilePath
 
        # get the list of fabrics in a vault
        $Fabrics = Get-AzureRmRecoveryServicesAsrFabric
        foreach ($Fabric in $Fabrics)
        {
            # get containers and protected items in a container
            $Containers = Get-AzureRmRecoveryServicesAsrProtectionContainer -Fabric $Fabric
            foreach ($Container in $Containers)
            {
                $items = Get-AzureRmRecoveryServicesAsrReplicationProtectedItem -ProtectionContainer $Container
                foreach ($item in $items)
                {
                    # Initialize an empty error array for capturing error(s) of each protected item
                    $ItemError = ""
                    foreach ($ASRerror in $item.ReplicationHealthErrors)
                    {
                        $ItemError=$ItemError,$ASRerror.ErrorMessage
                    }
                     
                    # Capture the status of machines which are in critical state to a file
                    If(-Not($item.ReplicationHealth -eq "Normal"))
                    {
                        $ASRVMHealthStatus=$Subscription+"`t"+$VaultObj.Name+"`t"+$Item.FriendlyName+"`t"+$Item.ReplicationHealth+"`t"+$ItemError
                        $ASRVMHealthStatus | Out-File -Append -FilePath FILE_PATH_OF_VMSTATUS_LOG_FILE
                    }
                }
            }
        }
 
        # remove vault settings file
        rm -Path $VaultFileLocation.FilePath
    }
}