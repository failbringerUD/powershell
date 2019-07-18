<#
.Synopsis
   Populate and remove disabled user profiles from a system
.DESCRIPTION
   Populate and remove disabled user profiles from a system
.EXAMPLE
   Run script without parameters
.EXAMPLE
   Another example of how to use this cmdlet

    THIS CODE AND ANY ASSOCIATED INFORMATION ARE PROVIDED “AS IS” WITHOUT WARRANTY OF ANY KIND, EITHER EXPRESSED OR 
    IMPLIED, INCLUDING BUT NOT LIMITED TO THE IMPLIED WARRANTIES OF MERCHANTABILITY AND/OR FITNESS FOR A PARTICULAR
    PURPOSE. THE ENTIRE RISK OF USE, INABILITY TO USE, OR RESULTS FROM THE USE OF THIS CODE REMAINS WITH THE USER.
#>


# Get computername of the remote system
$computer = read-host 'What System do you want to check?'

# Check to see if c:\delprof2\delprof2.exe exists on this system and copy over if it doesn't exist...
If (!(test-path -Path "c:\delprof2" -PathType Container ))
{
    New-Item -ItemType directory -Path "c:\delprof2" | Copy-Item -path "\\dyatl-dentau01\c$\delprof2\delprof2.exe" -Destination "c:\delprof2" -Force -PassThru -Verbose
}

# Get a list of user profiles on the $computer system, excluding Administrator and any SVC accounts
$profiles = (Get-WmiObject -Class Win32_UserProfile -ComputerName $computer | Where-Object {((!$_.Special) -and ($_.LocalPath -ne "C:\Users\Administrator") -and ($_.LocalPath -notlike "C:\Users\SVC*"))} | Select-Object localpath, sid )

# Determine which users from $profiles are disabled in Active Directory
$disabledusers = FOREACH ($localpath in $profiles)
{
    $uid = $localpath.localpath.split("\")[2]

    get-aduser $uid -properties Samaccountname, enabled | Select-Object samaccountname, enabled | Where-Object enabled -like "false"
    
}

# Ask user if they want to see the list of disabled users...
$showdisabledusers = read-host 'Do you want to see the disabled users list? (yes/no)'
If ($showdisabledusers -eq "yes")
{ 
    foreach ($samaccountname in $disabledusers)
    { 
        write-host $samaccountname.samaccountname
    }
}

Else
{
    Write-host 'Proceed at your own peril...'
}


# Ask user if they are ready to delete the profiles of disabled users
$command = read-host 'Are you ready to delete disabled user profiles? (yes/ask/no)'
If ($command -eq "yes")
{
    foreach ($samaccountname in $disabledusers)
    {
        $deleteuser = $samaccountname.samaccountname
        & 'c:\delprof2\delprof2.exe' /u /id:$deleteuser /c:\\$computer
    }
}

ElseIf ($command -eq "Ask")
{
    foreach ($samaccountname in $disabledusers)
    {
        $deleteuserask = $samaccountname.samaccountname
        $delete = read-host "Do you want to delete "$samaccountname.samaccountname" ? (yes/no)"
        If ($delete -ne "yes") {continue}
        & 'c:\delprof2\delprof2.exe' /u /id:$deleteuserask /c:\\$computer 
    }
}
Else
{
    Write-Host 'You are not prepared!'
}
