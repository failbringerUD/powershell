<#
.Synopsis
   Query domain for computer objects that are Windows 2003 Server
.DESCRIPTION
   Query domain for computer objects that are Windows 2003 Server
.EXAMPLE
   Run script without parameters
.EXAMPLE
   Another example of how to use this cmdlet

    THIS CODE AND ANY ASSOCIATED INFORMATION ARE PROVIDED “AS IS” WITHOUT WARRANTY OF ANY KIND, EITHER EXPRESSED OR 
    IMPLIED, INCLUDING BUT NOT LIMITED TO THE IMPLIED WARRANTIES OF MERCHANTABILITY AND/OR FITNESS FOR A PARTICULAR
    PURPOSE. THE ENTIRE RISK OF USE, INABILITY TO USE, OR RESULTS FROM THE USE OF THIS CODE REMAINS WITH THE USER.
#>

$ea = "silentlycontinue"
$dynservers = get-adcomputer -filter 'OperatingSystem -like "*2003*"'
$corpservers = get-adcomputer -filter 'OperatingSystem -like "*2003*"' -SearchBase "DC=corp,DC=local" -server dyatl-pentdc05.corp.local
$cvaservers = get-adcomputer -filter 'OperatingSystem -like "*2003*"' -SearchBase "DC=cva,DC=local" -Server dyatl-pentdc07.cva.local

$dynservers | Select-Object name,dnshostname,OperatingSystem,distinguishedname | Export-Csv D:\Output\ws2003_dynutil.csv -NoTypeInformation
$corpservers | Select-Object name,dnshostname,OperatingSystem,distinguishedname | Export-Csv D:\Output\ws2003_corp.csv -NoTypeInformation
$cvaservers | Select-Object name,dnshostname,OperatingSystem,distinguishedname | Export-Csv D:\Output\ws2003_cva.csv -NoTypeInformation