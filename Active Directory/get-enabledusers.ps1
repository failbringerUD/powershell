<#
.Synopsis
   Get enabled users from AD and export to CSV file
.DESCRIPTION
   Long description
.EXAMPLE
   Run script without parameters
.EXAMPLE
   Another example of how to use this cmdlet

                             THIS CODE AND ANY ASSOCIATED INFORMATION ARE PROVIDED “AS IS” WITHOUT WARRANTY OF ANY KIND, EITHER EXPRESSED OR 
                             IMPLIED, INCLUDING BUT NOT LIMITED TO THE IMPLIED WARRANTIES OF MERCHANTABILITY AND/OR FITNESS FOR A PARTICULAR
                             PURPOSE. THE ENTIRE RISK OF USE, INABILITY TO USE, OR RESULTS FROM THE USE OF THIS CODE REMAINS WITH THE USER.


#>

Import-Module ActiveDirectory
 
# All of the properties you'd like to pull from Get-ADUser
$properties=@(
    'displayname', 
    'distinguishedname'
    )
 
 
# All of the expressions you want with all of the filtering .etc you'd like done to them
$expressions=@(
    @{Expression={$_.DistinguishedName};Label="DN"},
    @{Expression={$_.DisplayName};Label="Name"}
    )
 
$path_to_file = "D:\Output\Ugo\enabled-users_$((Get-Date).ToString('yyyy-MM-dd_hh-mm-ss')).csv"
 
Get-ADUser -Filter 'enabled -eq $true' -Properties $properties | Select-Object $expressions | Export-CSV $path_to_file -notypeinformation -Encoding UTF8