<#
.SYNOPSIS
	Script to set the "Update Distribution Point on a schedule" option for every package in a folder to "occur every night at 12PM"
.DESCRIPTION
	Script to set the "Update Distribution Point on a schedule" option for every package in a folder to "occur every night at 12PM"
.PARAMETER SMSProvider
    Hostname or FQDN of a SMSProvider in the Hierarchy 
    This parameter is mandatory!
    This parameter has an alias of SMS.
.PARAMETER FolderName
    This parameter expects the name to the folder UNDER which you want to configure ALL packages.
    This parameter is mandatory!
    This parameter has an alias of FN.
.EXAMPLE
	PS C:\PSScript > .\set-UpdatePkgOnDPBySchedule.ps1 -SMSProvider cm12 -FolderName test -verbose

    This will use CM12 as SMS Provider.
    This will use "Test" as the folder in which you want all packages to get edited.
    Will give you some verbose output.
.INPUTS
	None.  You cannot pipe objects to this script.
.OUTPUTS
	No objects are output from this script.  This script creates a Word document.
.LINK
	http://www.david-obrien.net
.NOTES
	NAME: set-UpdatePkgOnDPBySchedule.ps1
	VERSION: 1.0
	AUTHOR: David O'Brien
	LASTEDIT: July 23, 2013
    Change history:
.REMARKS
	To see the examples, type: "Get-Help .\set-UpdatePkgOnDPBySchedule.ps1 -examples".
	For more information, type: "Get-Help .\set-UpdatePkgOnDPBySchedule.ps1 -detailed".
    This script will only work with Powershell 3.0.
#>

[CmdletBinding( SupportsShouldProcess = $False, ConfirmImpact = "None", DefaultParameterSetName = "" )]

param(
    [parameter(
	Position = 1, 
	Mandatory=$true )
	] 
	[Alias("SMS")]
	[ValidateNotNullOrEmpty()]
    [string]$SMSProvider = "",
    
    [parameter(
	Position = 2, 
	Mandatory=$true )
	] 
	[Alias("FN")]
	[ValidateNotNullOrEmpty()]
    [string]$FolderName = ""
)

Function Get-SiteCode
{
    $wqlQuery = “SELECT * FROM SMS_ProviderLocation”
    $a = Get-WmiObject -Query $wqlQuery -Namespace “root\sms” -ComputerName $SMSProvider
    $a | ForEach-Object {
        if($_.ProviderForLocalSite)
            {
                $script:SiteCode = $_.SiteCode
            }
    }
return $SiteCode
}

Function Convert-NormalDateToConfigMgrDate {
    [CmdletBinding()]
    param (
        [parameter(Mandatory=$true, ValueFromPipeline=$true)]
        [string]$starttime
    )

    return [System.Management.ManagementDateTimeconverter]::ToDMTFDateTime($starttime)
}

Function create-ScheduleToken {

$SMS_ST_RecurInterval = "SMS_ST_RecurInterval"
$class_SMS_ST_RecurInterval = [wmiclass]""
$class_SMS_ST_RecurInterval.psbase.Path ="\\$($SMSProvider)\ROOT\SMS\Site_$($SiteCode):$($SMS_ST_RecurInterval)"

$script:scheduleToken = $class_SMS_ST_RecurInterval.CreateInstance()   
    if($scheduleToken) 
        {
        $scheduleToken.DayDuration = 0
        $scheduleToken.DaySpan = 1
        $scheduleToken.HourDuration = 0
        $scheduleToken.HourSpan = 0
        $scheduleToken.IsGMT = $false
        $scheduleToken.MinuteDuration = 0
        $scheduleToken.MinuteSpan = 0
        $scheduleToken.StartTime = (Convert-NormalDateToConfigMgrDate $startTime)
        }
}

[datetime]$startTime = [datetime]::Today

$SiteCode = Get-SiteCode

create-ScheduleToken

$FolderID = (Get-WmiObject -Class SMS_ObjectContainerNode -Namespace "root\SMS\site_$($SiteCode)" -ComputerName $SMSProvider -Filter "Name = '$($FolderName)'").ContainerNodeID
$Packages = (Get-WmiObject -Class SMS_ObjectContainerItem -Namespace "root\SMS\site_$($SiteCode)" -ComputerName $SMSProvider -Filter "ContainerNodeID = '$($FolderID)'").InstanceKey

foreach ($Pkg in $Packages)
    {
        try 
            {
                $Pkg = Get-WmiObject -Class SMS_Package -Namespace root\sms\site_$SiteCode -ComputerName $SMSProvider -Filter "PackageID ='$($Pkg)'"
                $Pkg = [wmi]$Pkg.__PATH
                $Pkg.RefreshSchedule = $scheduletoken
                $Pkg.put() | Out-Null
                Write-Verbose "Successfully edited package $($Pkg.Name)."
            }
        catch
            {
                Write-Verbose "$($Pkg.Name) could not be edited."
            }
    }