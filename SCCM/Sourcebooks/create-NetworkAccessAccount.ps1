#######
# Purpose: This script creates a new user in your Microsoft System Center Configuration Manager 2012 Site and makes it your Network Access Account
#
# Author: David O'Brien, david.obrien@sepago.de
#
# Created: 03.10.2012
#
#######

param (
[string]$SiteCode,
[string]$UserDomain,
[string]$UserName,
[string]$unencryptedPassword
)

#encrypt the Password
$SMSSite = "SMS_Site"
$class_PWD = [wmiclass]""  
$class_PWD.psbase.Path = "ROOT\SMS\site_$($SiteCode):$($SMSSite)" 
$Parameters = $class_PWD.GetMethodParameters("EncryptDataEx")
$Parameters.Data = $unencryptedPassword
$Parameters.SiteCode = $SiteCode
$encryptedPassword = $class_PWD.InvokeMethod("EncryptDataEx", $Parameters, $null)

# create the user in your site as a site local user account
$SMSSCIReserved = "SMS_SCI_Reserved"
$class_User = [wmiclass]""
$class_User.psbase.Path ="ROOT\SMS\Site_$($SiteCode):$($SMSSCIReserved)"

$user = $class_User.createInstance()
$user.ItemName = "$($UserDomain)\$($UserName)|0"
$user.ItemType = "User"
$user.UserName = $UserDomain+"\"+$UserName
$user.Availability = "0"
$user.FileType = "2"
$user.SiteCode = $SiteCode
$user.Reserved2 = $encryptedPassword.EncryptedData.ToString()
$user.Put() | Out-Null

# make the created user account your new Network Access Account
$component = gwmi -class SMS_SCI_ClientComp -Namespace root\sms\site_$SiteCode  | Where-Object {$_.ItemName -eq "Software Distribution"}
$props = $component.Props
$prop = $props | where {$_.PropertyName -eq "Network Access User Name"}
    
$prop.Value = 0
$prop.Value1 = "REG_SZ"
$prop.Value2 = $UserDomain+"\"+$UserName
    
$component.Props = $props
$component.Put() | Out-Null