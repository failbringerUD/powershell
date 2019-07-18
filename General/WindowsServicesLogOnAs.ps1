##########################################################
#
#
# Author : Sachin Chavan
#
# Created : Apr 10th, 2017
#
# Synopsis : To get log on as account for windows services
#            other than *local* or *network*
#
##########################################################

#region ####Run this region only when you want a fresh list of servers####

<#$computers=Get-ADComputer -Filter 'operatingsystem -like "*server*"'
"name" | Set-Content C:\WorkStuff\PowerShell\servers.csv
foreach($computer in $computers)
{
    $computer.name | Add-Content C:\WorkStuff\PowerShell\servers.csv
}#>

#endregion

$servers=Import-Csv -path "C:\WorkStuff\PowerShell\servers.csv"

foreach($server in $servers)
{
    $servername=$server.Name
    Write-Host -ForegroundColor Yellow "Processing server "$servername
    "Server Name - "+$servername >> C:\WorkStuff\PowerShell\servers.txt
    try
    {
       Get-WmiObject -ComputerName $servername -Class win32_service -ErrorAction Stop | select * | ?{($_.startname -notlike '*local*') -and ($_.startname -notlike '*network*')} | select name,startname >> C:\WorkStuff\PowerShell\servers.txt
       "-------------------------------------------------------------------------------------------------------------------------------------------------" >> C:\WorkStuff\PowerShell\servers.txt
       " " >> C:\WorkStuff\PowerShell\servers.txt
       " " >> C:\WorkStuff\PowerShell\servers.txt
    }
    catch
    {
        "Server Name - "+$servername >> C:\WorkStuff\PowerShell\errors.txt
        "Not reachable" >> C:\WorkStuff\PowerShell\errors.txt
        "-------------------------------------------------------------------------------------------------------------------------------------------------" >> C:\WorkStuff\PowerShell\errors.txt
       " " >> C:\WorkStuff\PowerShell\errors.txt
       " " >> C:\WorkStuff\PowerShell\errors.txt
       Write-Host -ForegroundColor Red "Check errors file"
    }
}