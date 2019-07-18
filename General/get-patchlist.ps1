<#
.Synopsis
  To get list of installed hotfixes installed on server
.DESCRIPTION
  Query server for list of installed hotfixes. Server list is located in c:\temp\servers.txt
.EXAMPLE
   Run script without parameters
.EXAMPLE
   Another example of how to use this cmdlet

   THIS CODE AND ANY ASSOCIATED INFORMATION ARE PROVIDED “AS IS” WITHOUT WARRANTY OF ANY KIND, EITHER EXPRESSED OR 
   IMPLIED, INCLUDING BUT NOT LIMITED TO THE IMPLIED WARRANTIES OF MERCHANTABILITY AND/OR FITNESS FOR A PARTICULAR
   PURPOSE. THE ENTIRE RISK OF USE, INABILITY TO USE, OR RESULTS FROM THE USE OF THIS CODE REMAINS WITH THE USER.
#>

$servers = get-content C:\temp\servers.txt

$cred = Get-Credential

foreach($server in $servers)
    {
      get-hotfix -ComputerName $server -Credential $cred | Select-Object pscomputername,Description,HotFixID,InstalledOn | Sort-Object InstalledOn -Descending| Export-Csv c:\temp\$server.csv -NoTypeInformation
    }