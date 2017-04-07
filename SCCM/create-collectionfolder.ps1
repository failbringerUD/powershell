﻿Function Create-CollectionFolder($FolderName)
{
	$CollectionFolderArgs = @{
	Name = $FolderName;
	ObjectType = "5000"; 		# 5000 ist für Collection_Device, 5001 ist für Collection_User
	ParentContainerNodeid = "0" # die ParentContainerNodeID ist dann '0', wenn der Ordner unter der Root hängt, ansonsten muss der ParentOrdner evaluiert werden
	}
	Set-WmiInstance -Class SMS_ObjectContainerNode -arguments $CollectionFolderArgs -namespace "root\SMS\Site_$sitename" | Out-Null
}

$FolderName = Get-Random   # für Test, setzt einfach eine willkürliche Zahl
$sitename = "PRI" # an deinen Sitename anpassen!

Create-CollectionFolder $FolderName