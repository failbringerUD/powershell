<#
.Synopsis
   Runs windows update on system
.DESCRIPTION
   Using PSWindowsUpdate powershell module, run Windows update on a system, specifying a list of KBs to install.
   Server list is located in c:\temp\servers.txt
   KB list is located in c:\temp\kb.txt
.EXAMPLE
   Run script without parameters
.EXAMPLE
   Another example of how to use this cmdlet

                             THIS CODE AND ANY ASSOCIATED INFORMATION ARE PROVIDED “AS IS” WITHOUT WARRANTY OF ANY KIND, EITHER EXPRESSED OR 
                             IMPLIED, INCLUDING BUT NOT LIMITED TO THE IMPLIED WARRANTIES OF MERCHANTABILITY AND/OR FITNESS FOR A PARTICULAR
                             PURPOSE. THE ENTIRE RISK OF USE, INABILITY TO USE, OR RESULTS FROM THE USE OF THIS CODE REMAINS WITH THE USER.


#>

function Load-Module ($m) {
    # If module is imported say that and do nothing
    if (Get-Module | Where-Object {$_.Name -eq $m}) {
        write-host "Module $m is already imported."
    } else {
        # If module is not imported, but available on disk then import
        if (Get-Module -ListAvailable | Where-Object {$_.Name -eq $m}) {
            Import-Module $m
        } else {
            # If module is not imported, not available on disk, but is in online gallery then install and import
            if (Find-Module -Name $m | Where-Object {$_.Name -eq $m}) {
                Install-Module -Name $m -Force -Verbose -Scope CurrentUser -AllowClobber
                Import-Module $m
            } else {
                # If module is not imported, not available and not in online gallery then abort
                write-host "Module $m not imported, not available and not in online gallery, exiting."
                EXIT 1
            }
        }
    }
}


#Load PSWindowsUpdate module
Load-Module "PSWindowsUpdate"

#Get list of servers to update 
$servers = Get-Content c:\temp\servers.txt

#Get list of KBs to install
$kbs = get-content c:\temp\kb.txt

#Prompt for admin credentials
Write-Host "Please enter administrator credentials in the format adm.dii.xxxxxx@dynutil.com" -ForegroundColor Green
$cred = Get-Credential

#Run Windows Update on system....
foreach($server in $servers){get-windowsupdate -ComputerName $server -AcceptAll -Install -IgnoreReboot}