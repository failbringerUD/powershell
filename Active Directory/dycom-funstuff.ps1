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

#dynutil servers
$dynutilservers = get-adcomputer -filter "OperatingSystem -like '*2003*'" | Select-Object name
$dynutilrtn = $null
$date = get-date -Format -yyyyMMdd
$dynutilalivetemp = @()
$dynutildeadtemp = @()
$dynutilaliveresults = "c:\temp\dynutil_alive_resolved_$date.txt"
$dynutildeadresults = "c:\temp\dynutil_dead_resolved_$date.txt"
$dynutilAliveResultList = @()
$dynutilDeadResultList = @()

#cva servers
$cvaservers = get-adcomputer -filter "OperatingSystem -like '*2003*'" -SearchBase "DC=cva,DC=local" -server "dyatl-pentdc07.cva.local" | Select-Object name
$cvartn = $null
$date = get-date -Format -yyyyMMdd
$cvaalivetemp = @()
$cvadeadtemp = @()
$cvaaliveresults = "c:\temp\cva_alive_resolved_$date.txt"
$cvadeadresults = "c:\temp\cva_dead_resolved_$date.txt"
$cvaAliveResultList = @()
$cvaDeadResultList = @()

#corp servers
$corpservers = get-adcomputer -filter "OperatingSystem -like '*2003*'" -SearchBase "DC=corp,DC=local" -Server "dyatl-pentdc05.corp.local" | Select-Object name
$corprtn = $null
$date = get-date -Format -yyyyMMdd
$corpalivetemp = @()
$corpdeadtemp = @()
$corpaliveresults = "c:\temp\corp_alive_resolved_$date.txt"
$corpdeadresults = "c:\temp\corp_dead_resolved_$date.txt"
$corpAliveResultList = @()
$corpDeadResultList = @()

Clear-Host
Write-Host "Please enter your email address:" -ForegroundColor Green
$emailaddress = Read-Host

#process dynutil.com
Write-Host "Ok...now we're going to process through the dynutil.com servers, hold tight......" -ForegroundColor Green

#Query the list of IPs to see if they are alive or not...
ForEach($dynutilserver in $dynutilservers) 
{
      $dynutilrtn = Test-Connection $dynutilserver.name -Count 1 -BufferSize 16 -Quiet
      IF($dynutilrtn -match 'True'){$dynutilalivetemp += "$($dynutilserver)" }
      Else{$dynutildeadtemp += "$($dynutilserver)" }
}

#Lets resolve each of the alive IP addresses
$dynutilaliveIPs = $dynutilalivetemp
$dynutildeadIPs = $dynutildeadtemp

Foreach ($dynutilaliveip in $dynutilaliveIPs)
{
    $dynutilresult = $null
    $currentEAP = $ErrorActionPreference
    $ErrorActionPreference = "silentlycontinue"
    $dynutilresult = [System.Net.Dns]::gethostentry("$dynutilaliveip")
    $ErrorActionPreference = $currentEAP
    
    If ($dynutilResult)
    {
        $dynutilAliveResultlist += "$dynutilaliveIP - $([string]$dynutilResult.HostName)"
    }
    Else
    {
        $dynutilAliveResultlist += "$dynutilaliveIP - No HostNameFound"
    }
}
      
foreach ($dynutildeadip in $dynutildeadIPs)
{
    $dynutilresult = $null
    $currentEAP = $ErrorActionPreference
    $ErrorActionPreference = "silentlycontinue"
    $dynutilresult = [System.Net.Dns]::gethostentry("$dynutildeadip")
    $ErrorActionPreference = $currentEAP
      
    If ($dynutilResult)
    {
        $dynutildeadResultlist += "$dynutildeadIP - $([string]$dynutilResult.HostName)"
    }
    Else
    {
        $dynutildeadResultlist += "$dynutildeadIP - No HostNameFound"
    }
}
       
      
#Output results to text files...
$dynutilaliveresultlist | Out-File $dynutilaliveresults
$dynutilDeadResultList | Out-File $dynutildeadresults

#process cva
Write-Host "Ok...now we're going to process through the cva.local servers, hold tight......" -ForegroundColor Green

#Query the list of IPs to see if they are alive or not...
ForEach($cvaserver in $cvaservers) 
{
      $cvartn = Test-Connection $cvaserver.name -Count 1 -BufferSize 16 -Quiet
      IF($cvartn -match 'True'){$cvaalivetemp += "$($cvaserver)" }
      Else{$cvadeadtemp += "$($cvaserver)" }
}

#Lets resolve each of the alive IP addresses
$cvaaliveIPs = $cvaalivetemp
$cvadeadIPs = $cvadeadtemp

Foreach ($cvaaliveip in $cvaaliveIPs)
{
    $cvaresult = $null
    $currentEAP = $ErrorActionPreference
    $ErrorActionPreference = "silentlycontinue"
    $cvaresult = [System.Net.Dns]::gethostentry("$cvaaliveip")
    $ErrorActionPreference = $currentEAP
    
    If ($cvaResult)
    {
        $cvaAliveResultlist += "$cvaaliveIP - $([string]$cvaResult.HostName)"
    }
    Else
    {
        $cvaAliveResultlist += "$cvaaliveIP - No HostNameFound"
    }
}
      
foreach ($cvadeadip in $cvadeadIPs)
{
    $cvaresult = $null
    $currentEAP = $ErrorActionPreference
    $ErrorActionPreference = "silentlycontinue"
    $cvaresult = [System.Net.Dns]::gethostentry("$cvadeadip")
    $ErrorActionPreference = $currentEAP
      
    If ($cvaResult)
    {
        $cvadeadResultlist += "$cvadeadIP - $([string]$cvaResult.HostName)"
    }
    Else
    {
        $cvadeadResultlist += "$cvadeadIP - No HostNameFound"
    }
}
       
      
#Output results to text files...
$cvaaliveresultlist | Out-File $cvaaliveresults
$cvaDeadResultList | Out-File $cvadeadresults

#process corp
Write-Host "Ok...now we're going to process through the corp.local servers, hold tight......" -ForegroundColor Green

#Query the list of IPs to see if they are alive or not...
ForEach($corpserver in $corpservers) 
{
      $corprtn = Test-Connection $corpserver.name -Count 1 -BufferSize 16 -Quiet
      IF($corprtn -match 'True'){$corpalivetemp += "$($corpserver)" }
      Else{$corpdeadtemp += "$($corpserver)" }
}

#Lets resolve each of the alive IP addresses
$corpaliveIPs = $corpalivetemp
$corpdeadIPs = $corpdeadtemp

Foreach ($corpaliveip in $corpaliveIPs)
{
    $corpresult = $null
    $currentEAP = $ErrorActionPreference
    $ErrorActionPreference = "silentlycontinue"
    $corpresult = [System.Net.Dns]::gethostentry("$corpaliveip")
    $ErrorActionPreference = $currentEAP
    
    If ($corpResult)
    {
        $corpAliveResultlist += "$corpaliveIP - $([string]$corpResult.HostName)"
    }
    Else
    {
        $corpAliveResultlist += "$corpaliveIP - No HostNameFound"
    }
}
      
foreach ($corpdeadip in $corpdeadIPs)
{
    $corpresult = $null
    $currentEAP = $ErrorActionPreference
    $ErrorActionPreference = "silentlycontinue"
    $corpresult = [System.Net.Dns]::gethostentry("$corpdeadip")
    $ErrorActionPreference = $currentEAP
      
    If ($corpResult)
    {
        $corpdeadResultlist += "$corpdeadIP - $([string]$corpResult.HostName)"
    }
    Else
    {
        $corpdeadResultlist += "$corpdeadIP - No HostNameFound"
    }
}
       
      
#Output results to text files...
$corpaliveresultlist | Out-File $corpaliveresults
$corpDeadResultList | Out-File $corpdeadresults



#set variables for sending email
$fromaddressalive = "WeAreAlive@dycominc.com"
$fromaddressdead = "WeAreDead@dycominc.com"
$toaddress = $emailaddress
#$ccaddress = @('ryan.leslie@dycominc.com','charles.whitehead@dycominc.com')
$messagesubjectalive = "These systems are alive :D $date"
$messagesubjectdead = "These systems are dead :'( $date" 
$smtpserver = "smtp.dynutil.com"
$messagebody = @"
This is the results of running the script...
"@

#send the email...
write-host "Sending email of report to $toaddress"
Send-MailMessage -To $toaddress -From $fromaddressalive -Subject $messagesubjectalive -Body -$messagebody -Attachments $dynutilaliveresults,$cvaaliveresults,$corpaliveresults -SmtpServer $smtpserver
Send-MailMessage -To $toaddress -From $fromaddressdead -Subject $messagesubjectdead -Body -$messagebody -Attachments $dynutildeadresults,$cvadeadresults,$corpdeadresults -SmtpServer $smtpserver