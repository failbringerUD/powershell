<# Import all GPOs from a given Directory
David O'Brien, david.obrien@gmx.de
#>

$BackupDirectory = Read-Host -Prompt "What's the Backup Directory?" 
$GPOIDs = $null
Get-ChildItem -Path $BackupDirectory | foreach {[string[]]$GPOIDs += $_.Name} | where {$_.psIsContainer -eq $true}

foreach ($GPOID in $GPOIDs) 
    {
        
        $ID = $GPOID.trim("{").trim("}")
        
        $GPODir = "$($BackupDirectory)\$($GPOID)"
        
        [xml]$GPReport = Get-Content -Path $GPODir\gpreport.xml
        
        $GPOName = $GPReport.GPO.Name
        
        Import-Module grouppolicy -ErrorAction silentlycontinue
        
        Import-GPO -BackupID $ID -TargetName $GPOName -path $BackupDirectory -CreateIfNeeded
        
    }
     
      