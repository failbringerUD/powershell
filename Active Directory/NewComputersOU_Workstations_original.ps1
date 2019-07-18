
################### Subsidiary PROD ###################


  $ANSProdSRV = Get-ADComputer -Property Name -SearchBase 'OU=NewComputers,DC=dynutil,DC=com' -filter {
Name -like "*ANS*-p*" -or
Name -like "*BBX*-p*" -or
Name -like "*BPS*-p*" -or
Name -like "*C2U*-p*" -or
Name -like "*CBC*-p*" -or
Name -like "*CCG*-p*" -or
Name -like "*CCI*-p*" -or
Name -like "*CCL*-p*" -or
Name -like "*CCN*-p*" -or
Name -like "*CLT*-p*" -or
Name -like "*CMI*-p*" -or
Name -like "*CSL*-p*" -or
Name -like "*CVS*-p*" -or
Name -like "*CVT*-p*" -or
Name -like "*DII*-p*" -or
Name -like "*EAI*-p*" -or
Name -like "*EAT*-p*" -or
Name -like "*ECC*-p*" -or
Name -like "*FBT*-p*" -or
Name -like "*GCI*-p*" -or
Name -like "*GEM*-p*" -or
Name -like "*GSU*-p*" -or
Name -like "*HPC*-p*" -or
Name -like "*IFS*-p*" -or
Name -like "*IHS*-p*" -or
Name -like "*KCL*-p*" -or
Name -like "*LCS*-p*" -or
Name -like "*LOC*-p*" -or
Name -like "*MDX*-p*" -or
Name -like "*NCI*-p*" -or
Name -like "*NEO*-p*" -or
Name -like "*NFS*-p*" -or
Name -like "*NSC*-p*" -or
Name -like "*NST*-p*" -or
Name -like "*PAU*-p*" -or
Name -like "*PRT*-p*" -or
Name -like "*PSU*-p*" -or
Name -like "*PTI*-p*" -or
Name -like "*PTN*-p*" -or
Name -like "*PTP*-p*" -or
Name -like "*PUC*-p*" -or
Name -like "*PVC*-p*" -or
Name -like "*RJC*-p*" -or
Name -like "*RJE*-p*" -or
Name -like "*SCI*-p*" -or
Name -like "*SGT*-p*" -or
Name -like "*SPA*-p*" -or
Name -like "*STC*-p*" -or
Name -like "*STS*-p*" -or
Name -like "*TCC*-p*" -or
Name -like "*TCS*-p*" -or
Name -like "*TDC*-p*" -or
Name -like "*TES*-p*" -or
Name -like "*TEX*-p*" -or
Name -like "*TJA*-p*" -or
Name -like "*TJH*-p*" -or
Name -like "*TRA*-p*" -or
Name -like "*USI*-p*" -or
Name -like "*UTQ*-p*" -or
Name -like "*VCI*-p*" -or
Name -like "*VDI*-p*" -or
Name -like "*VUS*-p*" -or
Name -like "*WMC*-p*" -or
Name -like "*WSI*-p*" -or
Name -like "*ANS-2*" -or
Name -like "*BBX-2*" -or
Name -like "*BPS-2*" -or
Name -like "*C2U-2*" -or
Name -like "*CBC-2*" -or
Name -like "*CCG-2*" -or
Name -like "*CCI-2*" -or
Name -like "*CCL-2*" -or
Name -like "*CCN-2*" -or
Name -like "*CLT-2*" -or
Name -like "*CMI-2*" -or
Name -like "*CSL-2*" -or
Name -like "*CVS-2*" -or
Name -like "*CVT-2*" -or
Name -like "*DII-2*" -or
Name -like "*EAI-2*" -or
Name -like "*EAT-2*" -or
Name -like "*ECC-2*" -or
Name -like "*FBT-2*" -or
Name -like "*GCI-2*" -or
Name -like "*GEM-2*" -or
Name -like "*GSU-2*" -or
Name -like "*HPC-2*" -or
Name -like "*IFS-2*" -or
Name -like "*IHS-2*" -or
Name -like "*KCL-2*" -or
Name -like "*LCS-2*" -or
Name -like "*LOC-2*" -or
Name -like "*MDX-2*" -or
Name -like "*NCI-2*" -or
Name -like "*NEO-2*" -or
Name -like "*NEOLT-2*" -or
Name -like "*NFS-2*" -or
Name -like "*NSC-2*" -or
Name -like "*NST-2*" -or
Name -like "*PAU-2*" -or
Name -like "*PRT-2*" -or
Name -like "*PSU-2*" -or
Name -like "*PTI-2*" -or
Name -like "*PTN-2*" -or
Name -like "*PTP-2*" -or
Name -like "*PUC-2*" -or
Name -like "*PVC-2*" -or
Name -like "*RJC-2*" -or
Name -like "*RJE-2*" -or
Name -like "*SCI-2*" -or
Name -like "*SGT-2*" -or
Name -like "*SPA-2*" -or
Name -like "*STC-2*" -or
Name -like "*STS-2*" -or
Name -like "*TCC-2*" -or
Name -like "*TCS-2*" -or
Name -like "*TDC-2*" -or
Name -like "*TES-2*" -or
Name -like "*TEX-2*" -or
Name -like "*TJA-2*" -or
Name -like "*TJH-2*" -or
Name -like "*TRA-2*" -or
Name -like "*USI-2*" -or
Name -like "*UTQ-2*" -or
Name -like "*VCI-2*" -or
Name -like "*VDI-2*" -or
Name -like "*VUS-2*" -or
Name -like "*WMC-2*" -or
Name -like "*WSI-2*" -or
Name -like "*ANS-5*" -or
Name -like "*ANSL-5*" -or
Name -like "*BBX-5*" -or
Name -like "*BPS-5*" -or
Name -like "*C2U-5*" -or
Name -like "*CBC-5*" -or
Name -like "*CCG-5*" -or
Name -like "*CCI-5*" -or
Name -like "*CCL-5*" -or
Name -like "*CCN-5*" -or
Name -like "*CLT-5*" -or
Name -like "*CMI-5*" -or
Name -like "*CSL-5*" -or
Name -like "*CVS-5*" -or
Name -like "*CVT-5*" -or
Name -like "*DII-5*" -or
Name -like "*EAI-5*" -or
Name -like "*EAT-5*" -or
Name -like "*ECC-5*" -or
Name -like "*FBT-5*" -or
Name -like "*GCI-5*" -or
Name -like "*GEM-5*" -or
Name -like "*GSU-5*" -or
Name -like "*HPC-5*" -or
Name -like "*IFS-5*" -or
Name -like "*IHS-5*" -or
Name -like "*KCL-5*" -or
Name -like "*LCS-5*" -or
Name -like "*LOC-5*" -or
Name -like "*MDX-5*" -or
Name -like "*NCI-5*" -or
Name -like "*NEO-5*" -or
Name -like "*NEOL-5*" -or
Name -like "*NFS-5*" -or
Name -like "*NSC-5*" -or
Name -like "*NST-5*" -or
Name -like "*PAU-5*" -or
Name -like "*PRT-5*" -or
Name -like "*PSU-5*" -or
Name -like "*PTI-5*" -or
Name -like "*PTN-5*" -or
Name -like "*PTP-5*" -or
Name -like "*PUC-5*" -or
Name -like "*PVC-5*" -or
Name -like "*RJC-5*" -or
Name -like "*RJE-5*" -or
Name -like "*SCI-5*" -or
Name -like "*SGT-5*" -or
Name -like "*SPA-5*" -or
Name -like "*STC-5*" -or
Name -like "*STS-5*" -or
Name -like "*TCC-5*" -or
Name -like "*TCS-5*" -or
Name -like "*TDC-5*" -or
Name -like "*TES-5*" -or
Name -like "*TEX-5*" -or
Name -like "*TJA-5*" -or
Name -like "*TJH-5*" -or
Name -like "*TRA-5*" -or
Name -like "*USI-5*" -or
Name -like "*UTQ-5*" -or
Name -like "*VCI-5*" -or
Name -like "*VDI-5*" -or
Name -like "*VUS-5*" -or
Name -like "*WMC-5*" -or
Name -like "*WSI-5*" -or
Name -like "*ANS-m*" -or
Name -like "*BBX-m*" -or
Name -like "*BPS-m*" -or
Name -like "*C2U-m*" -or
Name -like "*CBC-m*" -or
Name -like "*CCG-m*" -or
Name -like "*CCI-m*" -or
Name -like "*CCL-m*" -or
Name -like "*CCN-m*" -or
Name -like "*CLT-m*" -or
Name -like "*CMI-m*" -or
Name -like "*CSL-m*" -or
Name -like "*CVS-m*" -or
Name -like "*CVT-m*" -or
Name -like "*DII-m*" -or
Name -like "*EAI-m*" -or
Name -like "*EAT-m*" -or
Name -like "*ECC-m*" -or
Name -like "*FBT-m*" -or
Name -like "*GCI-m*" -or
Name -like "*GEM-m*" -or
Name -like "*GSU-m*" -or
Name -like "*HPC-m*" -or
Name -like "*IFS-m*" -or
Name -like "*IHS-m*" -or
Name -like "*KCL-m*" -or
Name -like "*LCS-m*" -or
Name -like "*LOC-m*" -or
Name -like "*MDX-m*" -or
Name -like "*NCI-m*" -or
Name -like "*NEO-m*" -or
Name -like "*NFS-m*" -or
Name -like "*NSC-m*" -or
Name -like "*NST-m*" -or
Name -like "*PAU-m*" -or
Name -like "*PRT-m*" -or
Name -like "*PSU-m*" -or
Name -like "*PTI-m*" -or
Name -like "*PTN-m*" -or
Name -like "*PTP-m*" -or
Name -like "*PUC-m*" -or
Name -like "*PVC-m*" -or
Name -like "*RJC-m*" -or
Name -like "*RJE-m*" -or
Name -like "*SCI-m*" -or
Name -like "*SGT-m*" -or
Name -like "*SPA-m*" -or
Name -like "*STC-m*" -or
Name -like "*STS-m*" -or
Name -like "*TCC-m*" -or
Name -like "*TCS-m*" -or
Name -like "*TDC-m*" -or
Name -like "*TES-m*" -or
Name -like "*TEX-m*" -or
Name -like "*TJA-m*" -or
Name -like "*TJH-m*" -or
Name -like "*TRA-m*" -or
Name -like "*USI-m*" -or
Name -like "*UTQ-m*" -or
Name -like "*VCI-m*" -or
Name -like "*VDI-m*" -or
Name -like "*VUS-m*" -or
Name -like "*WMC-m*" -or
Name -like "*WSI-m*" -or
Name -like "*ANC*" -or
Name -like "*ECC3684*" }  | Select-Object Name


foreach($server in $ANSProdSRV) {
$server = $server.name

if ($server -like "ANS*"){

Get-ADComputer -Identity $server | Move-ADObject -TargetPath 'OU=Laptops,OU=Computers,OU=ANS,OU=Company,DC=dynutil,DC=com'

}


if ($server -like "BBX*"){

Get-ADComputer -Identity $server | Move-ADObject -TargetPath 'OU=Laptops,OU=Computers,OU=BBX,OU=Company,DC=dynutil,DC=com'

}

if ($server -like "BPS*"){

Get-ADComputer -Identity $server | Move-ADObject -TargetPath 'OU=Laptops,OU=Computers,OU=BPS,OU=Company,DC=dynutil,DC=com'

}


if ($server -like "C2U*"){

Get-ADComputer -Identity $server | Move-ADObject -TargetPath 'OU=Laptops,OU=Computers,OU=C2U,OU=Company,DC=dynutil,DC=com'

}

if ($server -like "CBC*"){

Get-ADComputer -Identity $server | Move-ADObject -TargetPath 'OU=Laptops,OU=Computers,OU=CBC,OU=Company,DC=dynutil,DC=com'

}


if ($server -like "CCG*"){

Get-ADComputer -Identity $server | Move-ADObject -TargetPath 'OU=Laptops,OU=Computers,OU=CCG,OU=Company,DC=dynutil,DC=com'

}

if ($server -like "CCI*"){

Get-ADComputer -Identity $server | Move-ADObject -TargetPath 'OU=Laptops,OU=Computers,OU=CCI,OU=Company,DC=dynutil,DC=com'

}


if ($server -like "CCL*"){

Get-ADComputer -Identity $server | Move-ADObject -TargetPath 'OU=Laptops,OU=Computers,OU=CCL,OU=Company,DC=dynutil,DC=com'

}

if ($server -like "CCN*"){

Get-ADComputer -Identity $server | Move-ADObject -TargetPath 'OU=Laptops,OU=Computers,OU=CCN,OU=Company,DC=dynutil,DC=com'

}


if ($server -like "CLT*"){

Get-ADComputer -Identity $server | Move-ADObject -TargetPath 'OU=Laptops,OU=Computers,OU=CLT,OU=Company,DC=dynutil,DC=com'

}

if ($server -like "CMI*"){

Get-ADComputer -Identity $server | Move-ADObject -TargetPath 'OU=Laptops,OU=Computers,OU=CMI,OU=Company,DC=dynutil,DC=com'

}


if ($server -like "CSL*"){

Get-ADComputer -Identity $server | Move-ADObject -TargetPath 'OU=Laptops,OU=Computers,OU=CSL,OU=Company,DC=dynutil,DC=com'

}

if ($server -like "CVS*"){

Get-ADComputer -Identity $server | Move-ADObject -TargetPath 'OU=Laptops,OU=Computers,OU=CVS,OU=Company,DC=dynutil,DC=com'

}


if ($server -like "CVT*"){

Get-ADComputer -Identity $server | Move-ADObject -TargetPath 'OU=Laptops,OU=Computers,OU=CVT,OU=Company,DC=dynutil,DC=com'

}

if ($server -like "DII*"){

Get-ADComputer -Identity $server | Move-ADObject -TargetPath 'OU=Laptops,OU=Computers,OU=DII,OU=Company,DC=dynutil,DC=com'

}


if ($server -like "EAI*"){

Get-ADComputer -Identity $server | Move-ADObject -TargetPath 'OU=Laptops,OU=Computers,OU=EAI,OU=Company,DC=dynutil,DC=com'

}

if ($server -like "EAT*"){

Get-ADComputer -Identity $server | Move-ADObject -TargetPath 'OU=Laptops,OU=Computers,OU=EAT,OU=Company,DC=dynutil,DC=com'

}


if ($server -like "ECC*"){

Get-ADComputer -Identity $server | Move-ADObject -TargetPath 'OU=Laptops,OU=Computers,OU=ECC,OU=Company,DC=dynutil,DC=com'

}

if ($server -like "FBT*"){

Get-ADComputer -Identity $server | Move-ADObject -TargetPath 'OU=Laptops,OU=Computers,OU=FBT,OU=Company,DC=dynutil,DC=com'

}


if ($server -like "GCI*"){

Get-ADComputer -Identity $server | Move-ADObject -TargetPath 'OU=Laptops,OU=Computers,OU=GCI,OU=Company,DC=dynutil,DC=com'

}


if ($server -like "GEM*"){

Get-ADComputer -Identity $server | Move-ADObject -TargetPath 'OU=Laptops,OU=Computers,OU=GEM,OU=Company,DC=dynutil,DC=com'

}


if ($server -like "GSU*"){

Get-ADComputer -Identity $server | Move-ADObject -TargetPath 'OU=Laptops,OU=Computers,OU=GSU,OU=Company,DC=dynutil,DC=com'

}

if ($server -like "HPC*"){

Get-ADComputer -Identity $server | Move-ADObject -TargetPath 'OU=Laptops,OU=Computers,OU=HPC,OU=Company,DC=dynutil,DC=com'

}


if ($server -like "IFS*"){

Get-ADComputer -Identity $server | Move-ADObject -TargetPath 'OU=Laptops,OU=Computers,OU=IFS,OU=Company,DC=dynutil,DC=com'

}

if ($server -like "IHS*"){

Get-ADComputer -Identity $server | Move-ADObject -TargetPath 'OU=Laptops,OU=Computers,OU=IHS,OU=Company,DC=dynutil,DC=com'

}


if ($server -like "KCL*"){

Get-ADComputer -Identity $server | Move-ADObject -TargetPath 'OU=Laptops,OU=Computers,OU=KCL,OU=Company,DC=dynutil,DC=com'

}

if ($server -like "LCS*"){

Get-ADComputer -Identity $server | Move-ADObject -TargetPath 'OU=Laptops,OU=Computers,OU=LCS,OU=Company,DC=dynutil,DC=com'

}


if ($server -like "LOC*"){

Get-ADComputer -Identity $server | Move-ADObject -TargetPath 'OU=Laptops,OU=Computers,OU=LOC,OU=Company,DC=dynutil,DC=com'

}

if ($server -like "MDX*"){

Get-ADComputer -Identity $server | Move-ADObject -TargetPath 'OU=Laptops,OU=Computers,OU=MDX,OU=Company,DC=dynutil,DC=com'

}


if ($server -like "NCI*"){

Get-ADComputer -Identity $server | Move-ADObject -TargetPath 'OU=Laptops,OU=Computers,OU=NCI,OU=Company,DC=dynutil,DC=com'

}


if ($server -like "NEO*"){

Get-ADComputer -Identity $server | Move-ADObject -TargetPath 'OU=Laptops,OU=Computers,OU=NEO,OU=Company,DC=dynutil,DC=com'

}


if ($server -like "NFS*"){

Get-ADComputer -Identity $server | Move-ADObject -TargetPath 'OU=Laptops,OU=Computers,OU=NFS,OU=Company,DC=dynutil,DC=com'

}

if ($server -like "NSC*"){

Get-ADComputer -Identity $server | Move-ADObject -TargetPath 'OU=Laptops,OU=Computers,OU=NSC,OU=Company,DC=dynutil,DC=com'

}


if ($server -like "NST*"){

Get-ADComputer -Identity $server | Move-ADObject -TargetPath 'OU=Laptops,OU=Computers,OU=NST,OU=Company,DC=dynutil,DC=com'

}

if ($server -like "PAU*"){

Get-ADComputer -Identity $server | Move-ADObject -TargetPath 'OU=Laptops,OU=Computers,OU=PAU,OU=Company,DC=dynutil,DC=com'

}


if ($server -like "PRT*"){

Get-ADComputer -Identity $server | Move-ADObject -TargetPath 'OU=Laptops,OU=Computers,OU=PRT,OU=Company,DC=dynutil,DC=com'

}

if ($server -like "PSU*"){

Get-ADComputer -Identity $server | Move-ADObject -TargetPath 'OU=Laptops,OU=Computers,OU=PSU,OU=Company,DC=dynutil,DC=com'

}


if ($server -like "PTI*"){

Get-ADComputer -Identity $server | Move-ADObject -TargetPath 'OU=Laptops,OU=Computers,OU=PTI,OU=Company,DC=dynutil,DC=com'

}

if ($server -like "PTN*"){

Get-ADComputer -Identity $server | Move-ADObject -TargetPath 'OU=Laptops,OU=Computers,OU=PTN,OU=Company,DC=dynutil,DC=com'

}


if ($server -like "PUC*"){

Get-ADComputer -Identity $server | Move-ADObject -TargetPath 'OU=Laptops,OU=Computers,OU=PUC,OU=Company,DC=dynutil,DC=com'

}


if ($server -like "PVC*"){

Get-ADComputer -Identity $server | Move-ADObject -TargetPath 'OU=Laptops,OU=Computers,OU=PVC,OU=Company,DC=dynutil,DC=com'

}


if ($server -like "RJC*"){

Get-ADComputer -Identity $server | Move-ADObject -TargetPath 'OU=Laptops,OU=Computers,OU=RJC,OU=Company,DC=dynutil,DC=com'

}

if ($server -like "RJE*"){

Get-ADComputer -Identity $server | Move-ADObject -TargetPath 'OU=Laptops,OU=Computers,OU=RJE,OU=Company,DC=dynutil,DC=com'

}


if ($server -like "SCI*"){

Get-ADComputer -Identity $server | Move-ADObject -TargetPath 'OU=Laptops,OU=Computers,OU=SCI,OU=Company,DC=dynutil,DC=com'

}

if ($server -like "SGT*"){

Get-ADComputer -Identity $server | Move-ADObject -TargetPath 'OU=Laptops,OU=Computers,OU=SGT,OU=Company,DC=dynutil,DC=com'

}


if ($server -like "SPA*"){

Get-ADComputer -Identity $server | Move-ADObject -TargetPath 'OU=Laptops,OU=Computers,OU=SPA,OU=Company,DC=dynutil,DC=com'

}

if ($server -like "STC*"){

Get-ADComputer -Identity $server | Move-ADObject -TargetPath 'OU=Laptops,OU=Computers,OU=STC,OU=Company,DC=dynutil,DC=com'

}


if ($server -like "STS*"){

Get-ADComputer -Identity $server | Move-ADObject -TargetPath 'OU=Laptops,OU=Computers,OU=STS,OU=Company,DC=dynutil,DC=com'

}

if ($server -like "TCC*"){

Get-ADComputer -Identity $server | Move-ADObject -TargetPath 'OU=Laptops,OU=Computers,OU=TCC,OU=Company,DC=dynutil,DC=com'

}


if ($server -like "TCS*"){

Get-ADComputer -Identity $server | Move-ADObject -TargetPath 'OU=Laptops,OU=Computers,OU=TCS,OU=Company,DC=dynutil,DC=com'

}


if ($server -like "TDC*"){

Get-ADComputer -Identity $server | Move-ADObject -TargetPath 'OU=Laptops,OU=Computers,OU=TDC,OU=Company,DC=dynutil,DC=com'

}


if ($server -like "TES*"){

Get-ADComputer -Identity $server | Move-ADObject -TargetPath 'OU=Laptops,OU=Computers,OU=TES,OU=Company,DC=dynutil,DC=com'

}

if ($server -like "TEX*"){

Get-ADComputer -Identity $server | Move-ADObject -TargetPath 'OU=Laptops,OU=Computers,OU=TEX,OU=Company,DC=dynutil,DC=com'

}


if ($server -like "TJA*"){

Get-ADComputer -Identity $server | Move-ADObject -TargetPath 'OU=Laptops,OU=Computers,OU=TJA,OU=Company,DC=dynutil,DC=com'

}

if ($server -like "TJH*"){

Get-ADComputer -Identity $server | Move-ADObject -TargetPath 'OU=Laptops,OU=Computers,OU=TJH,OU=Company,DC=dynutil,DC=com'

}


if ($server -like "TRA*"){

Get-ADComputer -Identity $server | Move-ADObject -TargetPath 'OU=Laptops,OU=Computers,OU=TRA,OU=Company,DC=dynutil,DC=com'

}

if ($server -like "USI*"){

Get-ADComputer -Identity $server | Move-ADObject -TargetPath 'OU=Laptops,OU=Computers,OU=USI,OU=Company,DC=dynutil,DC=com'

}


if ($server -like "UTQ*"){

Get-ADComputer -Identity $server | Move-ADObject -TargetPath 'OU=Laptops,OU=Computers,OU=UTQ,OU=Company,DC=dynutil,DC=com'

}

if ($server -like "VCI*"){

Get-ADComputer -Identity $server | Move-ADObject -TargetPath 'OU=Laptops,OU=Computers,OU=VCI,OU=Company,DC=dynutil,DC=com'

}


if ($server -like "VUS*"){

Get-ADComputer -Identity $server | Move-ADObject -TargetPath 'OU=Laptops,OU=Computers,OU=VUS,OU=Company,DC=dynutil,DC=com'

}


if ($server -like "WMC*"){

Get-ADComputer -Identity $server | Move-ADObject -TargetPath 'OU=Laptops,OU=Computers,OU=WMC,OU=Company,DC=dynutil,DC=com'

}

if ($server -like "WSI*"){

Get-ADComputer -Identity $server | Move-ADObject -TargetPath 'OU=Laptops,OU=Computers,OU=VWSI,OU=Company,DC=dynutil,DC=com'

}



}