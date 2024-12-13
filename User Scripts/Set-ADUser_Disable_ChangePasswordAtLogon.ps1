<#
.SYNOPSIS
    Disables the "Change password at next logon" option for user accounts in Active Directory based on input from a CSV file.

.DESCRIPTION
    This script reads a CSV file containing a list of user accounts (SamAccountNames) and sets the **ChangePasswordAtLogon** property to `False` for each of those accounts. This is useful when administrators want to disable the prompt for users to change their password upon their next login, for example, after a password reset or when enabling accounts after a period of inactivity.

.NOTES
    Script Name    : DisablePasswordChangeAtLogon.ps1
    Version        : 0.1
    Author         : [Your Name]
    Approved By    : [Approver's Name]
    Date           : [Date]
    Purpose        : Disables the "Change Password at Next Logon" flag for specified user accounts in Active Directory.

.PREREQUISITES
    - Active Directory module for PowerShell should be installed.
    - The script must be run with administrative privileges (e.g., domain admin).
    - The input CSV file should be available and contain a list of user account names (SamAccountNames).

.PARAMETERS
    None required for this script. The script operates based on the contents of the input CSV file.

.EXAMPLE
    Example of running the script:

    PS C:\> .\DisablePasswordChangeAtLogon.ps1

    The CSV file (`C:\Temp\Users.csv`) should look like the following:

    | samAccountName |
    |----------------|
    | user1          |
    | user2          |
    | user3          |

    In this example, the script will disable the "Change Password at Next Logon" option for the accounts `user1`, `user2`, and `user3`.

#>

# Start of Script

# Importing Active Directory module
Import-Module ActiveDirectory

# Import CSV file with user accounts and iterate through each user
Import-Csv "C:\Temp\Users.csv" | ForEach-Object {
    $samAccountName = $_."samAccountName"

    # Set ChangePasswordAtLogon to False for the user
    Get-ADUser -Identity $samAccountName | Set-ADUser -ChangePasswordAtLogon:$False
}

# End of Script
