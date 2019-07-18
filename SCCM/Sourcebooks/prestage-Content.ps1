[CmdletBinding()]
Param(
    [Parameter(ParameterSetName='Package',Position=0)]
    [switch]$Package,
    [Parameter(ParameterSetName='Package',Position=0)]
    [string]$PackageFolderName,

    [Parameter(ParameterSetName='Application',Position=0)]
    [switch]$Application,
    [Parameter(ParameterSetName='Application',Position=0)]
    [string]$ApplicationFolderName,

    [Parameter(ParameterSetName='OS',Position=0)]
    [switch]$OS,
    [Parameter(ParameterSetName='OS',Position=0)]
    [string]$OSFolderName,

    [Parameter(ParameterSetName='BootImage',Position=0)]
    [switch]$BootImage,
    [Parameter(ParameterSetName='BootImage',Position=0)]
    [string]$BootImageFolderName,

    [Parameter(ParameterSetName='DriverPackage',Position=0)]
    [switch]$DriverPackage,
    [Parameter(ParameterSetName='DriverPackage',Position=0)]
    [string]$DriverPackageFolderName,
    
    [Parameter(ParameterSetName='AllInOne')]
    [Parameter(ParameterSetName='Package')]
    [Parameter(ParameterSetName='Application')]
    [Parameter(ParameterSetName='OS')]
    [Parameter(ParameterSetName='BootImage')]
    [Parameter(ParameterSetName='DriverPackage')]
    [switch]$AllInOneFile,

    [Parameter(ParameterSetName='AllInOne')]
    [Parameter(ParameterSetName='Package')]
    [Parameter(ParameterSetName='Application')]
    [Parameter(ParameterSetName='OS')]
    [Parameter(ParameterSetName='BootImage')]
    [Parameter(ParameterSetName='DriverPackage')]
    [string]$ExportFileName,

    [Parameter(Position=1,
        Mandatory=$True,
        ValueFromPipeline=$True)]
    [string]$SiteCode,

    [Parameter(Position=2,
        Mandatory=$True,
        ValueFromPipeline=$True)]
    [string]$ExportFolder,
  
    [Parameter(Position=3,
        Mandatory=$True,
        ValueFromPipeline=$True)]
    [string]$SourceDistributionPoint

 )


if (-not [Environment]::Is64BitProcess)
    {

        # this script needs to run in a x86 shell, but we need to access the x64 reg-hive to get the AdminConsole install directory
        $Hive = "LocalMachine"
        $ServerName = "localhost"
        $reg = [Microsoft.Win32.RegistryKey]::OpenRemoteBaseKey([Microsoft.Win32.RegistryHive]$Hive,$ServerName,[Microsoft.Win32.RegistryView]::Registry64)

        $Subkeys = $reg.OpenSubKey('SOFTWARE\Microsoft\SMS\Setup\')

        $AdminConsoleDirectory = $Subkeys.GetValue('UI Installation Directory')

        #Import the CM12 Powershell cmdlets
        Import-Module "$($AdminConsoleDirectory)\bin\ConfigurationManager.psd1"
        #CM12 cmdlets need to be run from the CM12 drive
        Set-Location "$($SiteCode):"
     
        if ($Package)
            {
                $FolderID = (gwmi -Class SMS_ObjectContainerNode -Namespace root\sms\site_$SiteCode | Where-Object {($_.Name -eq "$($PackageFolderName)") -and ($_.ObjectType -eq "2")}).ContainerNodeID
                $PackageIDs = (gwmi -Class SMS_ObjectContainerItem -Namespace root\sms\site_$SiteCode | Where-Object {$_.ContainerNodeID -eq "$($FolderID)"}).InstanceKey

                if ($AllInOneFile)
                    {
                        Publish-CMPrestageContent -PackageId $PackageIDs -FileName $(Join-Path $ExportFolder "$ExportFileName.pkgx") -DistributionPointName $SourceDistributionPoint | Out-Null
                    }
                
                else 
                    {
                        foreach ($SinglePackageID in $PackageIDs)
                            {
                              $PackageName = (gwmi -Class SMS_Package -Namespace root\sms\site_$SiteCode | Where-Object {$_.PackageID -eq "$($SinglePackageID)"}).Name
              
                              Publish-CMPrestageContent -PackageId $SinglePackageID -FileName $(Join-Path $ExportFolder "$PackageName.pkgx") -DistributionPointName $SourceDistributionPoint | Out-Null
                            }
                    }
            }
        
        if ($Application)
            {
                $FolderID = (gwmi -Class SMS_ObjectContainerNode -Namespace root\sms\site_$SiteCode | Where-Object {($_.Name -eq "$($ApplicationFolderName)") -and ($_.ObjectType -eq "6000")}).ContainerNodeID
                $ApplicationIDs = (gwmi -Class SMS_ObjectContainerItem -Namespace root\sms\site_$SiteCode | Where-Object {$_.ContainerNodeID -eq "$($FolderID)"}).InstanceKey
                
                if ($AllInOneFile)
                    {
                        foreach ($AppID in $ApplicationIDs)
                            {
                                $IDs = @()
                                $ApplicationID = (Get-CMApplication | Where-Object {$_.ModelName -eq "$($AppID)"}).ModelID
                                $IDs += $ApplicationID
                            }
                        Publish-CMPrestageContent -ApplicationId $IDs -FileName $(Join-Path $ExportFolder "$ExportFileName.pkgx") -DistributionPointName $SourceDistributionPoint | Out-Null
                    }
                else 
                    {
                       
                        foreach ($SingleApplicationID in $ApplicationIDs)
                            {
                        
                                $ApplicationID = (Get-CMApplication | Where-Object {$_.ModelName -eq "$($SingleApplicationID)"}).ModelID
                                $ApplicationName = (Get-CMApplication | Where-Object {$_.ModelName -eq "$($SingleApplicationID)"}).LocalizedDisplayName
                                              
                                Publish-CMPrestageContent -ApplicationId $ApplicationID -FileName $(Join-Path $ExportFolder "$ApplicationName.pkgx") -DistributionPointName $SourceDistributionPoint | Out-Null
                            }
                    }
            }
        
        if ($OS)
            {
                $FolderID = (gwmi -Class SMS_ObjectContainerNode -Namespace root\sms\site_$SiteCode | Where-Object {($_.Name -eq "$($OSFolderName)") -and ($_.ObjectType -eq "18")}).ContainerNodeID
                $OSIDs = (gwmi -Class SMS_ObjectContainerItem -Namespace root\sms\site_$SiteCode | Where-Object {$_.ContainerNodeID -eq "$($FolderID)"}).InstanceKey

                if ($AllInOneFile)
                    {
                        Publish-CMPrestageContent -OperatingSystemImageId $OSIDs -FileName $(Join-Path $ExportFolder "$ExportFileName.pkgx") -DistributionPointName $SourceDistributionPoint | Out-Null
                    }
                else 
                    {

                        foreach ($SingleOSID in $OSIDs)
                            {
                                $OSName = (gwmi -Class SMS_ImagePackage -Namespace root\sms\site_$SiteCode | Where-Object {$_.PackageID -eq "$($SingleOSID)"}).Name
                                                                     
                                Publish-CMPrestageContent -OperatingSystemImageId $SingleOSID -FileName $(Join-Path $ExportFolder "$OSName.pkgx") -DistributionPointName $SourceDistributionPoint | Out-Null
                            }
                    }
            }
        
        if ($BootImage)
            {
                
                $FolderID = (gwmi -Class SMS_ObjectContainerNode -Namespace root\sms\site_$SiteCode | Where-Object {($_.Name -eq "$($BootImageFolderName)") -and ($_.ObjectType -eq "19")}).ContainerNodeID
                $BootImageIDs = (gwmi -Class SMS_ObjectContainerItem -Namespace root\sms\site_$SiteCode | Where-Object {$_.ContainerNodeID -eq "$($FolderID)"}).InstanceKey

                if ($AllInOneFile)
                    {
                        Publish-CMPrestageContent -BootImageId $BootImageIDs -FileName $(Join-Path $ExportFolder "$ExportFileName.pkgx") -DistributionPointName $SourceDistributionPoint | Out-Null
                    }
                else 
                    {

                        foreach ($SingleBootImageID in $BootImageIDs)
                            {
                                $BootImageName = (gwmi -Class SMS_BootImagePackage -Namespace root\sms\site_$SiteCode | Where-Object {$_.PackageID -eq "$($SingleBootImageID)"}).Name
                                                                     
                                Publish-CMPrestageContent -BootImageId $SingleBootImageID -FileName $(Join-Path $ExportFolder "$BootImageName.pkgx") -DistributionPointName $SourceDistributionPoint | Out-Null
                            }
                    }
            }
        
        if ($DriverPackage)
            {
                $FolderID = (gwmi -Class SMS_ObjectContainerNode -Namespace root\sms\site_$SiteCode | Where-Object {($_.Name -eq "$($DriverPackageFolderName)") -and ($_.ObjectType -eq "23")}).ContainerNodeID
                $DriverPackageIDs = (gwmi -Class SMS_ObjectContainerItem -Namespace root\sms\site_$SiteCode | Where-Object {$_.ContainerNodeID -eq "$($FolderID)"}).InstanceKey
                
                if ($AllInOneFile)
                    {
                        Publish-CMPrestageContent -DriverPackageID $DriverPackageIDs -FileName $(Join-Path $ExportFolder "$ExportFileName.pkgx") -DistributionPointName $SourceDistributionPoint | Out-Null
                    }
                else 
                    {
                        foreach ($SingleDriverPackageID in $DriverPackageIDs)
                        {
                            $DriverPackageName = (gwmi -Class SMS_DriverPackage -Namespace root\sms\site_$SiteCode | Where-Object {$_.PackageID -eq "$($SingleDriverpackageID)"}).Name
                                                                     
                            Publish-CMPrestageContent -DriverPackageID $SingleDriverPackageID -FileName $(Join-Path $ExportFolder "$DriverPackageName.pkgx") -DistributionPointName $SourceDistributionPoint | Out-Null
                        }
                    }
            }

    }
else
    {
        Write-Error "This Script needs to be executed in a 32-bit Powershell"
        exit 1
    }