<#
.Synopsis
   Adds resource to specified collection in Configuration Manager
.DESCRIPTION
   Adds resource to specified collection in Configuration Manager
.EXAMPLE
   Run script without parameters
.EXAMPLE
   Another example of how to use this cmdlet

    THIS CODE AND ANY ASSOCIATED INFORMATION ARE PROVIDED “AS IS” WITHOUT WARRANTY OF ANY KIND, EITHER EXPRESSED OR 
    IMPLIED, INCLUDING BUT NOT LIMITED TO THE IMPLIED WARRANTIES OF MERCHANTABILITY AND/OR FITNESS FOR A PARTICULAR
    PURPOSE. THE ENTIRE RISK OF USE, INABILITY TO USE, OR RESULTS FROM THE USE OF THIS CODE REMAINS WITH THE USER.
#>

#REQUIRED FOR SCCM SCRIPTS
$SCCMSitePath = "DYC"
$CMServer = "dyatl-pscmom06.dynutil.com"
Import-Module (Join-Path $(Split-Path $env:SMS_ADMIN_UI_PATH) ConfigurationManager.psd1)
#Set current directory to SCCM site
Set-Location -Path $SCCMSitePath

Function Add-ResourceToCollection {
    [CmdLetBinding()]
    Param(
        [string]   $SiteCode = 'DYC',
        [string]   $SiteServer = 'dyatl-pscmom06.dynutil.com',
        [string]   $CollectionName,
        [parameter(Mandatory=$true, ValueFromPipeline=$true)]
        $System
    )

    begin {
        $WmiArgs = @{ NameSpace = "Root\SMS\Site_$SiteCode"; ComputerName = $SiteServer }
        $CollectionQuery = Get-WmiObject @WMIArgs -Class SMS_Collection -Filter "Name = '$CollectionName' and CollectionType='2'"
        $InParams = $CollectionQuery.PSBase.GetMethodParameters('AddMembershipRules')
        $Cls = [WMIClass]"Root\SMS\Site_$($SiteCode):SMS_CollectionRuleDirect"
        $Rules = @()
    }
    process {
        foreach ( $sys in $System ) {
            $NewRule = $cls.CreateInstance()
            $NewRule.ResourceClassName = "SMS_R_System"
            $NewRule.ResourceID = $sys.ResourceID
            $NewRule.Rulename = $sys.Name
            $Rules += $NewRule.psobject.BaseObject 
        }
    }
    end {
        $InParams.CollectionRules += $Rules.psobject.BaseOBject
        $CollectionQuery.PSBase.InvokeMethod('AddMembershipRules',$InParams,$null) | Out-null
        $CollectionQuery.RequestRefresh() | out-null
    }             
}