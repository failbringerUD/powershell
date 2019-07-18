<#
.Synopsis
  Exports AD data for Objects to be imported to Lab
.DESCRIPTION
   Long description
.EXAMPLE
   Example of how to use this cmdlet
.EXAMPLE
   Another example of how to use this cmdlet
.NOTES
  This Cmddlet requires that the RSAT AD Tools are installed, and that there is a domain controller running ADWS availiable. (2008 R2/2012 DCs have it by default)

#>






$Error.Clear()
       $DebugPreference = "Continue"
       $Log_File = "<path to your log file>"
       function Get-TimeStamp {
           return "[{0:MM/dd/yy} {0:HH:mm:ss}]" -f (Get-Date)
       }
       function DebugMessage($MessageText){
           Write-Debug "$(Get-TimeStamp)	$($Error.Count)	$MessageText"
           Write-Output "$(Get-TimeStamp)	$MessageText" | out-file $Log_File -append
       }
       
       ### Call DebugMessage with the text you care to see
       ### DebugMessage automatically prefixes the message with the datetime and error count both on the debug screen and in the log file.
         DebugMessage("INFO	Doing thing Start")
         try {
             <<Do the thing>>
             DebugMessage("INFO	Success doing the thing")
         } catch {
             DebugMessage("ERROR	doing the thing failed")
             <<Do the catch thing>>
             DebugMessage("INFO	catch thing complete")
         }
         DebugMessage("INFO	Doing thing End")




(Get-ADDomain -id dynutil.com).replicadirectoryservers | foreach {Get-ADDomainController -id $_ -server dynutil.com | select hostname}


$AnotherVariable = $FolderList | ?{$AdUserName -notcontains $_}