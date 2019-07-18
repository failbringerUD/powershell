import-module activedirectory

#Get a list of all the Domain Controllers for each domain by querying the Domain Controllers OU in AD
$dcsdynutil = get-adcomputer -filter * -searchbase "OU=Domain Controllers,DC=dynutil,DC=com" -Properties * | Select-Object dnshostname
$dcscva = get-adcomputer -filter * -SearchBase "OU=Domain Controllers,DC=cva,DC=local" -server cva.local -Properties * | Select-Object dnshostname
$dcscorp = get-adcomputer -filter * -SearchBase "OU=Domain Controllers,DC=corp,DC=local" -server corp.local -Properties * | Select-Object dnshostname
$Results = New-Object -TypeName System.Collections.ArrayList


#Gather information on each DC queried previously
$Dynutil = foreach ($dnshostname in $dcsdynutil)
{
    Get-ADDomainController -identity $dnshostname.dnshostname
}
    foreach($DC in $Dynutil){
        [string]$OMRoles = ""
        $ThisResult = New-Object -TypeName System.Object
        Add-Member -InputObject $ThisResult -MemberType NoteProperty -Name Name -Value $DC.Name
        Add-Member -InputObject $ThisResult -MemberType NoteProperty -Name Forest  -Value $DC.Forest
        Add-Member -InputObject $ThisResult -MemberType NoteProperty -Name Domain -Value $DC.Domain
        Add-Member -InputObject $ThisResult -MemberType NoteProperty -Name Site -Value $DC.Site
        Add-Member -InputObject $ThisResult -MemberType NoteProperty -Name IPv4Address -Value $DC.IPv4Address
        Add-Member -InputObject $ThisResult -MemberType NoteProperty -Name OperatingSystem  -Value $DC.OperatingSystem
        Add-Member -InputObject $ThisResult -MemberType NoteProperty -Name OperatingSystemVersion -Value $DC.OperatingSystemVersion
        Add-Member -InputObject $ThisResult -MemberType NoteProperty -Name IsGlobalCatalog -Value $DC.IsGlobalCatalog
        Add-Member -InputObject $ThisResult -MemberType NoteProperty -Name IsReadOnly -Value $DC.IsReadOnly
        foreach($OMRole in $DC.OperationMasterRoles){
            $OMRoles += ([string]$OMRole+" ")
        }
        Add-Member -InputObject $ThisResult -MemberType NoteProperty -Name OperationMasterRoles -Value $OMRoles
        $Results.Add($ThisResult) | Out-Null
    }
$cva = foreach ($dnshostname in $dcscva)
{
        Get-ADDomainController -identity $dnshostname.dnshostname -Server cva.local
}
    foreach($DC in $cva){
        [string]$OMRoles = ""
        $ThisResult = New-Object -TypeName System.Object
        Add-Member -InputObject $ThisResult -MemberType NoteProperty -Name Name -Value $DC.Name
        Add-Member -InputObject $ThisResult -MemberType NoteProperty -Name Forest  -Value $DC.Forest
        Add-Member -InputObject $ThisResult -MemberType NoteProperty -Name Domain -Value $DC.Domain
        Add-Member -InputObject $ThisResult -MemberType NoteProperty -Name Site -Value $DC.Site
        Add-Member -InputObject $ThisResult -MemberType NoteProperty -Name IPv4Address -Value $DC.IPv4Address
        Add-Member -InputObject $ThisResult -MemberType NoteProperty -Name OperatingSystem  -Value $DC.OperatingSystem
        Add-Member -InputObject $ThisResult -MemberType NoteProperty -Name OperatingSystemVersion -Value $DC.OperatingSystemVersion
        Add-Member -InputObject $ThisResult -MemberType NoteProperty -Name IsGlobalCatalog -Value $DC.IsGlobalCatalog
        Add-Member -InputObject $ThisResult -MemberType NoteProperty -Name IsReadOnly -Value $DC.IsReadOnly
        foreach($OMRole in $DC.OperationMasterRoles){
            $OMRoles += ([string]$OMRole+" ")
        }
        Add-Member -InputObject $ThisResult -MemberType NoteProperty -Name OperationMasterRoles -Value $OMRoles
        $Results.Add($ThisResult) | Out-Null
    }
$corp = foreach ($dnshostname in $dcscorp)
{
        Get-ADDomainController -identity $dnshostname.dnshostname -server corp.local
}
    foreach($DC in $corp){
        [string]$OMRoles = ""
        $ThisResult = New-Object -TypeName System.Object
        Add-Member -InputObject $ThisResult -MemberType NoteProperty -Name Name -Value $DC.Name
        Add-Member -InputObject $ThisResult -MemberType NoteProperty -Name Forest  -Value $DC.Forest
        Add-Member -InputObject $ThisResult -MemberType NoteProperty -Name Domain -Value $DC.Domain
        Add-Member -InputObject $ThisResult -MemberType NoteProperty -Name Site -Value $DC.Site
        Add-Member -InputObject $ThisResult -MemberType NoteProperty -Name IPv4Address -Value $DC.IPv4Address
        Add-Member -InputObject $ThisResult -MemberType NoteProperty -Name OperatingSystem  -Value $DC.OperatingSystem
        Add-Member -InputObject $ThisResult -MemberType NoteProperty -Name OperatingSystemVersion -Value $DC.OperatingSystemVersion
        Add-Member -InputObject $ThisResult -MemberType NoteProperty -Name IsGlobalCatalog -Value $DC.IsGlobalCatalog
        Add-Member -InputObject $ThisResult -MemberType NoteProperty -Name IsReadOnly -Value $DC.IsReadOnly
        foreach($OMRole in $DC.OperationMasterRoles){
            $OMRoles += ([string]$OMRole+" ")
        }
        Add-Member -InputObject $ThisResult -MemberType NoteProperty -Name OperationMasterRoles -Value $OMRoles
        $Results.Add($ThisResult) | Out-Null
    }

#Push the resulting information to a CSV
$Results = $Results | Sort-Object -Property Site
$Results | export-csv c:\temp\dynutilDCs.csv -NoTypeInformation