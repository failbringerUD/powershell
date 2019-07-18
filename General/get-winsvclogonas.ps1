<#
.Synopsis
  To get log on as account for windows services other than *local* or *network*
.DESCRIPTION
  Query AD for a list of servers and then for each server query services for logonname that is not LocalSystem or Network
.EXAMPLE
   Run script without parameters
.EXAMPLE
   Another example of how to use this cmdlet

   THIS CODE AND ANY ASSOCIATED INFORMATION ARE PROVIDED “AS IS” WITHOUT WARRANTY OF ANY KIND, EITHER EXPRESSED OR 
   IMPLIED, INCLUDING BUT NOT LIMITED TO THE IMPLIED WARRANTIES OF MERCHANTABILITY AND/OR FITNESS FOR A PARTICULAR
   PURPOSE. THE ENTIRE RISK OF USE, INABILITY TO USE, OR RESULTS FROM THE USE OF THIS CODE REMAINS WITH THE USER.
#>

Clear-Host

#Ask if you need a fresh list of servers
Write-Host "Do you need to generate a fresh list of servers? (yes/no)" -ForegroundColor Green
$fresh = Read-Host

if ($fresh -eq "yes") 
{
   Clear-Host
   Write-Host "Generating fresh list of servers from Active Directory, please wait..." -ForegroundColor Green 
   $computers = Get-ADComputer -Filter 'operatingsystem -like "*server*"' | select-object name   
}


foreach($computer in $computers)
{
    $servername = $computer.Name
    Write-Host -ForegroundColor Yellow "Processing server "$servername
    "Server Name - "+$servername >> C:\Temp\servers.txt
    try
    {
       Get-WmiObject -ComputerName $servername -Class win32_service -ErrorAction Stop | Select-Object * | Where-Object{($_.startname -notlike '*local*') -and ($_.startname -notlike '*network*')} | Select-Object name,startname >> C:\Temp\servers.txt
       "-------------------------------------------------------------------------------------------------------------------------------------------------" >> C:\Temp\servers.txt
       " " >> C:\Temp\servers.txt
       " " >> C:\Temp\servers.txt
    }
    catch
    {
        "Server Name - "+$servername >> C:\Temp\errors.txt
        "Not reachable" >> C:\Temp\errors.txt
        "-------------------------------------------------------------------------------------------------------------------------------------------------" >> C:\Temp\errors.txt
       " " >> C:\Temp\errors.txt
       " " >> C:\Temp\errors.txt
       Write-Host -ForegroundColor Red "Check errors file"
    }
}


<#
Junk area
 $computers = Get-ADComputer -Filter 'operatingsystem -like "*server*"' | select-object name | Set-Content C:\temp\servers.csv

 $servers = Import-Csv -path "C:\Temp\servers.csv"

#>