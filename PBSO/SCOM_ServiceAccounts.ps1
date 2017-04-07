#create scom service accounts
New-ADUser -Name "SCOM_AA" -GivenName SCOM -Surname AA -SamAccountName scom_aa -UserPrincipalName scom_aa@<domain.com> -AccountPassword (ConvertTo-SecureString “Passw0rd” -AsPlainText -Force) -PassThru  | Enable-ADAccount
New-ADUser -Name "SCOM_DA" -GivenName SCOM -Surname DA -SamAccountName scom_da -UserPrincipalName scom_da@<domain.com> -AccountPassword (ConvertTo-SecureString “Passw0rd” -AsPlainText -Force) -PassThru | Enable-ADAccount
New-ADUser -Name "SCOM_OMS" -GivenName SCOM -Surname OMS -SamAccountName scom_oms -UserPrincipalName scom_oms@<domain.com> -AccountPassword (ConvertTo-SecureString “Passw0rd” -AsPlainText -Force) -PassThru | Enable-ADAccount

#create scom sql accounts
New-ADUser -Name "SCOM_SQL_READ" -GivenName SCOM -Surname SQL_READ -SamAccountName scom_sql_read -UserPrincipalName scom_sql_read@<domain.com> -AccountPassword (ConvertTo-SecureString “Passw0rd” -AsPlainText -Force) -PassThru | Enable-ADAccount
New-ADUser -Name "SCOM_SQL_WRITE" -GivenName SCOM -Surname SQL_WRITE -SamAccountName scom_sql_write -UserPrincipalName scom_sql_write@<domain.com> -AccountPassword (ConvertTo-SecureString “Passw0rd” -AsPlainText -Force) -PassThru | Enable-ADAccount

#create scom admins security group, add scom_aa and scom_da to the group
New-ADGroup SCOM_ADMINS  -GroupScope Global -GroupCategory Security
Add-ADGroupMember SCOM_ADMINS -Members scom_aa
Add-ADGroupMember SCOM_ADMINS -Members scom_da
