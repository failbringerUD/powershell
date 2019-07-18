#####
#Purpose: This script calculates the current date and time, builds a string containing a new Filename and sets this filename as a new Configuration
#         Manager Task Sequence variable.
#Requirements:
#         - running Task Sequence environment
#         - Powershell added to your boot image
#Author: David O'Brien, david.obrien@sepago.de
#
#####


$date = get-date -UFormat %Y%m%d
$time = Get-Date -UFormat %H%M%S

$filename = "$($date)_$($time).wim"

$var = New-Object -ComObject Microsoft.SMS.TSEnvironment

$var.Value("ImageName") = "$($filename)"