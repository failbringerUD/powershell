<#
Functionality: This script creates a new Software Update Group in Microsoft System Center 2012 Configuration Manager

How does it work: create-SoftwareUpdateGroup.ps1 -UpdateGroupName $Name -KnowledgeBaseIDs $KBID -SiteCode

KnowledgeBaseID can contain comma separated KnowledgeBase IDs like 981852,16795779

Author: David O'Brien, david.obrien@sepago.de

Date: 02.12.2012

#>

param (
[string]$UpdateGroupName,
[array]$KnowledgeBaseIDs,
[string]$SiteCode
)


Function create-Group {


[array]$CIIDs = @()

foreach ($KBID in $KnowledgeBaseIDs)
    {
        $KBID
        $CIID = (gwmi -ns root\sms\site_$($SiteCode) -class SMS_SoftwareUpdate | where {$_.ArticleID -eq $KBID }).CI_ID
        $CIIDs += $CIID
        
    }


$SMS_CI_LocalizedProperties = "SMS_CI_LocalizedProperties"
$class_Localization = [wmiclass]""
$class_Localization.psbase.Path ="ROOT\SMS\Site_$($SiteCode):$($SMS_CI_LocalizedProperties)"

$Localization = $class_Localization.CreateInstance()

 
$Localization.DisplayName = $UpdateGroupName
$Localization.LocaleID = 1033
 
$Description += $Localization
 
$SMSAuthorizationList = "SMS_AuthorizationList"
$class_AuthList = [wmiclass]""
$class_AuthList.psbase.Path ="ROOT\SMS\Site_$($SiteCode):$($SMSAuthorizationList)"
$AuthList = $class_AuthList.CreateInstance() 

$AuthList.Updates = $CIIDs
$AuthList.LocalizedInformation = $Description
$AuthList.Put() | Out-Null
}

create-Group