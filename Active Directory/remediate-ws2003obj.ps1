<#
.Synopsis
   Query domain for computer objects that are Windows 2003 Server and move them to disabled OU, disable object, and clean up DNS entries
.DESCRIPTION
   Query domain for computer objects that are Windows 2003 Server and move them to disabled OU, disable object, and clean up DNS entries
.EXAMPLE
   Run script without parameters
.EXAMPLE
   Another example of how to use this cmdlet

    THIS CODE AND ANY ASSOCIATED INFORMATION ARE PROVIDED “AS IS” WITHOUT WARRANTY OF ANY KIND, EITHER EXPRESSED OR 
    IMPLIED, INCLUDING BUT NOT LIMITED TO THE IMPLIED WARRANTIES OF MERCHANTABILITY AND/OR FITNESS FOR A PARTICULAR
    PURPOSE. THE ENTIRE RISK OF USE, INABILITY TO USE, OR RESULTS FROM THE USE OF THIS CODE REMAINS WITH THE USER.
#>

$ea = "silentlycontinue"
$dynservers = get-adcomputer -filter "OperatingSystem -like '*2003*'"
$dyntargetpath = "OU=Disabled Computers,DC=dynutil,DC=com"
$dyndnsserver = "dyatl-pentdc11.dynutil.com"
$corpservers = get-adcomputer -filter "OperatingSystem -like '*2003*'" -SearchBase "DC=corp,DC=local" -server dyatl-pentdc05.corp.local
$corptargetpath = "OU=Disabled Computers,DC=corp,DC=local"
$corpdnsserver = "dyatl-pentdc05.corp.local"

#move dynutil servers
foreach($dynserver in $dynservers)
{
   Move-ADObject -Identity $dynserver.objectguid -TargetPath $dyntargetpath
   Disable-ADAccount -Identity $dynserver.objectguid
}

#move corp servers
foreach($corpserver in $corpservers)
{
   Move-ADObject -Identity $corpserver.objectguid -TargetPath $corptargetpath
   Disable-ADAccount -Identity $corpserver.objectguid
}

#Get DNS entries and remove them
foreach($dynserver in $dynservers)
{
   Get-DnsServerResourceRecord -name $server.name -ZoneName "dynutil.com" -ComputerName $dyndnsserver -ErrorAction $ea | Remove-DnsServerResourceRecord -Force -ZoneName "dynutil.com" -ComputerName $dyndnsserver
}

foreach($corpserver in $corpservers)
{
   Get-DnsServerResourceRecord -name $server.name -ZoneName "corp.local" -ComputerName $corpdnsserver -ErrorAction $ea | Remove-DnsServerResourceRecord -Force -ZoneName "corp.local" -ComputerName $corpdnsserver
}