<#
.Synopsis
  Queries Active Directory for Windows Servers running IIS
.DESCRIPTION
   Long description
.EXAMPLE
   Example of how to use this cmdlet
.EXAMPLE
   Another example of how to use this cmdlet
.NOTES
  This Cmddlet requires that the RSAT AD Tools are installed, and that there is a domain controller running ADWS availiable. (2008 R2/2012 DCs have it by default)

#>

#Import ActiveDirectory module to query AD
import-module activedirectory

#Query AD to get list of computers running Windows Server
$servers=Get-ADComputer -Filter {operatingsystem -Like "Windows server*"} | Select-Object -ExpandProperty Name
$servers | Out-File "C:\Scripts\UD\IIS Tools\Servers.txt" -append default
$serversall = (Get-Content "C:\Scripts\UD\IIS Tools\Servers.txt") 
Start-Transcript -path "C:\Scripts\UD\IIS Tools\output.txt" -append default

#Query each server to see if it is running IIS
foreach($vm in $serversall)
{ $iis = get-wmiobject Win32_Service -ComputerName $vm -Filter "name='W3SVC'"
if($iis.State -eq "Running") 
{
Write-Host "IIS is running on $vm" -BackgroundColor DarkBlue -ForegroundColor DarkYellow
$ipinfo=Get-WmiObject Win32_NetworkAdapterConfiguration -ComputerName $vm | Select-Object IPAddress,DefaultIPGateway,PSComputerName,Caption,DNSHostName,IPSubnet | 
Where-Object {$_.IPaddress -like "1*"}
$ipAddress=$ipinfo.IPAddress
$Gateway=$ipinfo.DefaultIPGateway
$ipsubnet=$ipinfo.IPSubnet
$hwinfo=Get-WmiObject Win32_Computersystem -ComputerName $vm | Select-Object Name,Domain,Manufacturer,Model,PrimaryOwnerName,TotalPhysicalMemory,NumberOfLogicalProcessors 
$HostName=$hwinfo.Name
$DomainName=$hwinfo.Domain
$Man=$hwinfo.Manufacturer
$Model=$hwinfo.Model
$Memory=$hwinfo.TotalPhysicalMemory
$osinfo=Get-WmiObject Win32_OPERATingsystem -ComputerName $vm | Select-Object Caption,CSName,OSArchitecture,ServicePackMajorVersion,SystemDrive,Version
$caption=$osinfo.Caption
$arch=$osinfo.OSArchitecture
$spversion=$osinfo.ServicePackMajorVersion
$drive=$osinfo.SystemDrive
$osver=$osinfo.Version
$allinfo=$HostName+";"+$DomainName+";"+$ipAddress+";"+$ipsubnet+";"+$Gateway+";"+$Memory+";"+$Man+";"+$Model+";"+$caption+";"+$arch+";"+$spversion+";"+$drive+";"+$osver
## Get the Service pack level
$allinfo | Out-File "C:\Scripts\UD\IIS Tools\RunningWebServers.txt" -Append default 
}
}
Stop-Transcript