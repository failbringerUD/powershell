<#
.Synopsis
   Query Active Directory to return computers that are in Exceptions OUs for USB blocking
.DESCRIPTION
   Query Active Directory to return computers that are in Exceptions OUs for USB blocking
.EXAMPLE
   Run script without parameters
.EXAMPLE
   Another example of how to use this cmdlet

    THIS CODE AND ANY ASSOCIATED INFORMATION ARE PROVIDED “AS IS” WITHOUT WARRANTY OF ANY KIND, EITHER EXPRESSED OR 
    IMPLIED, INCLUDING BUT NOT LIMITED TO THE IMPLIED WARRANTIES OF MERCHANTABILITY AND/OR FITNESS FOR A PARTICULAR
    PURPOSE. THE ENTIRE RISK OF USE, INABILITY TO USE, OR RESULTS FROM THE USE OF THIS CODE REMAINS WITH THE USER.
#>

$date = get-date -Format -yyyyMMdd
$outputfile = "D:\Output\USBExceptions_$date.csv"


$ExceptionMachines = FOREACH ($ExceptionOU IN (Get-ADOrganizationalUnit -Filter 'Name -Like "Exceptions"').DistinguishedName) { Get-ADComputer -Filter * -SearchBase $ExceptionOU  -Properties *}

$ExceptionMachines | Select-Object name,DistinguishedName | export-csv $outputfile -NoTypeInformation