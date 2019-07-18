<#
.Synopsis
   Query list of servers from CSV to determine domain membership
.DESCRIPTION
   Query list of servers from CSV to determine domain membership
.EXAMPLE
   Run script without parameters
.EXAMPLE
   Another example of how to use this cmdlet

    THIS CODE AND ANY ASSOCIATED INFORMATION ARE PROVIDED “AS IS” WITHOUT WARRANTY OF ANY KIND, EITHER EXPRESSED OR 
    IMPLIED, INCLUDING BUT NOT LIMITED TO THE IMPLIED WARRANTIES OF MERCHANTABILITY AND/OR FITNESS FOR A PARTICULAR
    PURPOSE. THE ENTIRE RISK OF USE, INABILITY TO USE, OR RESULTS FROM THE USE OF THIS CODE REMAINS WITH THE USER.
#>

$asragents = Import-Csv D:\Input\asragents.csv


foreach($asragent in $asragents)
{
    $cva = $null
    $cva = Get-ADComputer $asragent.name -Server dyatl-pentdc07.cva.local
    If ($cva -ne $null){ $asragent.domain = "cva" }

    $corp = $null
    $corp = get-adcomputer $asragent.name -Server dyatl-pentdc05.corp.local
    If ($corp -ne $null){ $asragent.domain = "corp" }

    $dynutil = $null
    $dynutil = Get-ADComputer $asragent.name -Server dyatl-pentdc11.dynutil.com
    If ($dynutil -ne $null){ $asragent.domain = "dynutil" }

}

$asragents | Export-Csv D:\output\ugo\asragents_filled.csv -NoTypeInformation