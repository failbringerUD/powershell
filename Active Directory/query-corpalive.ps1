<#
.Synopsis
   Query IP addresses if they are alive or not, then resolve the list to hostnames
.DESCRIPTION
   Query IP addresses if they are alive or not, IP addresses from predefined list, then resolve to hostnames
.EXAMPLE
   Run script without parameters
.EXAMPLE
   Another example of how to use this cmdlet

    THIS CODE AND ANY ASSOCIATED INFORMATION ARE PROVIDED “AS IS” WITHOUT WARRANTY OF ANY KIND, EITHER EXPRESSED OR 
    IMPLIED, INCLUDING BUT NOT LIMITED TO THE IMPLIED WARRANTIES OF MERCHANTABILITY AND/OR FITNESS FOR A PARTICULAR
    PURPOSE. THE ENTIRE RISK OF USE, INABILITY TO USE, OR RESULTS FROM THE USE OF THIS CODE REMAINS WITH THE USER.
#>

$servers = get-adcomputer -filter 'OperatingSystem -like "*server*"' -SearchBase "DC=corp,DC=local" -Server dyatl-pentdc05.corp.local -Properties dnshostname,distinguishedname,operatingsystem 
$rtn = $null
$date = get-date -Format -yyyyMMdd
$alivetemp = @()
$deadtemp = @()
$aliveresults = "c:\temp\corp_alive_resolved_$date.txt"
$deadresults = "c:\temp\corp_dead_resolved_$date.txt"
$AliveResultList = @()
$DeadResultList = @()

Clear-Host
Write-Host "Please enter your email address:" -ForegroundColor Green
$emailaddress = Read-Host

Write-host "Querying corp.local domain for all computer objects that have an Operating System like *server*..." -ForegroundColor Green
Write-host "I found $($servers.count) systems..." -ForegroundColor Green

Write-Host "Ok...now we're going to process through this list to see what is alive, hold tight......" -ForegroundColor Green

#Query the list of IPs to see if they are alive or not...
ForEach($server in $servers) 
{
      $rtn = Test-Connection -computername $server.dnshostname -Count 1 -BufferSize 16 -Quiet
      IF($rtn -match 'True'){$alivetemp += "$($server.dnshostname)" }
      Else{$deadtemp += "$($server.dnshostname)" }
}

#Lets resolve each of the alive IP addresses
Write-Host "Resolving IP addresses of the systems that I found..." -ForegroundColor Green
$aliveIPs = $alivetemp
$deadIPs = $deadtemp

Foreach ($aliveip in $aliveIPs)
{
    $result = $null
    $currentEAP = $ErrorActionPreference
    $ErrorActionPreference = "silentlycontinue"
    $result = [System.Net.Dns]::gethostentry("$aliveip")
    $ErrorActionPreference = $currentEAP
    
    If ($Result)
    {
        $AliveResultlist += "$aliveIP - $([string]$Result.HostName)"
    }
    Else
    {
        $AliveResultlist += "$aliveIP - No HostNameFound"
    }
}
      
foreach ($deadip in $deadIPs)
{
    $result = $null
    $currentEAP = $ErrorActionPreference
    $ErrorActionPreference = "silentlycontinue"
    $result = [System.Net.Dns]::gethostentry("$deadip")
    $ErrorActionPreference = $currentEAP
      
    If ($Result)
    {
        $deadResultlist += "$deadIP - $([string]$Result.HostName)"
    }
    Else
    {
        $deadResultlist += "$deadIP - No HostNameFound"
    }
}
       
      
#Output results to text files...
$aliveresultlist | Out-File $aliveresults
$DeadResultList | Out-File $deadresults

#set variables for sending email
$fromaddressalive = "WeAreAlive@dycominc.com"
$fromaddressdead = "WeAreDead@dycominc.com"
$toaddress = $emailaddress
#$ccaddress = @('ryan.leslie@dycominc.com','charles.whitehead@dycominc.com')
$messagesubjectalive = "These systems are alive :D $date"
$messagesubjectdead = "These systems are dead :'( $date" 
$smtpserver = "smtp.dynutil.com"
$messagebody = @"
This is the results of running the query-corpalive.ps1 script...
"@
$attachmentalive = $aliveresults
$attachmentdead = $deadresults

#send the email...
write-host "Sending email of report to $toaddress"
Send-MailMessage -To $toaddress -From $fromaddressalive -Subject $messagesubjectalive -Body -$messagebody -Attachments $attachmentalive -SmtpServer $smtpserver
Send-MailMessage -To $toaddress -From $fromaddressdead -Subject $messagesubjectdead -Body -$messagebody -Attachments $attachmentdead -SmtpServer $smtpserver