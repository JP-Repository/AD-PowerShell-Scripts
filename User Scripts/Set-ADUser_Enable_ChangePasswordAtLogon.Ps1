<#
.SYNOPSIS
    Enables the "Change password at next logon" option for user accounts in Active Directory based on input from a CSV file.

.DESCRIPTION
    This script reads a CSV file containing a list of user accounts (SamAccountNames) and sets the **ChangePasswordAtLogon** property to `True` for each of those users. This can be useful after a password reset, account reactivation, or other scenarios where the user is required to change their password when they log in.

.NOTES
    Script Name    : EnablePasswordChangeAtLogon.ps1
    Version        : 0.1
    Author         : [Your Name]
    Approved By    : [Approver's Name]
    Date           : [Date]
    Purpose        : Enables the "Change Password at Next Logon" flag for specified user accounts in Active Directory.

.PREREQUISITES
    - Active Directory module for PowerShell should be installed.
    - The script must be run with administrative privileges (e.g., domain admin).
    - The input CSV file should be available and contain a list of user account names (SamAccountNames).

.PARAMETERS
    None required for this script. The script operates based on the contents of the input CSV file.

.EXAMPLE
    Example of running the script:

    PS C:\> .\EnablePasswordChangeAtLogon.ps1

    The CSV file (`C:\Temp\Users.csv`) should look like the following:

    | samAccountName |
    |----------------|
    | user1          |
    | user2          |
    | user3          |

    In this example, the script will enable the "Change Password at Next Logon" option for the accounts `user1`, `user2`, and `user3`.

#>

# Start of Script

# Importing Active Directory module
Import-Module ActiveDirectory

# Import CSV file with user accounts and iterate through each user
Import-Csv "C:\Temp\Users.csv" | ForEach-Object {
    $samAccountName = $_."samAccountName"

    # Set ChangePasswordAtLogon to True for the user
    Get-ADUser -Identity $samAccountName | Set-ADUser -ChangePasswordAtLogon:$True
}

# End of Script
