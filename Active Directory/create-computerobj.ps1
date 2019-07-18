<#
.Synopsis
   Pre-stage computer objects in Active Directory
.DESCRIPTION
   Create computer objects in Active Directory from input file
.EXAMPLE
   Run script without parameters
.EXAMPLE
   Another example of how to use this cmdlet

    THIS CODE AND ANY ASSOCIATED INFORMATION ARE PROVIDED “AS IS” WITHOUT WARRANTY OF ANY KIND, EITHER EXPRESSED OR 
    IMPLIED, INCLUDING BUT NOT LIMITED TO THE IMPLIED WARRANTIES OF MERCHANTABILITY AND/OR FITNESS FOR A PARTICULAR
    PURPOSE. THE ENTIRE RISK OF USE, INABILITY TO USE, OR RESULTS FROM THE USE OF THIS CODE REMAINS WITH THE USER.
#>

$computers = Get-Content c:\temp\loctablets.txt
$path = "OU=Exceptions,OU=Laptops,OU=Computers,OU=LOC,OU=Company,DC=dynutil,DC=com"

foreach($computer in $computers)
{
    New-ADComputer -Name $computer -SAMAccountName $computer -Path $path
}