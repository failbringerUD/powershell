# Setting up FSRM File Management Task properties

$Command = "C:\Windows\System32\cmd.exe"
$CommandParameters = "/c exit"
$Action = New-FSRMFmjAction -Type Custom -Command $Command -CommandParameters $CommandParameters -SecurityLevel LocalSystem

$Condition = New-FsrmFmjCondition -Property "File.DateCreated" -Condition LessThan -Value "Date.Now" -DateOffset -2555

$Schedule = New-FsrmScheduledTask -Time (Get-Date) -Weekly Sunday

# Get drives

$Drives = Get-WmiObject -Class Win32_LogicalDisk

# Get server Shares  

$Shares = Get-WmiObject -Class Win32_Share

# Default shares to ignore

$OmitShares = "ADMIN$","C$","E$","IPC$","S$"

foreach ($Share in $Shares) {

    If ($OmitShares -notcontains $Share.Name) {

        [array]$ProcessedShares += $Share

    }
}

# Loop through each drive

foreach ($Drive in $Drives) {

        if ($ProcessedShares.Path -match $Drive.DeviceID) {

             New-FsrmFileManagementJob -Name ("7 Year Retention Check-{0}" -f ($Drive.DeviceID -replace ":","")) -Namespace ("{0}\" -f $Drive.DeviceID) -Action $Action -Condition $Condition -Schedule $Schedule -ReportFormat Csv -ReportLog Information,Error,Audit -MailTo "[Admin Email]"

        }

}