$LockedOutEvents = Get-WinEvent -ComputerName hq2gc02 -FilterHashtable @{LogName='Security';Id=4740} -ErrorAction Stop | Sort-Object -Property TimeCreated -Descending

 Foreach($Event in $LockedOutEvents)
        {            
           If($Event | Where {$_.Properties[2].value -match $UserInfo.SID.Value})
           { 
              
              $Event | Select-Object -Property @(
                @{Label = 'User';               Expression = {$_.Properties[0].Value}}
                @{Label = 'DomainController';   Expression = {$_.MachineName}}
                @{Label = 'EventId';            Expression = {$_.Id}}
                @{Label = 'LockedOutTimeStamp'; Expression = {$_.TimeCreated}}
                @{Label = 'Message';            Expression = {$_.Message -split "`r" | Select -First 1}}
                @{Label = 'LockedOutLocation';  Expression = {$_.Properties[1].Value}}
              )
                                                
            }#end ifevent
            
       }