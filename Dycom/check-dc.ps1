$dcdynutil = import-csv C:\temp\dcdynutil.csv


foreach ($dc in $dcdynutil)
{
    Get-ADDomainController -identity $dc.dc | Select-Object Hostname,Forest,Domain,Enabled,IPv4Address,IsGlobalCatalog,IsReadOnly,OperationMasterRoles,Site
}