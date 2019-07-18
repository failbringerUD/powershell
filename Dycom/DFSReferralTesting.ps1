 #Get all domain controllers in domain
 #       $DomainControllers = Get-ADDomainController -Filter *
 #       $PDCEmulator = ($DomainControllers | Where-Object {$_.OperationMasterRoles -contains "PDCEmulator"})
        
#        Write-Verbose "Finding the domain controllers in the domain"
#       Foreach ($DC in $DomainControllers)


$domaincontrollers = get-adgroupmember -identity 'Domain Controllers' | select-object name

ForEach-Object ($name in $domaincontrollers)
{
    
