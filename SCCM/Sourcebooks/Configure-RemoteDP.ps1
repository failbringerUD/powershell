param(
[parameter(Mandatory=$true)]
[String]$ServerName,
[parameter(Mandatory=$true)]
[String]$SiteCode
)

# Set the schedules first!
#Array containing 24 elements, one for each hour of the day. A value of true indicates that the address (sender) embedding SMS_SiteControlDaySchedule can be used as a backup.
$UsageAsBackup = @($true,$true,$true,$true,$true,$true,$true,$true,$true,$true,$true,$true,$true,$true,$true,$true,$true,$true,$true,$true,$true,$true,$true,$true)
#Array containing 24 elements, one for each hour of the day. This property specifies the type of usage for each hour.
# 1 means all Priorities, 2 means all but low, 3 is high only, 4 means none
$HourUsageSchedule = @(4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4)
#Set RateLimitingSchedule, array for every hour of the day, percentage of how much bandwidth can be used, min 1, max 100
$RateLimitingSchedule = @(10,20,30,40,50,60,70,80,90,100,90,80,70,60,50,40,30,20,10,70,10,20,30,40)

$SMS_SCI_ADDRESS = "SMS_SCI_ADDRESS"
$class_SMS_SCI_ADDRESS = [wmiclass]""
$class_SMS_SCI_ADDRESS.psbase.Path ="ROOT\SMS\Site_$($SiteCode):$($SMS_SCI_ADDRESS)"

$SMS_SCI_ADDRESS = $class_SMS_SCI_ADDRESS.CreateInstance()

# Set the UsageSchedule
$SMS_SiteControlDaySchedule           = "SMS_SiteControlDaySchedule"
$SMS_SiteControlDaySchedule_class     = [wmiclass]""
$SMS_SiteControlDaySchedule_class.psbase.Path = "ROOT\SMS\Site_$($SiteCode):$($SMS_SiteControlDaySchedule)"
$SMS_SiteControlDaySchedule	          = $SMS_SiteControlDaySchedule_class.createInstance()
$SMS_SiteControlDaySchedule.Backup    = $UsageAsBackup
$SMS_SiteControlDaySchedule.HourUsage = $HourUsageSchedule
$SMS_SiteControlDaySchedule.Update    = $true
$SMS_SCI_ADDRESS.UsageSchedule        = @($SMS_SiteControlDaySchedule,$SMS_SiteControlDaySchedule,$SMS_SiteControlDaySchedule,$SMS_SiteControlDaySchedule,$SMS_SiteControlDaySchedule,$SMS_SiteControlDaySchedule,$SMS_SiteControlDaySchedule)

$SMS_SCI_ADDRESS.RateLimitingSchedule = $RateLimitingSchedule

$SMS_SCI_ADDRESS.AddressPriorityOrder = "0"
$SMS_SCI_ADDRESS.AddressType          = "MS_LAN"
$SMS_SCI_ADDRESS.DesSiteCode          = "$($ServerName)"
$SMS_SCI_ADDRESS.DestinationType      = "1"
$SMS_SCI_ADDRESS.SiteCode             = "$($SiteCode)"
$SMS_SCI_ADDRESS.UnlimitedRateForAll  = $false

# Set the embedded Properties
$embeddedpropertyList = $null
$embeddedproperty_class = [wmiclass]""
$embeddedproperty_class.psbase.Path = "ROOT\SMS\Site_$($SiteCode):SMS_EmbeddedPropertyList"
$embeddedpropertyList 				= $embeddedproperty_class.createInstance()
$embeddedpropertyList.PropertyListName 	= "Pulse Mode"
$embeddedpropertyList.Values		= @(0,5,8) #second value is size of data block in KB, third is delay between data blocks in seconds
$SMS_SCI_ADDRESS.PropLists += $embeddedpropertyList

$embeddedproperty = $null   
$embeddedproperty_class = [wmiclass]""
$embeddedproperty_class.psbase.Path = "ROOT\SMS\Site_$($SiteCode):SMS_EmbeddedProperty"
$embeddedproperty 				= $embeddedproperty_class.createInstance()
$embeddedproperty.PropertyName 	= "Connection Point"
$embeddedproperty.Value 		= "0"
$embeddedproperty.Value1		= "$($ServerName)"
$embeddedproperty.Value2		= "SMS_DP$"		
$SMS_SCI_ADDRESS.Props += $embeddedproperty

$embeddedproperty = $null
$embeddedproperty_class = [wmiclass]""
$embeddedproperty_class.psbase.Path = "ROOT\SMS\Site_$($SiteCode):SMS_EmbeddedProperty"
$embeddedproperty 				= $embeddedproperty_class.createInstance()
$embeddedproperty.PropertyName 	= "LAN Login"
$embeddedproperty.Value 		= "0"
$embeddedproperty.Value1		= ""
$embeddedproperty.Value2		= ""		
$SMS_SCI_ADDRESS.Props += $embeddedproperty


$SMS_SCI_ADDRESS.Put() | Out-Null
