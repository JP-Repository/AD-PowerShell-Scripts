<#
.SYNOPSIS
    Updates the Manager attribute for user accounts in Active Directory based on input from a CSV file.

.DESCRIPTION
    This script reads a CSV file containing a list of user accounts (SamAccountNames) and their respective new managers. The **Manager** attribute for each user is updated to the new manager provided in the CSV file. This is useful for organizational changes or when users are reassigned to a new manager.

.NOTES
    Script Name    : BulkUpdateManager.ps1
    Version        : 0.1
    Author         : [Your Name]
    Approved By    : [Approver's Name]
    Date           : [Date]
    Purpose        : Updates the Manager attribute for specified user accounts in Active Directory.

.PREREQUISITES
    - Active Directory module for PowerShell should be installed.
    - The script must be run with administrative privileges (e.g., domain admin).
    - The input CSV file should be available and contain a list of user account names (SamAccountNames) and their corresponding manager names.

.PARAMETERS
    None required for this script. The script operates based on the contents of the input CSV file.

.EXAMPLE§




    Example of running the script:

    PS C:\> .\BulkUpdateManager.ps1

    The CSV file (`C:\Temp\BulkUsersManagerUpdate.csv`) should look like the following:

    | SamAccountName | Manager      |
    |----------------|--------------|
    | user1          | manager1     |
    | user2          | manager2     |
    | user3          | manager3     |

    In this example, the script will update the **Manager** attribute for `user1`, `user2`, and `user3` to `manager1`, `manager2`, and `manager3` respectively.

#>

# Start of Script

# Importing the CSV file with user accounts and managers
Import-Csv "C:\Temp\BulkUsersManagerUpdate.csv" | 

# Loop through each user and update their manager
ForEach-Object {
    $SamAccountName = $_.SamAccountName 
    $Manager = $_.Manager 

    # Get the Distinguished Name (DN) of the new manager
    $ManagerDN = Get-ADUser $Manager -Properties * | Select-Object DistinguishedName
    $ManagerName = Get-ADUser $Manager -Properties * | Select-Object DisplayName

    # Update the Manager attribute for the user
    Set-ADUser -Identity $SamAccountName -Manager $ManagerDN

    # Output result to the console
    Write-Host "For user $SamAccountName manager $ManagerName has been updated" -ForegroundColor Cyan
}

# End of Script
