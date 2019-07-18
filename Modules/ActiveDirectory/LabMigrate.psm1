<#
.Synopsis
   Short description
.DESCRIPTION
   Long description
.EXAMPLE
   Example of how to use this cmdlet
.EXAMPLE
   Another example of how to use this cmdlet

                             THIS CODE AND ANY ASSOCIATED INFORMATION ARE PROVIDED “AS IS” WITHOUT WARRANTY OF ANY KIND, EITHER EXPRESSED OR 
                             IMPLIED, INCLUDING BUT NOT LIMITED TO THE IMPLIED WARRANTIES OF MERCHANTABILITY AND/OR FITNESS FOR A PARTICULAR
                             PURPOSE. THE ENTIRE RISK OF USE, INABILITY TO USE, OR RESULTS FROM THE USE OF THIS CODE REMAINS WITH THE USER.


#>
function Update-ADLabUsers
{
    [CmdletBinding()]
    [OutputType([int])]
    Param
    (
        # Param1 help description
        [Parameter(Mandatory=$true,
                   ValueFromPipelineByPropertyName=$true,
                   Position=0)]
        $sourceUser,

        # Param2 help description
        [string[]]
        $Properties = @("DisplayName","sn","givenName","initials","c","co","description","l","telephoneNumber","mobile","EmployeeType","physicaldeliveryofficename","info","title","Streetaddress","st","scriptpath","postaladdress","division","employeeID","EmployeeNumber","department","company"),
        [switch]
        $CreateMissing,
        [switch]
        $IncludeReferences,
        [switch]
        $MoveUser,
        [switch]
        $RenameUser

    )

    Begin
    {
        if ($IncludeReferences)
        {
            $Properties += "manager"
            $Properties += "ManagedBy"
        }

        $sourceusername=$sourceUser.samaccountname
        $labUser = get-aduser -Filter {Samaccountname -eq $sourceusername} -Properties $Properties
        $propReplace = @{}
        $propClear =@()
    }
    Process
    {
        if ($labUser -notlike $null)
        {
            $Properties|ForEach-Object{$prop=$_;
                            $labvalue =$null
                            $sourceValue =$null

                            if ($sourceUser.$prop -ne $null)
                            {
                            $labValue = $labUser.$prop
                            $sourceValue = $sourceUser.$prop.Replace("DC=dynutil,DC=com","DC=DEV,DC=local")
                            }
                            if ($labValue -ne $sourceValue)
                            {
                                
                                if ($sourceValue -like $null)
                                {
                                    if($labValue -notlike $null)
                                    {
                                    
                                    $clear = "[{0}]-source-[{1}]-Lab-[{2}]-Clear" -f $prop,$sourceValue,$labValue
                                    Write-Verbose $clear
                                     $propClear += $prop   
                                    }
                                }
                                else
                                {
                                    
                                    $update = "[{0}]-source-[{1}]-Lab-[{2}]-Replace" -f $prop,$sourceValue,$labValue
                                    Write-Verbose $update
                                    $prop.replace("SurName","sn")
                                    $propReplace.Add($prop,$sourceValue)
                                
                                }
                            }
                           
                            }
         
         
        
            if ($propReplace.count -gt 0)
            {
                set-aduser ($labuser.samaccountname) -Replace $propReplace
                Write-VErbose "User Updated!"
            }

             if ($propClear.count -gt 0)
            {
                $propClear
                set-aduser ($labuser.samaccountname) -Clear $propClear
                Write-VErbose "User Cleared!!"
            }

            if ($MoveUser)
            {
                $prodDN = $sourceUser.DistinguishedName.Replace("DC=dynutil,DC=com","DC=DEV,DC=local")
                $labDN = $labUser.DistinguishedName

                if ($prodDN -ne $labDN)
                {
                    $move = "Move-Source-[{0}]-Lab-[{1}]" -f $prodDN,$labDN
                    Write-Verbose $move
                    Move-ADObject -TargetPath $prodDN.replace(("CN="+$sourceUser.Name.Replace(",","\,")+","),"") -Identity $labDn
                }
            }

             if ($RenameUser)
            {
                $prodName = $sourceUser.Name
                $labName = $labUser.Name
                $labDN = $labUser.DistinguishedName

                if ($prodName -ne $labName)
                {
                    $rename = "Rename-Source-[{0}]-Lab-[{1}]" -f $prodName,$labName
                    Write-Verbose $rename
                    Rename-ADObject -Identity $labDn -NewName $prodName
                }
            }
        }
        else
        {
            if ($CreateMissing -eq $true )
            {
             if ($sourceusername -notlike "*$")
             {
                Write-Verbose "Creating Missing User $sourceusername"
                $oldPath = ($sourceuser.distinguishedname)
                #Write-Verbose = "OldPath=[$oldPath]"
                $NewCN=$sourceuser.Name.Replace(',','\,')
                $NewCN=$NewCN.Replace('+','\+')
                $newPath = ($sourceUser.DistinguishedName.Replace("CN=$NewCN,","").Replace("DC=dynutil,","DC=DEV,"))
                Write-Verbose "NewPath=[$newPath]"
                $rand = New-Object System.Random
                1..20 | ForEach-Object { $NewPassword = $NewPassword + [char]$rand.next(33,127) }
                new-aduser -Name $sourceUser.Name -Path $newPath -SamAccountName $sourceUser.samaccountname -Enabled $sourceuser.Enabled -AccountPassword (ConvertTo-SecureString $NewPassword -AsPlainText -Force) -UserPrincipalName ("{0}@hospiralab.corp" -f $sourceuser.samaccountname)  -OtherAttributes @{"extensionAttribute15"='Scripted'} 
            }
            }
        }
    }
       
       
    
    
    End
    {   
        
    }
}

<#
.Synopsis
   Short description
.DESCRIPTION
   Long description
.EXAMPLE
   Example of how to use this cmdlet
.EXAMPLE
   Another example of how to use this cmdlet
#>
function Update-ADLabGroups
{
    [CmdletBinding()]
    [OutputType([int])]
    Param
    (
        # Param1 help description
        [Parameter(Mandatory=$true,
                   ValueFromPipelineByPropertyName=$true,
                   Position=0)]
        $SourceGroup,

        # Param2 help description
        [string[]]
        $Properties = @("DisplayName","description","info"),
        [switch]
        $CreateMissing,
        [switch]
        $IncludeReferences,
        [switch]
        $MoveGroup,
        [switch]
        $RenameGroup,
        [switch]
        $IncludeMember
    )

    Begin
    {
        if ($IncludeReferences)
        {
            $Properties += "managedBy"
        }

        $sourcegroupname=$sourcegroup.samaccountname
        $labGroup = get-adgroup -Filter {Samaccountname -eq $sourcegroupname} -Properties $Properties
        $propReplace = @{}
        $propClear =@()
    }
    Process
    {
        if ($labgroup -notlike $null)
        {
            $Properties|ForEach-Object{$prop=$_;
                            $labvalue =$null
                            $sourceValue =$null

                            if ($sourcegroup.$prop -ne $null)
                            {
                            $labValue = $labgroup.$prop
                            $sourceValue = $sourcegroup.$prop.Replace("DC=dynutil,DC=com","DC=DEV,DC=local")
                            }
                            if ($labValue -ne $sourceValue)
                            {
                                
                                if ($sourceValue -like $null)
                                {
                                    if($labValue -notlike $null)
                                    {
                                    
                                    $clear = "[{0}]-source-[{1}]-Lab-[{2}]-Clear" -f $prop,$sourceValue,$labValue
                                    Write-Verbose $clear
                                     $propClear += $prop   
                                    }
                                }
                                else
                                {
                                    
                                    $update = "[{0}]-source-[{1}]-Lab-[{2}]-Replace" -f $prop,$sourceValue,$labValue
                                    Write-Verbose $update

                                    $propReplace.Add($prop,$sourceValue)
                                
                                }
                            }
                           
                            }
         
         #Write-verbose $PropReplace.count
        
            if ($propReplace.count -gt 0)
            {
                set-adgroup ($labgroup.samaccountname) -Replace $propReplace
                Write-VErbose "Group Updated!"
            }

             if ($propClear.count -gt 0)
            {
                $propClear
                set-adgroup ($labgroup.samaccountname) -Clear $propClear
                Write-VErbose "Group Cleared!!"
            }

             if ($MoveGroup)
            {
                $prodDN = $sourceGroup.DistinguishedName.Replace("DC=dynutil,DC=com","DC=DEV,DC=local")
                $labDN = $labGroup.DistinguishedName

                if ($prodDN -ne $labDN)
                {
                    $move = "Move-Source-[{0}]-Lab-[{1}]" -f $prodDN,$labDN
                    Write-Verbose $move
                    Move-ADObject -TargetPath $prodDN.replace(("CN="+$sourceGroup.Name.Replace(",","\,").Replace("#","\#")+","),"") -Identity $labDn
                }
            }

             if ($RenameGroup)
            {
                $prodName = $sourceGroup.Name
                $labName = $labGroup.Name
                $labDN = $labGroup.DistinguishedName

                if ($prodName -ne $labName)
                {
                    $rename = "Rename-Source-[{0}]-Lab-[{1}]" -f $prodName,$labName
                    Write-Verbose $rename
                    Rename-ADObject -Identity $labDn -NewName $prodName
                }
            }

            if ($IncludeMember)
            {
                if ($SourceGroup.Member.Count -gt 0)
                {
                    $SourceGroup.Member|ForEach-Object{$m = $_.Replace("DC=dynutil,DC=com","DC=DEV,DC=local")

                        if ($labGroup.Member -notcontains $m)
                        {
                            $addMember = "AddMember-[{0}] to Group-[{1}]" -f $m,$labgroup.samaccountname
                            write-verbose $addMember
                            Add-ADGroupMember -Identity $labGroup.samaccountname -Members $m
                        }
                        }
                }

            }
        }
        else
        {
            if ($CreateMissing -eq $true )
            {
             
                Write-Verbose "Creating Missing Group $sourceGroupName"
                $oldPath = ($sourcegroup.distinguishedname)
                #Write-Verbose = "OldPath=[$oldPath]"
                $NewCN=$sourcegroup.Name.Replace(',','\,')
                $NewCN=$NewCN.Replace('+','\+')
                $newPath = ($sourcegroup.DistinguishedName.Replace("CN=$NewCN,","").Replace("DC=dynutil,","DC=DEV,"))
                Write-Verbose "NewPath=[$newPath]"
                new-adgroup -Name $sourceGroup.Name -Path $newPath -SamAccountName $sourceGroup.samaccountname -GroupScope $sourceGroup.GroupScope -GroupCategory $sourcegroup.Groupcategory
            
            }
        }
    }
       
       
    
    
    End
    {   
        
    }
}

<#
.Synopsis
   Short description
.DESCRIPTION
   Long description
.EXAMPLE
   Example of how to use this cmdlet
.EXAMPLE
   Another example of how to use this cmdlet
#>
function Update-ADLabOUs
{
    [CmdletBinding()]
    [OutputType([int])]
    Param
    (
        # Param1 help description
        [Parameter(Mandatory=$true,
                   ValueFromPipelineByPropertyName=$true,
                   Position=0)]
        $SourceOUs,

        # Param2 help description
        [string[]]
        $Properties = @("DisplayName","description","Name"),
        [switch]
        $CreateMissing
    )

    Begin
    {
        $sourcegroupname=$sourcegroup.samaccountname
        $labGroup = get-adgroup -Filter {Samaccountname -eq $sourcegroupname} -Properties $Properties
        $propReplace = @{}
        $propClear =@()
    }
    Process
    {
        if ($labgroup -notlike $null)
        {
            $Properties|ForEach-Object{$prop=$_;
                            $labvalue =$null
                            $sourceValue =$null

                            if ($sourcegroup.$prop -ne $null)
                            {
                            $labValue = $labgroup.$prop
                            $sourceValue = $sourcegroup.$prop.Replace("DC=dynutil,DC=com","DC=DEV,DC=local")
                            }
                            if ($labValue -ne $sourceValue)
                            {
                                
                                if ($sourceValue -like $null)
                                {
                                    if($labValue -notlike $null)
                                    {
                                    
                                    $clear = "[{0}]-source-[{1}]-Lab-[{2}]-Clear" -f $prop,$sourceValue,$labValue
                                    Write-Verbose $clear
                                     $propClear += $prop   
                                    }
                                }
                                else
                                {
                                    
                                    $update = "[{0}]-source-[{1}]-Lab-[{2}]-Replace" -f $prop,$sourceValue,$labValue
                                    Write-Verbose $update

                                    $propReplace.Add($prop,$sourceValue)
                                
                                }
                            }
                           
                            }
         
         #Write-verbose $PropReplace.count
        
            if ($propReplace.count -gt 0)
            {
                set-adgroup ($labgroup.samaccountname) -Replace $propReplace
                Write-VErbose "Group Updated!"
            }

             if ($propClear.count -gt 0)
            {
                $propClear
                set-adgroup ($labgroup.samaccountname) -Clear $propClear
                Write-VErbose "Group Cleared!!"
            }
        }
        else
        {
            if ($CreateMissing -eq $true )
            {
             
                Write-Verbose "Creating Missing Group $sourceGroupName"
                $oldPath = ($sourcegroup.distinguishedname)
                #Write-Verbose = "OldPath=[$oldPath]"
                $NewCN=$sourcegroup.Name.Replace(',','\,')
                $NewCN=$NewCN.Replace('+','\+')
                $newPath = ($sourcegroup.DistinguishedName.Replace("CN=$NewCN,","").Replace("DC=dynutil,","DC=DEV,"))
                Write-Verbose "NewPath=[$newPath]"
                new-adgroup -Name $sourceGroup.Name -Path $newPath -SamAccountName $sourceGroup.samaccountname -GroupScope $sourceGroup.GroupScope -GroupCategory $sourcegroup.Groupcategory
            
            }
        }
    }
       
       
    
    
    End
    {   
        
    }
}
