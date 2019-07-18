#This script will generate a crash/hang dump of a specific process ID on a system.
#This uses procdump.exe (A Sysinternals tool) to generate these dumps
#This information is useful for troubleshooting RCA with Microsoft Premiere Support


#Setting source and target locations for procdump.exe
$source = "\\dyatl-pentts08\c$\appdump\procdump.exe"
$target = "c:\appdump"

#Check to see if c:\appdump exists and if procdump.exe exists within that path
#If it doesn't exist, it will then create the folder and copy the file over.
write-host 'Checking to see if c:\appdump\procdump.exe exists' -ForegroundColor Green
If (!(test-path -Path $target -PathType Container ))
{
    New-Item -ItemType directory -Path $target 
    Copy-Item -path $source -Destination $target -Force -PassThru -Verbose 
    write-host 'Procdump.exe copied to c:\appdump' -ForegroundColor Green
}

Pause

#Clearing the screen
Clear-Host

#Ask user what process they want to look for
$process = read-host "What process do you want to capture a crash/hang dump for?"

#Get PIDs for each process that was defined above
$ProcessIDS = get-process | Where-Object ProcessName -eq $process | Select-Object ProcessName,Id

#Display Processes and related PID
write-host "These are the Processes and PIDs selected:" -ForegroundColor Green
$ProcessIDS | format-table -AutoSize

Pause

#Setting variables necessary to run procdump.exe
$app = "c:\appdump\procdump.exe"

#Execute procdump.exe for each PID of the requested process
foreach ($ID in $ProcessIDS)
{
     & $app -ma -n 3 -s 10 -accepteula $ID.ID
}