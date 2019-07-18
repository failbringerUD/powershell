#---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------#

#Variables

$computer =  $args.get(0)

$RGName = ""

$RFName = ""

 

$DebugPreference = "SilentlyContinue"

 

Function Check-WMINamespace ($computer, $namespace)

{

  $Namespaces = $Null

  $Namespaces = Get-WmiObject -class __Namespace -namespace root -computername $computer | Where-Object {$_.name -eq $namespace}

  IF ($Namespaces.Name -eq $Namespace)

   {

    Write-Output $True

   }

  ELSE

   {

    Write-Output $False

   }

}

 

Function Get-DFSRGroup ($computer, $RGName)

{

  ## Query DFSR groups from the MicrosftDFS WMI namespace.

  IF ($RGName -eq "")

   {

    $WMIQuery = "SELECT * FROM DfsrReplicationGroupConfig"

   }

  ELSE

   {

    $WMIQuery = "SELECT * FROM DfsrReplicationGroupConfig WHERE ReplicationGroupName='" + $RGName + "'"

   }

  $WMIObject = Get-WmiObject -computername $computer -Namespace "root\MicrosoftDFS" -Query $WMIQuery

  Write-Output $WMIObject

}

 

Function Get-DFSRConnections ($computer)

{

  ## Query DFSR connections from the MicrosftDFS WMI namespace.

  $WMIQuery = "SELECT * FROM DfsrConnectionConfig"

  $WMIObject = Get-WmiObject -computername $computer -Namespace "root\MicrosoftDFS" -Query $WMIQuery

  Write-Output $WMIObject

}

 

Function Get-DFSRFolder ($computer, $RFname)

{

  ## Query DFSR folders from the MicrosftDFS WMI namespace.

  IF ($RFName -eq "")

   {

    $WMIQuery = "SELECT * FROM DfsrReplicatedFolderConfig"

   }

  ELSE

   {

    $WMIQuery = "SELECT * FROM DfsrReplicatedFolderConfig WHERE ReplicatedFolderName='" + $RFName + "'"

   }

  $WMIObject = Get-WmiObject -computername $computer -Namespace "root\MicrosoftDFS" -Query $WMIQuery

  Write-Output $WMIObject

}

 

Function Get-DFSRBacklogInfo ($Computer, $RGroups, $RFolders, $RConnections)

{

  $objSet = @()

 

  Foreach ($Group in $RGroups)

  {

   $ReplicationGroupName = $Group.ReplicationGroupName

   $ReplicationGroupGUID = $Group.ReplicationGroupGUID

 

 

  Foreach ($Folder in $RFolders)

  {

   IF ($Folder.ReplicationGroupGUID -eq $ReplicationGroupGUID)

    {

     $ReplicatedFolderName = $Folder.ReplicatedFolderName

     $FolderEnabled = $Folder.Enabled

     ForEach ($Connection in $Rconnections)

      {

      IF ($Connection.ReplicationGroupGUID -eq $ReplicationGroupGUID)

       {

        $ConnectionEnabled = $Connection.Enabled

        $BacklogCount = $Null

        IF ($FolderEnabled)

         {

          IF ($ConnectionEnabled)

          {

           IF ($Connection.Inbound)

            {

             Write-Debug "Connection Is Inbound"

             $direction = "Inbound"

 

 

             $Smem = $Connection.PartnerName.Trim()

             Write-Debug $smem

             $Rmem = $Computer.ToUpper()

             Write-Debug $Rmem

 

 

             #Get the version vector of the inbound partner

             $WMIQuery = "SELECT * FROM DfsrReplicatedFolderInfo WHERE ReplicationGroupGUID = '" + $ReplicationGroupGUID + "' AND ReplicatedFolderName = '" + $ReplicatedFolderName + "'"

             $InboundPartnerWMI = Get-WmiObject -computername $Rmem -Namespace "root\MicrosoftDFS" -Query $WMIQuery

 

 

             $WMIQuery = "SELECT * FROM DfsrReplicatedFolderConfig WHERE ReplicationGroupGUID = '" + $ReplicationGroupGUID + "' AND ReplicatedFolderName = '" + $ReplicatedFolderName + "'"

             $PartnerFolderEnabledWMI = Get-WmiObject -computername $Smem -Credential ${Credential} -Namespace "root\MicrosoftDFS" -Query $WMIQuery

             $PartnerFolderEnabled = $PartnerFolderEnabledWMI.Enabled

 

 

             IF ($PartnerFolderEnabled)

              {

               $Vv = $InboundPartnerWMI.GetVersionVector().VersionVector

 

 

               #Get the backlogcount from outbound partner

               $WMIQuery = "SELECT * FROM DfsrReplicatedFolderInfo WHERE ReplicationGroupGUID = '" + $ReplicationGroupGUID + "' AND ReplicatedFolderName = '" + $ReplicatedFolderName + "'"

               $OutboundPartnerWMI = Get-WmiObject -ComputerName $Smem -Credential ${Credential} -Namespace "root\MicrosoftDFS" -Query $WMIQuery

               $BacklogCount = $OutboundPartnerWMI.GetOutboundBacklogFileCount($Vv).BacklogFileCount

              }

            }

           ELSE

            {

             Write-Debug "Connection Is Outbound"

             $direction = "Outbound"

             $Smem = $Computer.ToUpper()

             Write-Debug $smem

             $Rmem = $Connection.PartnerName.Trim()

             Write-Debug $Rmem

 

 

             #Get the version vector of the inbound partner

             $WMIQuery = "SELECT * FROM DfsrReplicatedFolderInfo WHERE ReplicationGroupGUID = '" + $ReplicationGroupGUID + "' AND ReplicatedFolderName = '" + $ReplicatedFolderName + "'"

             $InboundPartnerWMI = Get-WmiObject -computername $Rmem -Credential ${Credential} -Namespace "root\MicrosoftDFS" -Query $WMIQuery

 

 

             $WMIQuery = "SELECT * FROM DfsrReplicatedFolderConfig WHERE ReplicationGroupGUID = '" + $ReplicationGroupGUID + "' AND ReplicatedFolderName = '" + $ReplicatedFolderName + "'"

             $PartnerFolderEnabledWMI = Get-WmiObject -computername $Rmem -Credential ${Credential} -Namespace "root\MicrosoftDFS" -Query $WMIQuery

             $PartnerFolderEnabled = $PartnerFolderEnabledWMI.Enabled

 

 

             IF ($PartnerFolderEnabled)

              {

               $Vv = $InboundPartnerWMI.GetVersionVector().VersionVector

 

 

               #Get the backlogcount from outbound partner

               $WMIQuery = "SELECT * FROM DfsrReplicatedFolderInfo WHERE ReplicationGroupGUID = '" + $ReplicationGroupGUID + "' AND ReplicatedFolderName = '" + $ReplicatedFolderName + "'"

               $OutboundPartnerWMI = Get-WmiObject -Namespace "root\MicrosoftDFS" -Query $WMIQuery

               $BacklogCount = $OutboundPartnerWMI.GetOutboundBacklogFileCount($Vv).BacklogFileCount

              }

            }

          }

         }

       $RepGroupName = $ReplicationGroupName -replace '\s',''

       $title = "$RepGroupName$direction"

       Write-Output "Statistic.$title : $BacklogCount"

       Write-Output "Message.$title : $Smem -&gt; $Rmem  (RGName = $ReplicationGroupName and RFName = $ReplicatedFolderName)"

      }

    }

   }

  }

}

}

 

Write-Debug "Computer = $Computer"

Write-Debug "RFName = $RFName"

Write-Debug "RGName = $RGName"

Write-Debug "WarningThreshold = $WarningThreshold"

Write-Debug "ErrorThreshold = $ErrorThreshold"

 

$NamespaceExists = Check-WMINamespace $computer "MicrosoftDFS"

If ($NamespaceExists)

{

  Write-Debug "Collecting RGroups from $computer"

  $RGroups = Get-DFSRGroup $computer $RGName

  Write-Debug "Rgroups = $Rgroups"

  Write-Debug "Collecting RFolders from $computer"

  $RFolders = Get-DFSRFolder $computer $RFName

  Write-Debug "RFolders = $RFolders"

  Write-Debug "Collecting RConnections from $computer"

  $RConnections = Get-DFSRConnections $computer

  Write-Debug "RConnections = $RConnections"

 

 

  Write-Debug "Calculating Backlog from $computer"

  $BacklogInfo = Get-DFSRBacklogInfo $Computer $RGroups $RFolders $RConnections

 

 

  Write-Output $BacklogInfo

}

else

{

  Write-Error "MicrosoftDFS WMI Namespace does not exist on '$computer'. Run locally on a system with the Namespace, or provide computer parameter of that system to run remotely."

  #exit 1;

}

#exit 0;

#---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------#