<#
.SYNOPSIS
    Exports all Active Directory user accounts with all attributes to a CSV file, naming the file based on the current date.

.DESCRIPTION
    This script retrieves all user accounts from Active Directory, including all properties and attributes. The user details are then exported to a CSV file, with the filename dynamically created based on the current date. This can be useful for reporting, backups, or auditing purposes where the most up-to-date AD user information is required.

.NOTES
    Script Name    : ExportAllADUsers.ps1
    Version        : 0.1
    Author         : [Your Name]
    Approved By    : [Approver's Name]
    Date           : [Date]
    Purpose        : Exports all AD user account details, including attributes, to a CSV file with the current date in the filename.

.PREREQUISITES
    - Active Directory module for PowerShell should be installed.
    - The script must be run with sufficient privileges (e.g., domain admin).
    - The target directory (e.g., `C:\Temp\`) must be writable.

.PARAMETERS
    None required for this script. The script retrieves all AD user accounts automatically.

.EXAMPLE
    Example of running the script:

    PS C:\> .\ExportAllADUsers.ps1

    This will generate a CSV file in the `C:\Temp\` directory, with the filename containing the current date, such as:

    `All_AD_Users_13-12-2024.csv`

    The CSV file will contain all Active Directory user accounts with all available attributes.

#>

# Start of Script

# Importing Module
Import-Module ActiveDirectory

# Fetching all AD Users with all attributes and exporting with current date
Get-ADUser -Filter * -Properties * | Export-Csv C:\Temp\All_AD_Users_$(get-date -f dd-MM-yyyy).csv

# End of Script
