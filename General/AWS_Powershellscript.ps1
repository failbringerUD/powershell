<#
.AUTHOR
Zachery Heinl - 6/14/2019

.SYNOPSIS
This script will be used to run as a scheduled task to check active directory security groups for members of AWS groups providing federated authentication and write the necessary AD attributes required for authentication.

.DESCRIPTION
This scripts purpose is to be able to consolidate AWS SecureAuth realms to one realm per lifecycle of AWS. The script will inspect all members of Active Directory security groups used for AWS Federated logins. For each member of those groups, the script will inspect the user's Active Directory profile and ensure it has the correct ARN role written to their active directory attributes. The ARN role will be determined based on security group membership. A user will only ever have one role at a time within AWS lifecycles so thus they will only ever have a single ARN role at a time. This script will also update the ARN role if a users group membership changes so that if they have no AWS security group, it will remove the ARN role. If the AWS security group has changed, it will update the ARN role on the users active directory attribute list.

Objective of the Script:
1. Write/Delete specific AD attributes from user's AD accounts based on security group memberships.

Tasks
1. The script must be able to write a given variable to an AD attribute based on if the user is a member of a security group.
2. The script must be able to correct/modify a given variable based on if the user changes AWS groups in Active Directory.
3. The script must be able to delete the AD Attribute if a user is removed from all AWS groups (i.e. they no longer have access to AWS.)
#>

Write-Host "Start Script"
Write-Host "-------------------------"
########################################################
#DECLARE GLOBAL VARIABLES###############################
########################################################
$JsonPath = "C:\scripts\aws\MemberResults.json"
$GroupsAndRoles = Get-Content "c:\scripts\aws\GroupsAndRoles.txt"

<#
########################################################
#CHECK USERS TO SEE IF THEY HAVE AWS GROUP##############
########################################################
#Need to get the Json file from previous run for $MemberResults and compare the groups in the Json file for each user with the groups the user is currently a memberOf to ensure the #user is still a member of the AWS Groups.

#Get the stored .json file
$MemberResults = Get-Content -Path $JsonPath | ConvertFrom-Json
#Compare the latest groups and the old groups
FOREACH($AWSUser in $MemberResults){
	$LatestUserGroups = ""
	$LatestUserGroups = Get-ADUser -Identity $AWSUser.Username -Properties MemberOf
	#Compare the latest groups with the groups in MemberResults for each user.
	IF($LatestUserGroups.MemberOf -eq $MemberResults.MemberOf){
		#Write-Host "Groups Match!"
	}ELSE{
		#Write-Host "Groups do NOT Match!"
	}
}
#>
#Delete the Json File after comparison so that it can be repopulated with new users.
#Remove-Item -Path $JsonPath

#Reset Main Arrays so that they can be reused.
$AWSMainArray =@()
$AWSGroups =@()
$MemberResults =@()
$MEMBERS = @()

#Loop through each line of Groups and Roles text file and input into AWS Main Array.
ForEach ($line in $GroupsAndRoles)
	{

    	$SGARN = $line -split ';'

		#Split out $line into individual components so that it can be added to $AWSMainArray.
    	$SG = $SGARN[0]
    	$ARN = $SGARN[1]

		#Get SamAccountNames of members in the identified AWS Security groups from text document.
    	$MEMBERS += (Get-ADGroupMember -identity $SG -recursive | select-object -property SamAccountName ).samaccountname

		#Input AWS users into their own array for later user.
		$AWSMembersArray += (Get-ADGroupMember -Identity $SG -recursive | Select-Object -property SamAccountName )

		#Ouput AWS Groups into their own AWSGroups array.
		$AWSGroups += $SGARN[0]

		#Input $SG, $ARN, and $MEMBERS into hashtable array.
    	$AWSMainArray += [PSCustomObject] @{SG=$SG; ARN=$ARN; Members=$MEMBERS}
	}

FOREACH($User in $AWSMainArray.Members)
	{	
		Get-ADUser
	}
#For each user identified in the $AWSMembersArray, find their security groups and input into table.
FOREACH($USER in $MEMBERS)
	{
		$USERRESULTS = Get-ADUser -identity $USER -properties MemberOf, extensionAttribute10
		$USERNAME = $USERRESULTS.SamAccountName
		$USERSGs = $USERRESULTS.MemberOf
		$USERARN = $USERRESULTS.extensionAttribute10
		$MemberResults += [PSCustomObject] @{Username=$USERNAME; MemberOf=$USERSGs; ARN=$USERARN}
	}
Write-Host "-------------------------"
#$MemberResults | Format-List


########################################################
#CHECK USERS TO ENSURE ARN MATCH TO GROUP###############
########################################################

FOREACH($AWSUSER in $MEMBERS)
	{
	
		$AWSUSER
		$AWSUSER.ExtensionAttribute10
		$ARNTEST = "FALSE"
	
		#IF Statement to test whether user has ARN filled out or not.
		IF ($MemberResults.ExtensionAttribute10 -eq $NULL) {$ARNTEST = $TRUE }
		$ARNTEST

	}


Write-Host "-------------------------"
write-host "End Script"