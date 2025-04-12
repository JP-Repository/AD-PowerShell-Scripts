<#
.SYNOPSIS
    Exports users who are NOT members of 'Domain Users' and also do NOT have it as their primary group.

.DESCRIPTION
    This script queries all users in Active Directory, checks if they are not explicitly a member of the 'Domain Users' group,
    and also checks if 'Domain Users' is NOT set as their primary group. The result is exported to a CSV file.

.NOTES
    Script Name    : Export-NonDomainUsersPrimaryGroup.ps1
    Version        : 1.0
    Author         : [Your Name]
    Date           : [Date]
    Purpose        : Audit AD users not tied to 'Domain Users' group in any way

.PREREQUISITES
    - ActiveDirectory module
    - Appropriate permissions to query AD

.EXAMPLE
    Run the script in PowerShell:
    ./Export-NonDomainUsersPrimaryGroup.ps1
#>

# Get Domain Users group's RID
$domainUsersGroup = Get-ADGroup "Domain Users"
$domainUsersRID = $domainUsersGroup.PrimaryGroupToken

# Get all users
$users = Get-ADUser -Filter * -Properties MemberOf, PrimaryGroupID

# Filter users who are not members of Domain Users and do not have it as primary group
$filteredUsers = $users | Where-Object {
    ($_).PrimaryGroupID -ne $domainUsersRID -and
    ($_.MemberOf -notcontains $domainUsersGroup.DistinguishedName)
}

# Select desired properties to export
$filteredUsers | Select-Object Name, SamAccountName, PrimaryGroupID, DistinguishedName |
Export-Csv -Path "C:\Temp\Users_NotIn_DomainUsers.csv" -NoTypeInformation

Write-Host "Export complete: Users_NotIn_DomainUsers.csv"
