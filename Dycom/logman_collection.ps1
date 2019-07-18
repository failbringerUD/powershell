#This script will set logman data collector sets for long and short periods
#It will also start logman collection for a user definable period of time
#Ref INC0319965

#Redefining start-sleep to give a progress indicator
function Start-Sleep($seconds) {
    $doneDT = (Get-Date).AddSeconds($seconds)
    while($doneDT -gt (Get-Date)) {
        $secondsLeft = $doneDT.Subtract((Get-Date)).TotalSeconds
        $percent = ($seconds - $secondsLeft) / $seconds * 100
        Write-Progress -Activity "Collecting Data" -Status "Collecting Data..." -SecondsRemaining $secondsLeft -PercentComplete $percent
        [System.Threading.Thread]::Sleep(500)
    }
    Write-Progress -Activity "Collecting Data" -Status "Collecting Data..." -SecondsRemaining 0 -Completed
}

#gotta clear the screen
clear-host


#long collection period
$long = c:\windows\system32\Logman.exe create counter PerfLog-Long -o "c:\perflogs\\%computername%_PerfLog-Long.blg" -f bincirc -v mmddhhmm -max 300 -c "\LogicalDisk(*)\*" "\Memory\*" "\Cache\*" "\Network Interface(*)\*" "\Paging File(*)\*" "\PhysicalDisk(*)\*" "\Processor(*)\*" "\Processor Information(*)\*" "\Process(*)\*" "\Redirector\*" "\Server\*" "\System\*" "\Server Work Queues(*)\*" "\Terminal Services\*" -si 00:00:30
#short collection period
$short = c:\windows\system32\Logman.exe create counter PerfLog-Short -o "c:\perflogs\\%computername%_PerfLog-Short.blg" -f bincirc -v mmddhhmm -max 300 -c "\LogicalDisk(*)\*" "\Memory\*" "\Cache\*" "\Network Interface(*)\*" "\Paging File(*)\*" "\PhysicalDisk(*)\*" "\Processor(*)\*" "\Processor Information(*)\*" "\Process(*)\*" "\Thread(*)\*" "\Redirector\*" "\Server\*" "\System\*" "\Server Work Queues(*)\*" "\Terminal Services\*" -si 00:00:01

#Ask user if data collection sets need to be created
$logmanvar = read-host 'Do you need to set logman collection data sets? (yes/no)'

If ($logmanvar -eq "yes")
{
    write-host 'Creating logman PerfLog-Long data collector set...' -ForegroundColor Green
    $long
    write-host 'Creating logman PerfLog-Short data collector set...' -ForegroundColor Green
    $short
    Write-Host 'Data collector sets have been created' -ForegroundColor Green
}

Else
{
    Write-host 'Data collector sets have previously been created' -ForegroundColor Green
}

#Ask user if they are ready to start collecting logman data
$startstop = read-host 'Do you want to start logman data collection? (yes/no)'

If ($startstop -eq "yes")
{
    $time = read-host 'How long do you want to collect data for (in seconds)?'
    write-host 'Starting logman long collection period collector...' -ForegroundColor Magenta
    c:\windows\system32\logman.exe start perflog-long
    write-host 'Starting logman short collection period collector...' -ForegroundColor Magenta
    c:\windows\system32\logman.exe start perflog-short

    start-sleep $time

    write-host 'Stopping logman long collection period collector...' -ForegroundColor Magenta
    c:\windows\system32\logman.exe stop perflog-long
    write-host 'stopping logman short collection period collector...' -ForegroundColor Magenta
    c:\windows\system32\logman.exe stop perflog-short
    Clear-Host
    write-host 'Logman data collection complete. Files are located in c:\perflogs' -ForegroundColor Green
}

Else
{
    write-host 'Logman data collection not started...' -ForegroundColor Red
}

