<#
.Synopsis
   Find dev servers in a domain
.DESCRIPTION
   Find dev servers in a domain
.EXAMPLE
   Run script without parameters
.EXAMPLE
   Another example of how to use this cmdlet

    THIS CODE AND ANY ASSOCIATED INFORMATION ARE PROVIDED “AS IS” WITHOUT WARRANTY OF ANY KIND, EITHER EXPRESSED OR 
    IMPLIED, INCLUDING BUT NOT LIMITED TO THE IMPLIED WARRANTIES OF MERCHANTABILITY AND/OR FITNESS FOR A PARTICULAR
    PURPOSE. THE ENTIRE RISK OF USE, INABILITY TO USE, OR RESULTS FROM THE USE OF THIS CODE REMAINS WITH THE USER.
#>

$rtn = $null
$cvaservers = get-adcomputer -filter 'OperatingSystem -like "*server*"'  -SearchBase "DC=cva,DC=local" -Server dyatl-pentdc07.cva.local | Select-Object name
$corpservers = get-adcomputer -filter 'OperatingSystem -like "*server*"'  -SearchBase "DC=corp,DC=local" -Server dyatl-pentdc05.corp.local | Select-Object name
$ErrorActionPreference = "silentlycontinue"
$results = @()


$cvadev1 = $cvaservers | Where-Object name -like "dyatl-d*"
$cvadev2 = $cvaservers | Where-Object name -like "dypbg-d*"
$cvadev3 = $cvaservers | Where-Object name -like "dyboc-d*"
$cvaqa1 = $cvaservers | Where-Object name -like "dyatl-q*"
$cvaqa2 = $cvaservers | Where-Object name -like "dypbg-q*"
$cvaqa3 = $cvaservers | Where-Object name -like "dyboc-q*"
$corpdev1 = $corpservers | Where-Object name -like "dyatl-d*"
$corpdev2 = $corpservers | Where-Object name -like "dypbg-d*"
$corpdev3 = $corpservers | Where-Object name -like "dyboc-d*"
$corpqa1 = $corpservers | Where-Object name -like "dyatl-q*"
$corpqa2 = $corpservers | Where-Object name -Like "dypbg-q*"
$corpqa3 = $corpservers | Where-Object name -Like "dyboc-q*"

$results = @($cvadev2.name) + @($cvadev1.name) + @($cvadev3.name) + @($cvaqa1.name) + @($cvaqa2.name) + @($cvaqa3.name) + @($corpdev1) + @($corpdev2) + @($corpdev3) + @($corpqa1) + @($corpqa2) + @($corpqa3)
$results | out-file D:\output\Ugo\cva.txt -Encoding ascii