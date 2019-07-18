function Get-RIDsRemaining   

{

    param ($domainDN)

    $de = [ADSI]"LDAP://CN=RID Manager$,CN=System,$domainDN"

    $return = new-object system.DirectoryServices.DirectorySearcher($de)

    $property= ($return.FindOne()).properties.ridavailablepool

    [int32]$totalSIDS = $($property) / ([math]::Pow(2,32))

    [int64]$temp64val = $totalSIDS * ([math]::Pow(2,32))

    [int32]$currentRIDPoolCount = $($property) - $temp64val

    $ridsremaining = $totalSIDS - $currentRIDPoolCount

    Write-Host "RIDs issued: $currentRIDPoolCount"

    Write-Host "RIDs remaining: $ridsremaining"

}

Write-Host "RID Pool Information for Dynutil.com" -ForegroundColor Green
Get-RIDsRemaining "DC=dynutil,DC=com"

Write-Host "RID Pool Information for cva.local" -ForegroundColor Green
Get-RIDsRemaining "DC=cva,DC=local"

Write-Host "RID Pool Information for corp.local" -ForegroundColor Green
Get-RIDsRemaining "DC=corp,DC=local"