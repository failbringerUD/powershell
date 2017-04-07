#import SQL snapins
#add-pssnapin sqlservercmdletsnapin100
#add-pssnapin sqlserverprovidersnapin100
import-module sqlps
import-module activedirectory

$m=Read-Host "Enter MAC address (No colons) "
$macs=$m -split (",")
foreach($mac in $macs)
{
    #create new user account, add it to MACAccounts group, change the password
    #$mac
    New-ADUser -Name $mac -Path "OU=MACAccounts,DC=pbso,DC=org"
    Set-ADAccountPassword -Identity $mac -NewPassword (ConvertTo-SecureString "pbso@1999" -AsPlainText -Force)
    Set-ADUser -Identity $mac -Enabled $true
    Add-ADGroupMember MACAccounts $mac
    Set-ADAccountPassword -Identity $mac -NewPassword (ConvertTo-SecureString $mac -AsPlainText -Force)


    #set MACaccounts as primary group and remove user from Domain Users group
    $group = get-adgroup "MACAccounts"
    $groupSid = $group.sid
    #$groupSid
    [int]$GroupID = $groupSid.Value.Substring($groupSid.Value.LastIndexOf("-")+1)

    Start-Sleep 5

    Get-ADUser $mac | Set-ADObject -Replace @{primaryGroupID="$GroupID"}

    remove-adgroupmember -Identity "Domain Users" -Member $mac -Confirm:$false

    #get values for all attributes
    $model=Read-Host "Enter Model "
    $type=Read-Host "Enter Type "
    $serial=Read-Host "Enter Serial No. "
    $manu=Read-Host "Enter Manufacturer "
    $description=Read-Host "Enter Description "


    #insert the information in SQL table
    invoke-sqlcmd -query "insert into mac_info (mac,model,type,serial,manu,description) VALUES ('$mac','$model','$type','$serial','$manu','$description')" -database "MAC" -serverinstance "HQ-S-TEST-T1"
}