<#
.SYNOPSIS
    This script exports all Active Directory Organizational Units (OUs) that are not protected from accidental deletion.
    It retrieves the status of the `ProtectedFromAccidentalDeletion` property for each OU and generates a CSV report.

.DESCRIPTION
    This script connects to Active Directory and retrieves all OUs with the `ProtectedFromAccidentalDeletion` property set to `false`.
    The filtered list of OUs is then exported to a CSV file, which includes details such as the `DistinguishedName`, `Name`, and the protection status.
    The resulting CSV will be saved in the `C:\Temp` directory, and the file will be named with the current date.

.NOTES
    Script Name    : Get-ADOUs-Not-Protected.ps1
    Version        : 0.1
    Author         : [Your Name]
    Approved By    : [Approver's Name]
    Date           : [Date]
    Purpose        : Export list of OUs not protected from accidental deletion.

.PARAMETERS
    None

.EXAMPLE
    PS> .\Get-ADOUs-Not-Protected.ps1
    This will generate a CSV file containing OUs that are not protected from accidental deletion.

#>

# Start of Script

# Import the ActiveDirectory module
Import-Module ActiveDirectory

# Fetch all OUs that are not protected from accidental deletion
Get-ADOrganizationalUnit -Filter * -Properties * | 
    Where-Object { $_.ProtectedFromAccidentalDeletion -eq $false } | 
    Export-Csv "C:\Temp\OUStatus_$(Get-Date -Format 'dd-MM-yyyy').csv" -NoTypeInformation

# End of Script
