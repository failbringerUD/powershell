$users = Get-Content C:\temp\adminusers.txt
$result2 = New-Object System.Collections.Generic.List[object]
FOREACH ($user IN $users)
{
	$groups = [string]::Join(";",(Get-ADPrincipalGroupMembership $user).name)
	$Entry = [pscustomobject] @{
			UserName = $user
			Groups = $groups
		}
	$result2.Add($Entry)
}
$result2 | Export-csv C:\ScriptTemp\adminusersgroups2.csv -NoTypeInformation