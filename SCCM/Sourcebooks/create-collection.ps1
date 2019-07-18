#####
#Functionality: creates a ConfigMgr collection
#Author: David O'Brien
#date: 25.02.2012
#####
Function Create-Collection($CollectionName)
{
	$CollectionArgs = @{
	Name = $CollectionName;
	CollectionType = "2"; 		# 2 means Collection_Device, 1 means Collection_User
	LimitToCollectionID = "SMS00001"
	}
	Set-WmiInstance -Class SMS_Collection -arguments $CollectionArgs -namespace "root\SMS\Site_$sitename" | Out-Null
}

$CollectionName = Get-Random   # creates a random number for testing
$sitename = "PRI" 

Create-Collection $CollectionName