<#
.Synopsis
   Create VMware snapshot for members of a Configuration Manager Collection
.DESCRIPTION
   Using PowerCLI, take a VMware snapshot for servers to be able to revert changes. List of servers is generated by getting list of members
   of the appropriate Configuration Manager Collection
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

#Variables
$date = get-date -format MM/dd/yyyy
$futuredate = get-date ((get-date).AddDays(7)) -Format "MM/dd/yyy"
$path_to_file = "C:\Temp\patch_snapshots_$((Get-Date).ToString('yyyy-MM-dd')).csv"
$viserver = "dyqt1-pvmwvc01.dynutil.com"
$CMServer = "dyatl-pscmom06.dynutil.com"
$SiteCode = "DYC"
$CollectionList = @"
[PS01] Prod Servers 01 - Monday 2300-0100
[PS02] Prod Servers 02 - Monday 0100-0300
[PS03] Prod Servers 03 - Tuesday 2300-0100
[PS04] Prod Servers 04 - Tuesday 0100-0300
[PS05] Prod Servers 05 - Wednesday 2300-0100
[PS06] Prod Servers 06 - Wednesday 0100-0300
[PS07] Prod Servers 07 - Thursday 2300-0100
[PS08] Prod Servers 08 - Thursday 0100-0300
[PS09] Prod Servers 09 - Friday 2300-0100
[PS10] Prod Servers 10 - Friday 0100-0300
[PS11] Prod Servers 11 - Saturday 2300-0100
[PS12] Prod Servers 12 - Saturday 0100-0300
[PS13] Prod Servers 13 - Sunday 2300-0100
[PS14] Prod Servers 14 - Sunday 0100-0300
"@


#Load VMware PowerCli module
Write-Host "Checking for VMware.PowerCLI module..." -ForegroundColor Green
Load-Module "VMware.PowerCli"

#configure powercli to automatically import VCenter certificate
Set-PowerCLIConfiguration -InvalidCertificateAction ignore -Confirm:$false

#Ask for email address for report
Clear-Host
Write-Host "Please enter your email address:" -ForegroundColor Green
$emailaddress = Read-Host

#prompt for admin credentials
Clear-Host
Write-Host "Please enter your administrator credentials (pam.dii.xxxxxx@dynutil.com format)" -ForegroundColor Green
$cred = Get-Credential

#connect to VCenter server
Write-Host "Connecting to VCenter server $viserver (vSphere Production)" -ForegroundColor Green
Connect-VIServer -Server $viserver -Credential $cred | Format-Table

$exit = $null
#Ask which collection to patch
Clear-Host
Write-host "Which Collection are you patching?" -ForegroundColor Green
Write-host $CollectionList -ForegroundColor Yellow
$collection = Read-Host

#Get members of collection and snapshot members
WHILE ($exit -ne 100)
{
    Clear-Host
        Switch ($collection)
    {
        "PS01"  { $CollectionID = "DYC002AC" ; $CollectionDesc = "Prod Servers 01 - Monday 2300-0100" ; $exit = 100 ; BREAK }
        "PS02"  { $CollectionID = "DYC002AD" ; $CollectionDesc = "Prod Servers 02 - Monday 0100-0300" ; $exit = 100 ; BREAK }
        "PS03"  { $CollectionID = "DYC002AE" ; $CollectionDesc = "Prod Servers 03 - Tuesday 2300-0100" ; $exit = 100 ; BREAK }
        "PS04"  { $CollectionID = "DYC002AF" ; $CollectionDesc = "Prod Servers 04 - Tuesday 0100-0300" ; $exit = 100 ; BREAK }
        "PS05"  { $CollectionID = "DYC002B0" ; $CollectionDesc = "Prod Servers 05 - Wednesday 2300-0100" ; $exit = 100 ; BREAK }
        "PS06"  { $CollectionID = "DYC002B1" ; $CollectionDesc = "Prod Servers 06 - Wednesday 0100-0300" ; $exit = 100 ; BREAK }
        "PS07"  { $CollectionID = "DYC002B2" ; $CollectionDesc = "Prod Servers 07 - Thursday 2300-0100" ; $exit = 100 ; BREAK }
        "PS08"  { $CollectionID = "DYC002B3" ; $CollectionDesc = "Prod Servers 08 - Thursday 0100-0300" ; $exit = 100 ; BREAK }
        "PS09"  { $CollectionID = "DYC00319" ; $CollectionDesc = "Prod Servers 08 - Friday 2300-0100" ; $exit = 100 ; BREAK }
        "PS10"  { $CollectionID = "DYC0031A" ; $CollectionDesc = "Prod Servers 08 - Friday 0100-0300" ; $exit = 100 ; BREAK }
        "PS11"  { $CollectionID = "DYC0031B" ; $CollectionDesc = "Prod Servers 08 - Saturday 2300-0100" ; $exit = 100 ; BREAK }
        "PS12"  { $CollectionID = "DYC0031C" ; $CollectionDesc = "Prod Servers 08 - Saturday 0100-0300" ; $exit = 100 ; BREAK }
        "PS13"  { $CollectionID = "DYC0031D" ; $CollectionDesc = "Prod Servers 08 - Sunday 2300-0100" ; $exit = 100 ; BREAK }
        "PS14"  { $CollectionID = "DYC0031E" ; $CollectionDesc = "Prod Servers 08 - Sunday 0100-0300" ; $exit = 100 ; BREAK }
        Default { Write-Host "ERROR: Invalid input, cannot continue. Please input correct patching collection." -ForegroundColor Red ; 
        Write-host "" ; 
        Write-host "Which Collection are you patching?" -ForegroundColor Green
        Write-host $CollectionList -ForegroundColor Yellow
        $collection = Read-Host }
    }
}

Write-Host "Creating VMWare snapshot for patch collection $CollectionDesc " -ForegroundColor Green
$CollectionMembers = (Get-WmiObject -CN $CMServer -NS "ROOT\SMS\site_$SiteCode" -Query "SELECT Name FROM SMS_FullCollectionMembership WHERE CollectionID='$CollectionID'").Name
Foreach ($CollectionMember in $CollectionMembers) {Get-VM $CollectionMember | New-Snapshot -name "Pre-patching" -Description "Pre Windows Update Installation $date" -Quiesce:$false -Memory:$false -Confirm:$false | format-table}

#Check list of servers for snapshots
Clear-Host
Write-host "Checking for snapshots on tonight's patch list..." - -ForegroundColor Cyan
$snapshots = foreach($CollectionMember in $CollectionMembers)
{
    get-vm $CollectionMember | get-snapshot | select-object vm,name,Description
}

#outputting list of servers and snapshots
write-host "If there is nothing listed under the 'Name' column, manually take a snapshot of said system..." -ForegroundColor Green
$snapshots | Format-Table
$snapshots | Export-Csv $path_to_file -NoTypeInformation

#Set email variables
$fromaddress = "patch_snapshots@dycominc.com"
$toaddress = $emailaddress
$ccaddress = @('yunier.sarria@dycominc.com','charles.whitehead@dycominc.com')
$messagesubject = "Snapshot Status for $CollectionDesc $date"
$smtpserver = "smtp.dynutil.com"
$messagebody = @"
This is the snapshot report prior to patching on $($date) for $CollectionDesc. 
If there are any systems with no value in the NAME column, manually take a snapshot of that system.
These snapshots can be safely removed after $($futuredate) and the system has not had any issues.
"@
$attachment = $path_to_file

#send the email...
write-host "Sending email of report to $toaddress" -ForegroundColor Green
Send-MailMessage -To $toaddress -Cc $ccaddress -From $fromaddress -Subject $messagesubject -Body -$messagebody -Attachments $attachment -SmtpServer $smtpserver