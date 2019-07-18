####################################################################
# This script will get the WinRM Status of all servers in the      #
# domain.                                                          #
#                                                                  #
####################################################################


# get a listing of all Windows servers in the domain
$servers = Get-ADComputer -filter 'OperatingSystem -like "Windows Server*"' | Select-Object name

# Go check each $server to see if WinRM service is running...
ForEach ($name in $servers)
{
    Test-WSMan -ComputerName $name
