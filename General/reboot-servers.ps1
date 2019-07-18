<#
.Synopsis
   Restart servers from list
.DESCRIPTION
   Restart servers that are in a text file
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

#Setting some variables...
$date = get-date -format MM/dd/yyyy
$futuredate = get-date ((get-date).AddDays(7)) -Format "MM/dd/yyy"
$path_to_file = "D:\Output\reboots\reboot_snapshots_$((Get-Date).ToString('yyyy-MM-dd')).csv"
$servers = Get-Content D:\input\server_reboot.txt
$cred = Get-Credential

#Load VMware PowerCli module
Write-Host "Checking for VMware.PowerCLI module..." -ForegroundColor Green
Load-Module "VMware.PowerCli"

#configure powercli to automatically import VCenter certificate
Set-PowerCLIConfiguration -InvalidCertificateAction ignore -Confirm:$false

#prompt for VCenter Server to connect to
$viserver = read-host "Please enter VCenter Server to connect to:"

#connect to VCenter server
Write-Host "Connecting to VCenter server $viserver" -ForegroundColor Green
Connect-VIServer -Server $viserver -Credential $cred | Format-Table

#get list of servers to patch
$servers = Get-Content D:\input\server_reboot.txt
Write-Host "Starting snapshot process..." -ForegroundColor Green

#take snapshots of servers to patch
ForEach($server in $servers){
    write-host "Taking snapshot of $server..." -ForegroundColor Cyan
    Get-VM $server | New-Snapshot -name "ASR AGENT UPDATE" -Description "Pre Server Reboot $date" -Quiesce:$false -Memory:$false -Confirm:$false | format-table
}


#Check list of servers for snapshots
Write-host "Checking for snapshots on tonight's server list..." - -ForegroundColor Cyan
$a = foreach($server in $servers){
    get-vm $server | get-snapshot | select-object vm,name,Description
}

#outputting list of servers and snapshots
write-host "If there is nothing listed under the 'Name' column, manually take a snapshot of said system..." -ForegroundColor Green
$a | Format-Table
$a | Export-Csv $path_to_file -NoTypeInformation


#Restart servers after snapshot processing is completed
foreach($server in $servers)
{
    Restart-Computer -ComputerName $server -Credential $cred
}