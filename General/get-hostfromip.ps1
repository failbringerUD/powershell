<#
.Synopsis
    Get hostname from IP Address
.DESCRIPTION
    Get hostname from a list of IP addresses 
.EXAMPLE
   Run script without parameters
.EXAMPLE
   Another example of how to use this cmdlet

    THIS CODE AND ANY ASSOCIATED INFORMATION ARE PROVIDED “AS IS” WITHOUT WARRANTY OF ANY KIND, EITHER EXPRESSED OR 
    IMPLIED, INCLUDING BUT NOT LIMITED TO THE IMPLIED WARRANTIES OF MERCHANTABILITY AND/OR FITNESS FOR A PARTICULAR
    PURPOSE. THE ENTIRE RISK OF USE, INABILITY TO USE, OR RESULTS FROM THE USE OF THIS CODE REMAINS WITH THE USER.
#>

$date = get-date -Format -yyyyMMdd
$aliveIPs = Get-Content "d:\output\ugo\live_servers_$date.txt"
$deadIPs = Get-Content "D:\Output\ugo\not_alive_servers_$date.txt"
$aliveresults = "d:\output\ugo\alive_resolved_$date.txt"
$deadresults = "d:\output\ugo\dead_resolved_$date.txt"
 
#Lets create a blank array for the resolved names
$AliveResultList = @()
$DeadResultList = @()

#Lets resolve each of the alive IP addresses

foreach ($aliveip in $aliveIPs)
{
     $result = $null
     $currentEAP = $ErrorActionPreference
     $ErrorActionPreference = "silentlycontinue"
 
     #Use the DNS Static .Net class for the reverse lookup
     # details on this method found here: http://msdn.microsoft.com/en-us/library/ms143997.aspx
     $result = [System.Net.Dns]::gethostentry($ip)
     $ErrorActionPreference = $currentEAP
  

     If ($Result)
     {
          $AliveResultlist += [string]$Result.HostName
     }

     Else
     {
          $AliveResultlist += "$IP - No HostNameFound"
     }
}

foreach ($deadip in $deadIPs)
{
     $result = $null
     $currentEAP = $ErrorActionPreference
     $ErrorActionPreference = "silentlycontinue"
 
     #Use the DNS Static .Net class for the reverse lookup
     # details on this method found here: http://msdn.microsoft.com/en-us/library/ms143997.aspx
     $result = [System.Net.Dns]::gethostentry($ip)
     $ErrorActionPreference = $currentEAP
  

     If ($Result)
     {
          $deadResultlist += [string]$Result.HostName
     }

     Else
     {
          $deadResultlist += "$IP - No HostNameFound"
     }
}
 

#Output results to text files...
$aliveresultlist | Out-File $aliveresults
$DeadResultList | Out-File $deadresults