########################################################
# This script will get a listing of members of a       #
# specified group and output to a csv file for review  #
########################################################

# Ask what group to query...
$group = read-host 'What group do you want to query?'

# Query previously identified group for user list, selecting SAMAccountName, Surname, GivenName, output to <groupname>.csv
get-adgroupmember $group -Recursive | 
    Where-Object objectclass -eq 'user' | 
    get-aduser -Properties samaccountname, surname, givenname | 
    select-object samaccountname, surname, givenname | 
    export-csv c:\temp\$group.csv -NoTypeInformation