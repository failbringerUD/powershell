param (
[parameter(Mandatory=$true)]
[string]$SiteCode,
[parameter(Mandatory=$true)]
[string]$UpdateGroupName,
[parameter(Mandatory=$true)]
[string]$ImageName,
[parameter(Mandatory=$true)]
[switch]$UpdateDP
)

Function Convert-NormalDateToConfigMgrDate {
    [CmdletBinding()]
    param (
        [parameter(Mandatory=$true, ValueFromPipeline=$true)]
        [string]$starttime
    )

    [System.Management.ManagementDateTimeconverter]::ToDMTFDateTime($starttime)
}

Function create-ScheduleToken { 

##Create a SMS_ST_NonRecurring object to use as schedule token 
$SMS_ST_NonRecurring = "SMS_ST_NonRecurring"
$class_SMS_ST_NonRecurring = [wmiclass]""
$class_SMS_ST_NonRecurring.psbase.Path ="ROOT\SMS\Site_$($SiteCode):$($SMS_ST_NonRecurring)"

$scheduleToken = $class_SMS_ST_NonRecurring.CreateInstance()   
    if($scheduleToken) 
        {
        $scheduleToken.DayDuration = 0
        $scheduleToken.HourDuration = 0
        $scheduleToken.IsGMT = FALSE
        $scheduleToken.MinuteDuration = 0
        $scheduleToken.StartTime = (Convert-NormalDateToConfigMgrDate $startTime)

        $SMS_ScheduleMethods = "SMS_ScheduleMethods"
        $class_SMS_ScheduleMethods = [wmiclass]""
        $class_SMS_ScheduleMethods.psbase.Path ="ROOT\SMS\Site_$($SiteCode):$($SMS_ScheduleMethods)"
        
        $script:ScheduleString = $class_SMS_ScheduleMethods.WriteToString($scheduleToken)
        
        } 
}##### end function

#### begin function
Function create-ImageServicingSchedule {

$SMS_ImageServicingSchedule = "SMS_ImageServicingSchedule"
$class_SMS_ImageServicingSchedule = [wmiclass]""
$class_SMS_ImageServicingSchedule.psbase.Path ="ROOT\SMS\Site_$($SiteCode):$($SMS_ImageServicingSchedule)"

$SMS_ImageServicingSchedule = $class_SMS_ImageServicingSchedule.CreateInstance()

$SMS_ImageServicingSchedule.Action = 1
$SMS_ImageServicingSchedule.Schedule = "$($ScheduleString.StringData)"
# Update the Distribution Point afterwards?
if ($UpdateDP) {
    $SMS_ImageServicingSchedule.UpdateDP = $true
    }
else {
    $SMS_ImageServicingSchedule.UpdateDP = $false
    }

$schedule = $SMS_ImageServicingSchedule.Put()

$script:scheduleID = $schedule.RelativePath.Split("=")[1]

# apply Schedule to Image
$SMS_ImageServicingScheduledImage = "SMS_ImageServicingScheduledImage"
$class_SMS_ImageServicingScheduledImage = [wmiclass]""
$class_SMS_ImageServicingScheduledImage.psbase.Path ="ROOT\SMS\Site_$($SiteCode):$($SMS_ImageServicingScheduledImage)"

$SMS_ImageServicingScheduledImage = $class_SMS_ImageServicingScheduledImage.CreateInstance()

$SMS_ImageServicingScheduledImage.ImagePackageID = "$($ImagePackageID)"
$SMS_ImageServicingScheduledImage.ScheduleID = $scheduleID
$SMS_ImageServicingScheduledImage.Put() | Out-Null

} ##### end function

#### begin function
Function add-UpdateToOfflineServicingSchedule {

$UpdateGroup = Get-WmiObject -Namespace root\sms\site_$SiteCode -Class SMS_AuthorizationList | where {$_.LocalizedDisplayName -eq "$($UpdateGroupName)"}

#direct reference to the Update Group
$UpdateGroup = [wmi]"$($UpdateGroup.__PATH)"

# get every CI_ID in the Update Group
foreach ($Update in $UpdateGroup.Updates)
    {
       $Update = Get-WmiObject -Namespace root\sms\site_$SiteCode -class SMS_SoftwareUpdate | where {$_.CI_ID -eq "$($Update)"}
       [array]$CIIDs += $Update.CI_ID       
    }


foreach ($CIID in $CIIDs) {
    
    $SMS_ImageServicingScheduledUpdate = "SMS_ImageServicingScheduledUpdate"
    $class_SMS_ImageServicingScheduledUpdate = [wmiclass]""
    $class_SMS_ImageServicingScheduledUpdate.psbase.Path ="ROOT\SMS\Site_$($SiteCode):$($SMS_ImageServicingScheduledUpdate)"

    $SMS_ImageServicingScheduledUpdate = $class_SMS_ImageServicingScheduledUpdate.CreateInstance()

    $SMS_ImageServicingScheduledUpdate.ScheduleID = $scheduleID
    $SMS_ImageServicingScheduledUpdate.UpdateID = $CIID
    $SMS_ImageServicingScheduledUpdate.Put() | Out-Null
    }
} #### end function

#### begin function
Function run-OfflineServicingManager {

$Class = "SMS_ImagePackage"
$Method = "RunOfflineServicingManager"

$WMIClass = [WmiClass]"ROOT\sms\site_$($SiteCode):$Class"


$Props = $WMIClass.psbase.GetMethodParameters($Method)

$Props.PackageID = "$($ImagePackageID)"
$Props.ServerName = "$(([System.Net.Dns]::GetHostByName(($env:computerName))).Hostname)"
$Props.SiteCode = "$($SiteCode)"

$WMIClass.PSBase.InvokeMethod($Method, $Props, $Null) | Out-Null


} #end function

#### begin Function
Function get-ImagePackageID {

$script:ImagePackageID = (Get-WmiObject -Class SMS_ImagePackage -Namespace Root\SMS\site_$SiteCode | where {$_.name -eq "$($Imagename)"}).PackageID

}

############ Main Script starts here!

$schedule = $null
$ScheduleID = $null
[array]$script:CIIDs = @()
$CIID = $null
$ImagePackageID = $null


[datetime]$script:StartTime = Get-Date
get-ImagePackageID
create-ScheduleToken
create-ImageServicingSchedule
add-UpdateToOfflineServicingSchedule
run-OfflineServicingManager
