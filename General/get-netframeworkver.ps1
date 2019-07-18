<#
.Synopsis
  Exports AD data for Objects to be imported to Lab
.DESCRIPTION
   Long description
.EXAMPLE
   Example of how to use this cmdlet
.EXAMPLE
   Another example of how to use this cmdlet
.NOTES
  This Cmddlet requires that the RSAT AD Tools are installed, and that there is a domain controller running ADWS availiable. (2008 R2/2012 DCs have it by default)


                             THIS CODE AND ANY ASSOCIATED INFORMATION ARE PROVIDED “AS IS” WITHOUT WARRANTY OF ANY KIND, EITHER EXPRESSED OR 
                             IMPLIED, INCLUDING BUT NOT LIMITED TO THE IMPLIED WARRANTIES OF MERCHANTABILITY AND/OR FITNESS FOR A PARTICULAR
                             PURPOSE. THE ENTIRE RISK OF USE, INABILITY TO USE, OR RESULTS FROM THE USE OF THIS CODE REMAINS WITH THE USER.




#>

#.Net Framework Versions
$Lookup = @{
    378389 = [version]'4.5'
    378675 = [version]'4.5.1'
    378758 = [version]'4.5.1'
    379893 = [version]'4.5.2'
    393295 = [version]'4.6'
    393297 = [version]'4.6'
    394254 = [version]'4.6.1'
    394271 = [version]'4.6.1'
    394802 = [version]'4.6.2'
    394806 = [version]'4.6.2'
    460798 = [version]'4.7'
    460805 = [version]'4.7'
    461308 = [version]'4.7.1'
    461310 = [version]'4.7.1'
    461808 = [version]'4.7.2'
    461814 = [version]'4.7.2'
}

#Get list of servers to run against
$serverlist = Import-Csv C:\temp\servers.csv -header server

#Prompt for credentials
$cred = Get-Credential

ForEach($server in $serverlist)
{
    Invoke-Command -ComputerName $server.server -Credential $cred {
Get-ChildItem 'HKLM:\SOFTWARE\Microsoft\NET Framework Setup\NDP' -Recurse | Get-ItemProperty -name Version, Release -EA 0 | Where-Object { $_.PSChildName -match '^(?!S)\p{L}'} | Select-Object @{name = ".NET Framework"; expression = {$_.PSChildName}}, @{name = "Product"; expression = {$Lookup[$_.Release]}}, Version, Release
        }
}

<#
Get-ChildItem 'HKLM:\SOFTWARE\Microsoft\NET Framework Setup\NDP' -Recurse |
    Get-ItemProperty -name Version, Release -EA 0 |
    # For One True framework (latest .NET 4x), change match to PSChildName -eq "Full":
Where-Object { $_.PSChildName -match '^(?!S)\p{L}'} |
    Select-Object @{name = ".NET Framework"; expression = {$_.PSChildName}}, 
@{name = "Product"; expression = {$Lookup[$_.Release]}}, 
Version, Release
#>



#Get-ChildItem "HKLM:SOFTWARE\Microsoft\NET Framework Setup\NDP\v4\Full\" | Get-ItemPropertyValue -Name Release | ForEach-Object { $_ -ge 394802 }