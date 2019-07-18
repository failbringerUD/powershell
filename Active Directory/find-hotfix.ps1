<# This script will query systems for a particular MS Hotfix

#>

# Provide admin credentials for context
write-host "Please provide admin credentials to execute this script in the context of..." -ForegroundColor Green
$cred = Get-Credential

# Query which hotfix to look for
$hotfix = Read-Host "What hotfix (KB) are you looking for?"

# Query which systems to look for said hotfix
$searchbase = Read-Host "Which servers do you want to query (prod/non-prod)?"

# Somewhere to put the resultant information
$Results = New-Object -TypeName System.Collections.ArrayList

If ($searchbase -eq "prod")
{
    $prodservers = get-adcomputer -LDAPFilter {&(objectcategory=computer)(OperatingSystem=*server*)(Enabled=True)} -searchbase "OU=Prod,OU=Servers,OU=Computers,OU=ENT,DC=dynutil,DC=com" | Sort-Object Name | Select-Object -Unique Name

        foreach($name in $prodservers)
        {
            get-hotfix $hotfix -ComputerName $name.name -Credential $cred


            $ThisResult = New-Object -TypeName System.Object
            Add-Member -InputObject $ThisResult -MemberType NoteProperty -Name Server -Value $Name.Source
            Add-Member -InputObject $ThisResult -MemberType NoteProperty -Name Description -Value $Name.Description
            Add-Member -InputObject $ThisResult -MemberType NoteProperty -Name HotFixID -Value $Name.HotFixID
            Add-Member -InputObject $ThisResult -MemberType NoteProperty -Name InstalledOn -Value $Name.InstalledOn

$Results.Add($ThisResult) | Out-Null
            }



}
# Output the collected information to CSV
$Results = $Results | Sort-Object -Property Source
$Results | export-csv c:\temp\$hotfix.csv -NoTypeInformation