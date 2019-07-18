<#
.Synopsis
   Adds resource to specified collection in Configuration Manager
.DESCRIPTION
   Adds resource to specified collection in Configuration Manager
.EXAMPLE
   Run script without parameters
.EXAMPLE
   Another example of how to use this cmdlet

    THIS CODE AND ANY ASSOCIATED INFORMATION ARE PROVIDED “AS IS” WITHOUT WARRANTY OF ANY KIND, EITHER EXPRESSED OR 
    IMPLIED, INCLUDING BUT NOT LIMITED TO THE IMPLIED WARRANTIES OF MERCHANTABILITY AND/OR FITNESS FOR A PARTICULAR
    PURPOSE. THE ENTIRE RISK OF USE, INABILITY TO USE, OR RESULTS FROM THE USE OF THIS CODE REMAINS WITH THE USER.
#>

$patchitems = Import-Csv "c:\temp\dynutilpatchitems.csv"

Foreach($patchitem in $patchitems)
{
    Add-CMDeviceCollectionDirectMembershipRule -CollectionId $patchitem.collectionID -ResourceID (Get-CMDevice -Name $patchitem.name).ResourceID 
}