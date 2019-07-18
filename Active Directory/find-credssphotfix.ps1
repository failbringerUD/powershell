<# This script will query systems for a particular MS Hotfix

#>

# Provide admin credentials for context
write-host "Please provide admin credentials to execute this script in the context of..." -ForegroundColor Green
$cred = Get-Credential

# Query which hotfix to look for
$dllpath = "c:\windows\system32\tspkg.dll"

# Somewhere to put the resultant information
$Results = New-Object -TypeName System.Collections.ArrayList

$dynutilservers = get-adcomputer -LDAPFilter "(&(objectclass=computer)(operatingsystem=*server*)(!(userAccountControl:1.2.840.113556.1.4.803:=2)))" -searchbase "DC=dynutil,DC=com" | Sort-Object Name | Select-Object -Unique Name
foreach($name in $dynutilservers)
    {
        Invoke-Command -ComputerName $name.name -Credential $cred
        {
            get-childitem -path $dllpath | Select-Object -ExpandProperty VersionInfo
        }


        $ThisResult = New-Object -TypeName System.Object
        Add-Member -InputObject $ThisResult -MemberType NoteProperty -Name Server -Value $Name.name
        Add-Member -InputObject $ThisResult -MemberType NoteProperty -Name OperatingSystem $Name.OperatingSystem
        Add-Member -InputObject $ThisResult -MemberType NoteProperty -Name DLL -Value $dllpath
        Add-Member -InputObject $ThisResult -MemberType NoteProperty -Name FileVersion -Value $Name.VersionInfo
        $Results.Add($ThisResult) | Out-Null
    }

<#$corpservers = get-adcomputer -LDAPFilter {&(objectcategory=computer)(OperatingSystem=*server*)(Enabled=True)} -searchbase "DC=corp,DC=local" -server dyatl-pentdc05.corp.local | Sort-Object Name | Select-Object -Unique Name
    foreach($name in $corpservers)
    {
        
    }

$cvaservers = get-adcomputer -LDAPFilter {&(objectcategory=computer)(OperatingSystem=*server*)(Enabled=True)} -searchbase "DC=cva,DC=local" -server dyatl-pentdc07.cva.local | Sort-Object Name | Select-Object -Unique Name
    foreach($name in $cvaservers)
    {
        
    }

#>

    # Output the collected information to CSV
$Results = $Results | Sort-Object -Property Source
$Results | export-csv c:\temp\tspkg_ver.csv -NoTypeInformation