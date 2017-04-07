$VMs = Get-VM

foreach ($VM in $VMs)
    {
        if (-not $((Get-VMDvdDrive -VMName $VM.VMName).Path -eq $null))
            {
                Write-Verbose "$($VM.VMName)´'s DVD drive is not empty. Going to eject the ISO now"
                Get-VMDvdDrive -VMName $VM.Name | Set-VMDvdDrive -Path $null
                if ($?)
                    {
                        "All good!"
                    }
            }
    }