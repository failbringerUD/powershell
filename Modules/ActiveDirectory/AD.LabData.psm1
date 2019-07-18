<#
.Synopsis
  Exports AD data for Objects to be imported to Lab
.DESCRIPTION
   Long description
.EXAMPLE
   Example of how to use this cmdlet
.EXAMPLE
   Another example of how to use this cmdlet
.NOTES
  This Cmddlet requires that the RSAT AD Tools are installed, and that there is a domain controller running ADWS availiable. (2008 R2/2012 DCs have it by default)


                             THIS CODE AND ANY ASSOCIATED INFORMATION ARE PROVIDED “AS IS” WITHOUT WARRANTY OF ANY KIND, EITHER EXPRESSED OR 
                             IMPLIED, INCLUDING BUT NOT LIMITED TO THE IMPLIED WARRANTIES OF MERCHANTABILITY AND/OR FITNESS FOR A PARTICULAR
                             PURPOSE. THE ENTIRE RISK OF USE, INABILITY TO USE, OR RESULTS FROM THE USE OF THIS CODE REMAINS WITH THE USER.




#>
function Get-ADDataForLab
{
    [CmdletBinding()]
    [OutputType([int])]
    Param
    (
       
    )

    Begin
    {
        
    }
    Process
    {
        Write-Verbose "Retrieving OUs..."
        $OUs = (Get-ADOrganizationalUnit -Filter {Name -like '*'} -Properties *)
        Write-Verbose "Exporting OUs..."
        $OUS|Export-Clixml "$PWD\AD.OUS.Clixml"
        $OUS = $null
        Write-Verbose "OUs are Exported to CliXML!"
        
        Write-Verbose "Retrieving Groups...."
        $Groups = (Get-ADGroup -Filter {Samaccountname -like '*'} -Properties *)
        Write-Verbose "Exporting Groups..."
        $Groups|Export-Clixml "$PWD\AD.Groups.Clixml"
        $Groups = $null
        Write-Verbose "Groups are Exported to CliXML!"

        Write-Verbose "Retrieving Users...."
        $Users = (Get-ADUser -Filter {Samaccountname -like '*'} -Properties *)
        Write-Verbose "Exporting Users..."
        $Users|Export-Clixml "$PWD\AD.Users.Clixml"
        $users = $null
        Write-Verbose "Users are Exported to CliXml!"

        Write-Verbose "Retrieving Computers...."
        $Computers = (Get-ADComputer -Filter {Samaccountname -like '*'} -Properties *)
        Write-Verbose "Exporting Users..."
        $Computers|Export-Clixml "$PWD\AD.Computers.Clixml"
        $Computers = $null
        Write-Verbose "Computers are Exported to CliXml!"

        
    }
    End
    {
    }
}

