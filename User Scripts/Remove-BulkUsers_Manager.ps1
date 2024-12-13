<#
.SYNOPSIS
    Removes the Manager attribute from Active Directory user accounts based on input from a CSV file.

.DESCRIPTION
    This script reads a CSV file containing a list of user accounts (SamAccountNames) and clears the Manager attribute for each of those users in Active Directory. This could be used for reorganization, cleaning up stale or incorrect manager assignments, or other administrative tasks related to user attributes.

.NOTES
    Script Name    : RemoveManagerFromADUsers.ps1
    Version        : 0.1
    Author         : [Your Name]
    Approved By    : [Approver's Name]
    Date           : [Date]
    Purpose        : Removes the Manager attribute for specified user accounts in Active Directory.

.PREREQUISITES
    - Active Directory module for PowerShell should be installed.
    - The script must be run with administrative privileges (e.g., domain admin).
    - The input CSV file should be available and contain a list of user account names (SamAccountNames).

.PARAMETERS
    None required for this script. The script operates based on the contents of the input CSV file.

.EXAMPLE
    Example of running the script:

    PS C:\> .\RemoveManagerFromADUsers.ps1

    The CSV file (`C:\Temp\BulkUsersManagerRemoval.csv`) should look like the following:

    | SamAccountName |
    |----------------|
    | user1          |
    | user2          |
    | user3          |

    In this example, the script will remove the Manager attribute for the accounts `user1`, `user2`, and `user3`.

#>

# Start of Script

# Importing CSV file with user accounts
Import-Csv "C:\Temp\BulkUsersManagerRemoval.csv" | 

# Loop through each user account
ForEach-Object {
    $SamAccountName = $_.SamAccountName 

    # Remove Manager attribute for the user
    Set-ADUser -Identity $SamAccountName -Clear Manager

    # Write output to the console
    Write-Host "Manager has been removed for $SamAccountName" -ForegroundColor Cyan
}

# End of Script
