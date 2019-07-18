<#
.Synopsis
   Create CNAME entries in DNS
.DESCRIPTION
   Create CNAME entries in DNS from CSV file
.EXAMPLE
   Run script without parameters
.EXAMPLE
   Another example of how to use this cmdlet

    THIS CODE AND ANY ASSOCIATED INFORMATION ARE PROVIDED “AS IS” WITHOUT WARRANTY OF ANY KIND, EITHER EXPRESSED OR 
    IMPLIED, INCLUDING BUT NOT LIMITED TO THE IMPLIED WARRANTIES OF MERCHANTABILITY AND/OR FITNESS FOR A PARTICULAR
    PURPOSE. THE ENTIRE RISK OF USE, INABILITY TO USE, OR RESULTS FROM THE USE OF THIS CODE REMAINS WITH THE USER.
#>

$CNAMEs = "D:\Input\cnames.csv"
$ZoneName = "dynutil.com"
$DNSServer = "dyatl-pentdc11.dynutil.com"


Import-Csv $CNAMEs | ForEach-Object{Add-DnsServerResourceRecordCName -Name $_.name -ZoneName $ZoneName -HostNameAlias $_.cname -ComputerName $DNSServer -Confirm}