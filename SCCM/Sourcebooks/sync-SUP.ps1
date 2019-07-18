[CmdletBinding( SupportsShouldProcess = $False, ConfirmImpact = "None", DefaultParameterSetName = "" )]

param(
[string]$SMSProvider
)

Function Get-SiteCode
{
    $wqlQuery = “SELECT * FROM SMS_ProviderLocation”
    $a = Get-WmiObject -Query $wqlQuery -Namespace “root\sms” -ComputerName $SMSProvider
    $a | ForEach-Object {
    if($_.ProviderForLocalSite)
        {
            $siteCode = $_.SiteCode
        }
}

return $sitecode | Out-Null
}

Get-SiteCode

$SUP = [wmiclass]("\\$SMSProvider\root\SMS\Site_$($SiteCode):SMS_SoftwareUpdate")
$Params = $SUP.GetMethodParameters("SyncNow")
$Params.fullSync = $true
$Return = $SUP.SyncNow($Params)

if ($Return.ReturnValue -eq "0")
    {
        Write-Verbose "Sync of SUP successful"
    }
else
    {
        Write-Verbose "There was an error syncing the SUP"
    }