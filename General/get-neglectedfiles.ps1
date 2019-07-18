<#
.Synopsis
   Get list of neglected files from path
.DESCRIPTION
   Get list of neglected files from path
.EXAMPLE
   Run script without parameters
.EXAMPLE
   Another example of how to use this cmdlet

    THIS CODE AND ANY ASSOCIATED INFORMATION ARE PROVIDED “AS IS” WITHOUT WARRANTY OF ANY KIND, EITHER EXPRESSED OR 
    IMPLIED, INCLUDING BUT NOT LIMITED TO THE IMPLIED WARRANTIES OF MERCHANTABILITY AND/OR FITNESS FOR A PARTICULAR
    PURPOSE. THE ENTIRE RISK OF USE, INABILITY TO USE, OR RESULTS FROM THE USE OF THIS CODE REMAINS WITH THE USER.
#>



Function Get-NeglectedFiles

{

 Param([string[]]$path,

       [int]$numberDays)

 $cutOffDate = (Get-Date).AddDays(-$numberDays)

 Get-ChildItem -Path $path |

 Where-Object {$_.LastAccessTime -le $cutOffDate}

}

Get-NeglectedFiles -path -numberDays | Select-Object name,LastAccessTime