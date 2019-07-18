<#

Example of how to create a Device Collection and populate it with computer objects

The Faster way. <Yea!>

#>
[cmdletbinding()]
param(
    $CollBaseName = 'MyTestCol_0C_{0:D4}',
    $name = 'PCTest*'
)

#region Replacement function 

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

#endregion

foreach ( $Count in 5,50,500,5000 ) {

    $CollName = $CollBaseName -f $Count

    write-verbose "Create a collection called '$CollName'"
    New-CMDeviceCollection -LimitingCollectionName 'All Systems' -Name $CollName | % name | write-Host

    Measure-Command {

        Write-Verbose "Find all Devices that match [$Name], grab only the first $Count, and add to Collection [$CollName]"
        get-cmdevice -name $name -Fast | 
            Select-Object -first $count |
            Add-ResourceToCollection -CollectionName $CollName
            
    } | % TotalSeconds | write-Host
}