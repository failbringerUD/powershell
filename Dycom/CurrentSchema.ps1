#------------------------------------------------------------------------------

Import-Module ActiveDirectory

$SchemaVersions = @()

$SchemaHashAD = @{ 
13="Windows 2000 Server"; 
30="Windows Server 2003"; 
31="Windows Server 2003 R2"; 
44="Windows Server 2008"; 
47="Windows Server 2008 R2"
56="Windows Server 2012"
69="Windows Server 2012 R2"
87="Windows Server 2016"
}

$SchemaPartition = (Get-ADRootDSE).NamingContexts | Where-Object {$_ -like "*Schema*"} 
$SchemaVersionAD = (Get-ADObject $SchemaPartition -Property objectVersion).objectVersion 
$SchemaVersions += 1 | Select-Object `
@{name="Product";expression={"AD"}}, `
@{name="Schema";expression={$SchemaVersionAD}}, `
@{name="Version";expression={$SchemaHashAD.Item($SchemaVersionAD)}}

#------------------------------------------------------------------------------

$SchemaHashExchange = @{ 
4397="Exchange Server 2000 RTM"; 
4406="Exchange Server 2000 SP3"; 
6870="Exchange Server 2003 RTM"; 
6936="Exchange Server 2003 SP3"; 
10628="Exchange Server 2007 RTM"; 
10637="Exchange Server 2007 RTM"; 
11116="Exchange 2007 SP1"; 
14622="Exchange 2007 SP2 or Exchange 2010 RTM"; 
14726="Exchange 2010 SP1"; 
14732="Exchange 2010 SP2" 
}

$SchemaPathExchange = "CN=ms-Exch-Schema-Version-Pt,$SchemaPartition" 
If (Test-Path "AD:$SchemaPathExchange") { 
$SchemaVersionExchange = (Get-ADObject $SchemaPathExchange -Property rangeUpper).rangeUpper 
} Else { 
$SchemaVersionExchange = 0 
}

$SchemaVersions += 1 | Select-Object `
@{name="Product";expression={"Exchange"}}, `
@{name="Schema";expression={$SchemaVersionExchange}}, `
@{name="Version";expression={$SchemaHashExchange.Item($SchemaVersionExchange)}}

#------------------------------------------------------------------------------

$SchemaHashLync = @{ 
1006="LCS 2005"; 
1007="OCS 2007 R1"; 
1008="OCS 2007 R2"; 
1100="Lync Server 2010" 
}

$SchemaPathLync = "CN=ms-RTC-SIP-SchemaVersion,$SchemaPartition" 
If (Test-Path "AD:$SchemaPathLync") { 
$SchemaVersionLync = (Get-ADObject $SchemaPathLync -Property rangeUpper).rangeUpper 
} Else { 
$SchemaVersionLync = 0 
}

$SchemaVersions += 1 | Select-Object `
@{name="Product";expression={"Lync"}}, `
@{name="Schema";expression={$SchemaVersionLync}}, `
@{name="Version";expression={$SchemaHashLync.Item($SchemaVersionLync)}}

#------------------------------------------------------------------------------

"`nKnown current schema version of products:" 
$SchemaVersions | Format-Table * -AutoSize

#---------------------------------------------------------------------------><>