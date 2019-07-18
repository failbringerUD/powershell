<#
.Synopsis
   Remove files in specified path older than X days
.DESCRIPTION
   Remove files in specified path older than X days
.EXAMPLE
   Run script without parameters
.EXAMPLE
   Another example of how to use this cmdlet

    THIS CODE AND ANY ASSOCIATED INFORMATION ARE PROVIDED “AS IS” WITHOUT WARRANTY OF ANY KIND, EITHER EXPRESSED OR 
    IMPLIED, INCLUDING BUT NOT LIMITED TO THE IMPLIED WARRANTIES OF MERCHANTABILITY AND/OR FITNESS FOR A PARTICULAR
    PURPOSE. THE ENTIRE RISK OF USE, INABILITY TO USE, OR RESULTS FROM THE USE OF THIS CODE REMAINS WITH THE USER.
#>

$path = "C:\Windows\Temp"
$daysback = "0"
$currentdate = get-date
$datetodelete = $currentdate.AddDays($daysback)

get-childitem $path | where-object { $_.lastwritetime -lt $datetodelete } | remove-item