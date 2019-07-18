$UserInfo = Get-ADUser -Identity svc-dii-orion -Server bp000-pentdc01 -Properties AccountLockoutTime,LastBadPasswordAttempt,BadPwdCount,LockedOut -ErrorAction Stop
$LockedOutEvents = Get-WinEvent -ComputerName bp000-pentdc01 -FilterHashtable @{LogName='Security';Id=4740} -ErrorAction Stop | Sort-Object -Property TimeCreated -Descending

 Foreach($Event in $LockedOutEvents)
        {            
           If($Event | Where-Object {$_.Properties[2].value -match $UserInfo.SID.Value})
           { 
              
              $Event | Select-Object -Property @(
                @{Label = 'User';               Expression = {$_.Properties[0].Value}}
                @{Label = 'DomainController';   Expression = {$_.MachineName}}
                @{Label = 'EventId';            Expression = {$_.Id}}
                @{Label = 'LockedOutTimeStamp'; Expression = {$_.TimeCreated}}
                @{Label = 'Message';            Expression = {$_.Message -split "`r" | Select-Object -First 1}}
                @{Label = 'LockedOutLocation';  Expression = {$_.Properties[1].Value}}
              )
                                                
            }#end ifevent
            
       }