<#
.SYNOPSIS
    This script exports all Active Directory Organizational Units (OUs) into a CSV file.
    The CSV file includes details about each OU, including properties like `DistinguishedName`, `Name`, and more.

.DESCRIPTION
    This script retrieves all Organizational Units (OUs) from Active Directory, along with all their properties.
    The details are exported to a CSV file named `AllOU_dd-MM-yyyy.csv`, saved in the `C:\Temp` directory. 
    The file will contain all OUs in the Active Directory, and the properties will include a wide range of AD-specific attributes.

.NOTES
    Script Name    : Export-AD-AllOUs.ps1
    Version        : 0.1
    Author         : [Your Name]
    Approved By    : [Approver's Name]
    Date           : [Date]
    Purpose        : Export all OUs from Active Directory to a CSV file for analysis or documentation.

.PARAMETERS
    None

.EXAMPLE
    PS> .\Export-AD-AllOUs.ps1
    This will generate a CSV file containing all OUs in Active Directory, saved in the `C:\Temp` directory.

#>

# Start of Script

# Import the ActiveDirectory module
Import-Module ActiveDirectory

# Fetch all Organizational Units (OUs) and export them to a CSV file
Get-ADOrganizationalUnit -Filter * -Properties * | 
    Export-Csv "C:\Temp\AllOU_$(Get-Date -Format 'dd-MM-yyyy').csv" -NoTypeInformation

Write-Host "Export completed. All OUs have been saved to C:\Temp\AllOU_$(Get-Date -Format 'dd-MM-yyyy').csv" -ForegroundColor Green

# End of Script
