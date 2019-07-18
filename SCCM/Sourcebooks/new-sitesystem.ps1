param (
[string]$SiteCode,
[string]$NewSUPServerName,
[string]$MPServer
)

Function New-System {
$Hive = "LocalMachine"
$ServerName = "$($MPServer)"
$reg = [Microsoft.Win32.RegistryKey]::OpenRemoteBaseKey([Microsoft.Win32.RegistryHive]$Hive,$ServerName,[Microsoft.Win32.RegistryView]::Registry64)
$Subkeys = $reg.OpenSubKey('SOFTWARE\Microsoft\SMS\Setup\')
$AdminConsoleDirectory = $Subkeys.GetValue('UI Installation Directory')
switch (Test-Path $AdminConsoleDirectory)
    {
        $true { Import-Module "$($AdminConsoleDirectory)\bin\ConfigurationManager.psd1" }
        $false {
                    Write-Verbose "$($AdminConsoleDirectory) does not exist. Trying alternate path under ProgramFilesx86"
                    $AdminConsoleDirectory = "C:\Program Files (x86)\Microsoft Configuration Manager\AdminConsole"
                    Import-Module "$($AdminConsoleDirectory)\bin\ConfigurationManager.psd1"
                }
    }
#CM12 cmdlets need to be run from the CM12 site drive
Set-Location "$($SiteCode):"

if (-not (Get-CMSiteSystemServer -SiteSystemServerName $NewSUPServerName -SiteCode $SiteCode)) 
    {
        New-CMSiteSystemServer -ServerName $NewSUPServerName -SiteCode $SiteCode
        # built-in cmdlets have no real error handling, so try a Get-CMSiteSystemServer again
        if (-not (Get-CMSiteSystemServer -SiteSystemServerName $NewSUPServerName -SiteCode $SiteCode))
            {
                Write-Error "The Site System $($NewSUPServerName) has not been created. Please check the logs for further information"
                exit 1
            }
    }
}

New-System 