<#
.Synopsis
    Move Utiliquest IXC6 Tablets to appropriate OU
.DESCRIPTION
    Move Utiliquest IXC6 Tablets to appropriate OU in bulk
.EXAMPLE
    Run script without parameters
.EXAMPLE
    Another example of how to use this cmdlet

    THIS CODE AND ANY ASSOCIATED INFORMATION ARE PROVIDED “AS IS” WITHOUT WARRANTY OF ANY KIND, EITHER EXPRESSED OR 
    IMPLIED, INCLUDING BUT NOT LIMITED TO THE IMPLIED WARRANTIES OF MERCHANTABILITY AND/OR FITNESS FOR A PARTICULAR
    PURPOSE. THE ENTIRE RISK OF USE, INABILITY TO USE, OR RESULTS FROM THE USE OF THIS CODE REMAINS WITH THE USER.
#>

$utqtablets = get-content c:\temp\utqtablets.txt
$path = "OU=Exceptions,OU=Laptops,OU=Computers,OU=UTQ,OU=Company,DC=dynutil,DC=com"

foreach($utqtablet in $utqtablets)
{
    Move-ADObject -Identity (Get-ADComputer $utqtablet).objectguid -TargetPath $path
}
