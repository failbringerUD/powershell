<#
.SYNOPSIS
	Sets the Configuration Manager Client Cache Size to a specified value.
.DESCRIPTION
	Sets the Configuration Manager Client Cache Size to a specified value.
.PARAMETER CacheSize
    Integer value in MB
.EXAMPLE
	.\set-CacheSize.ps1 -CacheSize 10000
.EXAMPLE
	.\set-CacheSize.ps1 -CacheSize 10000 -Verbose
.NOTES
	Author: David O'Brien, david.obrien@sepago.de
	Version: 1.0
	Change history
		07.02.2013 - first release 
		Requirements: installed ConfigMgr Agent on local machine
#>

[CmdletBinding()]
param(
[parameter(Mandatory=$true)][int]$CacheSize
)

$UIResourceMgr = New-Object -ComObject UIResource.UIResourceMgr
$Cache = $UIResourceMgr.GetCacheInfo()
$Cache.TotalSize = $CacheSize

Write-Verbose "The new CacheSize is $($Cache.TotalSize) MB"
