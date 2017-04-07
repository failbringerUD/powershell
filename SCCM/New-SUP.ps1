[CmdletBinding()]
param (
[string]$SiteCode,
[string]$NewSUPServerName,
[string]$MPServer,
[string]$DBServerName,
[string]$DBServerInstance,
[string]$WSUSContentPath
)

Function Set-Property
{
    PARAM(
        $MPServer,
        $SiteCode,
        $PropertyName,
        $Value,
        $Value1,
        $Value2
    )

    $embeddedproperty_class = [wmiclass]""
    $embeddedproperty_class.psbase.Path = "\\$($MPServer)\ROOT\SMS\Site_$($SiteCode):SMS_EmbeddedProperty"
    $embeddedproperty = $embeddedproperty_class.createInstance()
    
    $embeddedproperty.PropertyName = $PropertyName
    $embeddedproperty.Value = $Value
    $embeddedproperty.Value1 = $Value1
    $embeddedproperty.Value2 = $Value2
    
    return $embeddedproperty
}

Function new-SUP {
############### Create Site System ################################################

#CM12 built-in cmdlets need to run in x86 powershell, that's why it's called directly from here via another script
C:\windows\SysWOW64\WindowsPowerShell\v1.0\powershell.exe -file ".\new-sitesystem.ps1" -SiteCode $SiteCode -MPServer $MPServer -NewSUPServerName $NewSUPServerName

# connect to SMS Provider for Site
$role_class             = [wmiclass]""
$role_class.psbase.Path = "\\$($MPServer)\ROOT\SMS\Site_$($SiteCode):SMS_SCI_SysResUse"
$role                     = $role_class.createInstance()
#create the SMS Distribution Point Role
$role.NALPath     = "[`"Display=\\$NewSUPServerName\`"]MSWNET:[`"SMS_SITE=$SiteCode`"]\\$NewSUPServerName\"
$role.NALType     = "Windows NT Server"
$role.RoleName     = "SMS Software Update Point"
$role.SiteCode     = "$($SiteCode)"



$role.Props += [System.Management.ManagementBaseObject](Set-Property -MPServer $MPServer -sitecode $sitecode -PropertyName "UseProxy" -value 0 -value1 '' -value2 '')
$role.Props += [System.Management.ManagementBaseObject](Set-Property -MPServer $MPServer -sitecode $sitecode -PropertyName "ProxyName" -value 0 -value1 '' -value2 '')
$role.Props += [System.Management.ManagementBaseObject](Set-Property -MPServer $MPServer -sitecode $sitecode -PropertyName "ProxyServerPort" -value 80 -value1 '' -value2 '')
$role.Props += [System.Management.ManagementBaseObject](Set-Property -MPServer $MPServer -sitecode $sitecode -PropertyName "AnonymousProxyAccess" -value 1 -value1 '' -value2 '')
$role.Props += [System.Management.ManagementBaseObject](Set-Property -MPServer $MPServer -sitecode $sitecode -PropertyName "UserName" -value 0 -value1 '' -value2 '')
$role.Props += [System.Management.ManagementBaseObject](Set-Property -MPServer $MPServer -sitecode $sitecode -PropertyName "UseProxyForADR" -value 0 -value1 '' -value2 '')
$role.Props += [System.Management.ManagementBaseObject](Set-Property -MPServer $MPServer -sitecode $sitecode -PropertyName "IsIntranet" -value 1 -value1 '' -value2 '')
$role.Props += [System.Management.ManagementBaseObject](Set-Property -MPServer $MPServer -sitecode $sitecode -PropertyName "Enabled" -value 1 -value1 '' -value2 '')
$role.Props += [System.Management.ManagementBaseObject](Set-Property -MPServer $MPServer -sitecode $sitecode -PropertyName "DBServerName" -value 0 -value1 '' -value2 '$($DBServerName\$DBServerInstance)')
$role.Props += [System.Management.ManagementBaseObject](Set-Property -MPServer $MPServer -sitecode $sitecode -PropertyName "NLBVIP" -value 0 -value1 '' -value2 '')
$role.Props += [System.Management.ManagementBaseObject](Set-Property -MPServer $MPServer -sitecode $sitecode -PropertyName "WSUSIISPort" -value 8530 -value1 '' -value2 '')
$role.Props += [System.Management.ManagementBaseObject](Set-Property -MPServer $MPServer -sitecode $sitecode -PropertyName "WSUSIISSSLPort" -value 8531 -value1 '' -value2 '')
$role.Props += [System.Management.ManagementBaseObject](Set-Property -MPServer $MPServer -sitecode $sitecode -PropertyName "SSLWSUS" -value 0 -value1 '' -value2 '')
$role.Props += [System.Management.ManagementBaseObject](Set-Property -MPServer $MPServer -sitecode $sitecode -PropertyName "UseParentWSUS" -value 0 -value1 '' -value2 '')
$role.Props += [System.Management.ManagementBaseObject](Set-Property -MPServer $MPServer -sitecode $sitecode -PropertyName "WSUSAccessAccount" -value 0 -value1 '' -value2 '')
$role.Props += [System.Management.ManagementBaseObject](Set-Property -MPServer $MPServer -sitecode $sitecode -PropertyName "IsINF" -value 0 -value1 '' -value2 '')
$role.Props += [System.Management.ManagementBaseObject](Set-Property -MPServer $MPServer -sitecode $sitecode -PropertyName "PublicVIP" -value 0 -value1 '' -value2 '')

$role.Put()

}

Function Install-WSUS { 

if (-not (Get-WindowsFeature -Name UpdateServices).Installed -eq $true)
    {
        Install-WindowsFeature -Name UpdateServices-DB, UpdateServices-Ui -IncludeManagementTools -LogPath C:\Windows\System32\LogFiles\WSUSInstall.log
        $command = ". `"$env:ProgramFiles\Update Services\Tools\WsusUtil.exe`" PostInstall SQL_INSTANCE_NAME=$DBServerName\$DBServerInstance CONTENT_DIR=$WSUSContentPath"
        Invoke-Expression -Command $command 
        Write-Host "WSUS installed and configured"
    }
else
    {
        Write-Host "WSUS is already installed and configured"

    }

}

######################### Main script starts here ###################

Install-WSUS


$SiteControlFile = Invoke-WmiMethod -Namespace "root\SMS\site_$SiteCode" -class "SMS_SiteControlFile" -name "GetSessionHandle" -ComputerName $MPServer
Invoke-WmiMethod -Namespace "root\SMS\site_$SiteCode" -class "SMS_SiteControlFile" -name "RefreshSCF" -ArgumentList $SiteCode -ComputerName $MPServer | Out-Null
new-SUP 
Invoke-WmiMethod -Namespace "root\SMS\site_$SiteCode" -class "SMS_SiteControlFile" -name "CommitSCF" $SiteCode -ComputerName $MPServer | Out-Null
$SiteControlFile = Invoke-WmiMethod -Namespace "root\SMS\site_$SiteCode" -class "SMS_SiteControlFile" -name "ReleaseSessionHandle" -ArgumentList $SiteControlFile.SessionHandle -ComputerName $MPServer