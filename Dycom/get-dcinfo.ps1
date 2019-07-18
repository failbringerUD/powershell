#This script will collect information about domain controllers in the domains defined by $domains

#define domains to query
$domains = "cva.local","corp.local","dynutil.com"

#Query listed defined domains for each domain controller and return information listed
$DCs = foreach ($domain in $domains)
{
    Get-ADDomainController -Filter * -server $domain
}
$Results = New-Object -TypeName System.Collections.ArrayList
foreach($DC in $DCs){
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
$Results = $Results | Sort-Object -Property Domain,site
$Results | export-csv c:\temp\dynutilDCs.csv -NoTypeInformation