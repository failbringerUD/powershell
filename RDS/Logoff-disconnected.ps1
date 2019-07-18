$FQDNOfBroker = "dyatl-pentgw01.dynutil.com"
$Collection = read-host "Collection name?"
 
Import-Module RemoteDesktop
$selected = Get-RDUserSession -ConnectionBroker $FQDNOfBroker -CollectionName $Collection | Where-Object Sessionstate -eq 'STATE_DISCONNECTED' | Select-Object sessionId,hostserver, username,sessionstate 

Foreach($selected in $selected)
{
    Invoke-RDUserLogoff -HostServer $selected.HostServer -UnifiedSessionID $selected.SessionId -Force
}
