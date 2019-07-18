#Find the places a user logs into via SCCM

Function ConvertDT
{
	param( $Timestamp )
	
	$YYYY = $Timestamp.SubString(0,4)
	$MM = $Timestamp.SubString(4,2)
	$DD = $Timestamp.SubString(6,2)
	$HH = $Timestamp.SubString(8,2)
	$mins = $Timestamp.SubString(10,2)
	$secs = $Timestamp.SubString(12,2)
	
	Get-Date ("$YYYY-$MM-$DD $HH" + ":" + "$mins" + ":" + "$secs")
}

$UserToFind = $args[0]

$Query = ""
$Query += "SELECT "
$Query += "Name,LastLogonTimestamp "
$Query += "FROM "
$Query += "SMS_R_System "
$Query += "WHERE "
$Query += "LastLogonUserName='$UserToFind'"

#$UserLocales = GWMI -Computer "DYATL-PSCMOM02" -Namespace "root\sms\site_edm" -Query $Query
$UserLocales = GWMI -Computer "DYATL-PSCMOM06" -Namespace "root\sms\site_dyc" -Query $Query

FOREACH ($Location IN $UserLocales)
{
	$LogonDate = ConvertDT($Location.LastLogonTimestamp)
	Write-Host "$UserToFind has logged in to: " $Location.Name   "on: " $LogonDate -ForegroundColor Cyan
}