<# This script will connect to vSphere environmanet and retrieve cluster information (VLANs, vmhosts, etc) #>

# Query what vSphere environment to connect to
$vsphere = read-host "What vSphere environment to connect to?"

# Input credentials for vSphere environment
$cred = Get-Credential

# Connect to vSphere environment
Connect-VIServer -Server $vsphere -Credential $cred

# Get cluster names
$clusters = get-cluster | Select-Object Name

# Get vmhosts in each cluster
$vmhosts = foreach($cluster in $clusters)
{
    get-cluster -name $cluster.name | Get-VMHost
}


foreach($esx in $vmhosts){

    $vNicTab = @{}

    $esx.ExtensionData.Config.Network.Vnic | ForEach-Object{

        $vNicTab.Add($_.Portgroup,$_)

    }

    foreach($vsw in (Get-VirtualSwitch -VMHost $esx)){

        $pgTab = @{}

        foreach($pg in (Get-VirtualPortGroup -VirtualSwitch $vsw)){

            $obj = New-Object PSObject -Property @{

                vSwitch = $vsw.Name

                NIC = &{if($vsw.Nic){[string]::Join(',',$vsw.Nic)}}

                VLAN = $pg.VLanId

                Device = &{if($vNicTab.ContainsKey($pg.Name)){$vNicTab[$pg.Name].Device}}

                IP = &{if($vNicTab.ContainsKey($pg.Name)){$vNicTab[$pg.Name].Spec.Ip.IpAddress}}

            }

            $pgTab.Add($pg.Name,$obj)

        }

    }
}
<#
    foreach($vm in Get-VM -Location $esx){

        foreach($nic in Get-NetworkAdapter -VM $vm){

            New-Object PSObject -Property @{

                VM = $vm.Name

                VMHost = $esx.Name

                vNIC = $nic.Name

                IP = $vm.Guest.IPAddress -join '|'

                Portgroup = $nic.NetworkName

                vSwitch = $pgTab[$nic.NetworkName].vSwitch

                NIC = $pgTab[$nic.NetworkName].NIC

                VLAN = $pgTab[$nic.NetworkName].VLAN

                Device = $pgTab[$nic.NetworkName].Device

                IPSw = $pgTab[$nic.NetworkName].IP

            }

        }

    }

}
#>