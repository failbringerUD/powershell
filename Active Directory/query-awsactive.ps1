<#
.Synopsis
   Query Active Directory for AWS servers that are active
.DESCRIPTION
   Query Active Directory for AWS servers that are active
.EXAMPLE
   Run script without parameters
.EXAMPLE
   Another example of how to use this cmdlet

    THIS CODE AND ANY ASSOCIATED INFORMATION ARE PROVIDED “AS IS” WITHOUT WARRANTY OF ANY KIND, EITHER EXPRESSED OR 
    IMPLIED, INCLUDING BUT NOT LIMITED TO THE IMPLIED WARRANTIES OF MERCHANTABILITY AND/OR FITNESS FOR A PARTICULAR
    PURPOSE. THE ENTIRE RISK OF USE, INABILITY TO USE, OR RESULTS FROM THE USE OF THIS CODE REMAINS WITH THE USER.
#>

Import-Module ActiveDirectory
$rtn = $null
$date = get-date -Format -yyyyMMdd
$outalive = "d:\output\ugo\awsalive_$date.txt"
$outnotalive = "D:\Output\ugo\awsnotalive_$date.txt"


get-adcomputer -filter "name -like 'ue1*'" |
   ForEach-Object {
      $rtn = Test-Connection -CN $_.dnshostname -Count 1 -BufferSize 16 -Quiet
      IF($rtn -match 'True'){"$($_.dnshostname) is alive" | Out-File -FilePath $outalive -Append}
      Else{"$($_.dnshostname) is not alive" | Out-File -filepath $outnotalive -Append}
      }