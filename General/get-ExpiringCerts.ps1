function getExpiringCerts ($duedays=60,$CAlocation="srv.fqdn.sk\CA Name") {
  $certs = @()
  $now = get-Date;
  $expirationdate = $now.AddDays($duedays)
  $CaView = New-Object -Com CertificateAuthority.View.1
  [void]$CaView.OpenConnection($CAlocation)
  $CaView.SetResultColumnCount(5)
  $index0 = $CaView.GetColumnIndex($false, "Issued Common Name")
  $index1 = $CaView.GetColumnIndex($false, "Certificate Expiration Date")
  $index2 = $CaView.GetColumnIndex($false, "Issued Email Address")
  $index3 = $CaView.GetColumnIndex($false, "Certificate Template")
  $index4 = $CaView.GetColumnIndex($false, "Request Disposition")
  $index0, $index1, $index2, $index3, $index4 | %{$CAView.SetResultColumn($_)}

  # CVR_SORT_NONE 0
  # CVR_SEEK_EQ  1
  # CVR_SEEK_LT  2
  # CVR_SEEK_GT  16


  $index1 = $CaView.GetColumnIndex($false, "Certificate Expiration Date")
  $CAView.SetRestriction($index1,16,0,$now)
  $CAView.SetRestriction($index1,2,0,$expirationdate)

  # brief disposition code explanation:
  # 9 - pending for approval
  # 15 - CA certificate renewal
  # 16 - CA certificate chain
  # 20 - issued certificates
  # 21 - revoked certificates
  # all other - failed requests
  $CAView.SetRestriction($index4,1,0,20)

  $RowObj= $CAView.OpenView()

  while ($Rowobj.Next() -ne -1){
    $Cert = New-Object PsObject
    $ColObj = $RowObj.EnumCertViewColumn()
    [void]$ColObj.Next()
    do {
      $current = $ColObj.GetName()
      $Cert | Add-Member -MemberType NoteProperty $($ColObj.GetDisplayName()) -Value $($ColObj.GetValue(1)) -Force
    } until ($ColObj.Next() -eq -1)
    Clear-Variable ColObj
    $datediff = New-TimeSpan -Start ($now) -End ($cert."Certificate Expiration Date")
    "Certificate " + $cert."Issued Common Name" + " will expire in " + $datediff.Days + " days at " + $cert."Certificate Expiration Date"
    "Send email to : " + $cert."Issued Email Address"
    "------------------------"
  }
  $RowObj.Reset()
  $CaView = $null
  [GC]::Collect()
}