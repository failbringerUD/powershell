<#
.Synopsis
   Add servers from CSV to Security Group in Active Directory
.DESCRIPTION
   Add servers (name column of CSV) to Security Group (group column of CSV)
.EXAMPLE
   Run script without parameters
.EXAMPLE
   Another example of how to use this cmdlet

    THIS CODE AND ANY ASSOCIATED INFORMATION ARE PROVIDED “AS IS” WITHOUT WARRANTY OF ANY KIND, EITHER EXPRESSED OR 
    IMPLIED, INCLUDING BUT NOT LIMITED TO THE IMPLIED WARRANTIES OF MERCHANTABILITY AND/OR FITNESS FOR A PARTICULAR
    PURPOSE. THE ENTIRE RISK OF USE, INABILITY TO USE, OR RESULTS FROM THE USE OF THIS CODE REMAINS WITH THE USER.
#>

$csv = "D:\Input\dev_qa.csv"
$reportpath = "D:\output\dev_qa_added_servers.txt"

$computers = import-csv $csv

foreach($computer in $computers)
{
   $obj = $null
   try
      {
      $obj = Get-ADComputer $computer.name
      $obj = $obj | Select-Object samaccountname
      }
   catch
      {
          "$($computer.name) doesn't exist" | Out-File $reportpath -Encoding ascii -Append
         continue 
      }
   
   add-adgroupmember -Identity $computer.group -Members $obj.samaccountname
}