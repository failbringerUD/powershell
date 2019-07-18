<#
.Synopsis
   Query Active Directory for Windows Server 2008 servers
.DESCRIPTION
   Query Active Directory for Windows Server 2008 servers
.EXAMPLE
   Run script without parameters
.EXAMPLE
   Another example of how to use this cmdlet

    THIS CODE AND ANY ASSOCIATED INFORMATION ARE PROVIDED “AS IS” WITHOUT WARRANTY OF ANY KIND, EITHER EXPRESSED OR 
    IMPLIED, INCLUDING BUT NOT LIMITED TO THE IMPLIED WARRANTIES OF MERCHANTABILITY AND/OR FITNESS FOR A PARTICULAR
    PURPOSE. THE ENTIRE RISK OF USE, INABILITY TO USE, OR RESULTS FROM THE USE OF THIS CODE REMAINS WITH THE USER.
#>

#Query AD for a listing of all computer objects with operating system of Windows Server 2008 (including R2)

Import-Module ActiveDirectory
$rtn = $null
$date = get-date -Format -yyyyMMdd
$outalive = "D:\Output\Ugo\2008alive_$date.txt"
$outnotalive = "D:\Output\Ugo\2008notalive_$date.txt"


#Get Windows Server 2008* machines from dynutil.com
get-adcomputer -filter "OperatingSystem -like 'Windows Server 2008*'" |
   ForEach-Object {
      $rtn = Test-Connection -CN $_.dnshostname -Count 1 -BufferSize 16 -Quiet
      IF($rtn -match 'True'){"$($_.dnshostname) is alive" | Out-File -FilePath $outalive -Append}
      Else{"$($_.dnshostname) is not alive" | Out-File -filepath $outnotalive -Append}
      }