<#
.SYNOPSIS
    Enables user accounts in Active Directory and moves them to their respective Organizational Units (OUs) based on input from a CSV file.

.DESCRIPTION
    This script reads a CSV file containing a list of user accounts (SamAccountNames) and performs two key actions for each user:
    1. Enables the user account in Active Directory.
    2. Moves the user account to a specified Organizational Unit (OU) as defined in the CSV file.

    The script is useful for automating the reactivation and reorganization of user accounts, especially after an account has been temporarily disabled or needs to be moved to a different OU for further management.

.NOTES
    Script Name    : EnableAndMoveADUsers.ps1
    Version        : 0.1
    Author         : [Your Name]
    Approved By    : [Approver's Name]
    Date           : [Date]
    Purpose        : Automates the enabling and relocation of user accounts in Active Directory.

.PREREQUISITES
    - Active Directory module for PowerShell should be installed.
    - The script must be run with administrative privileges (e.g., as a domain admin).
    - The input CSV file must be available and contain a list of user account names (SamAccountNames) and target Organizational Units (TargetOU).
    - The Organizational Units (OUs) listed in the CSV file must already exist in Active Directory.

.PARAMETERS
    None required for this script. The script operates based on the contents of the input CSV file.

.EXAMPLE
    Example of running the script with the required CSV file:

    PS C:\> .\EnableAndMoveADUsers.ps1

    The CSV file (`C:\Temp\BulkUsersEnableTemplate.csv`) should look like the following:

    | SamAccountName | TargetOU                                      |
    |----------------|-----------------------------------------------|
    | user1          | OU=ActiveUsers,DC=europe,DC=EASYJET,DC=LOCAL  |
    | user2          | OU=ActiveUsers,DC=europe,DC=EASYJET,DC=LOCAL  |
    | user3          | OU=ActiveUsers,DC=europe,DC=EASYJET,DC=LOCAL  |

    In this example, the script will enable and move the accounts `user1`, `user2`, and `user3` to their respective target OUs as specified in the CSV file.
#>

# Start of Script

#'Importing ActiveDirectory Module
Import-Module ActiveDirectory

#'Imports AD Users Details From .CSV File & Assigns It To Variable
$Imported = Import-Csv -Path "C:\Temp\BulkUsersEnableTemplate.csv"

#'Writing Host
Write-Host "Data Imported" -ForegroundColor Cyan

#'Simple ForEach-Object Command To Read The Data From The CSV File
$Imported | ForEach-Object {
    $SamAccountName = $_.SamAccountName

    #'One Line Command To Enable User Accounts Mentioned In .CSV File
    Enable-ADAccount -Identity $SamAccountName

    #'Retrieve DN Of User
    $UserDN = (Get-ADUser -Identity $_.SamAccountName).DistinguishedName

    #'Retrieve Data From .CSV File & Move Enabled Accounts To Target OU Present In .CSV File
    $TargetOU = $_.TargetOU

    #'Writing Host
    Write-Host "Started Moving Accounts ....." -ForegroundColor Green

    #'One Line Command To Move User Accounts Mentioned In .CSV File To Their Respective OU
    Move-ADObject -Identity $UserDN -TargetPath $TargetOU
}

#'Writing Host
Write-Host "Completed AD User's Enablement & OU-Movement" -ForegroundColor Green

#'Simple Command To Know The Count
$Total = ($Imported).Count

#'Writing Host
Write-Host $Total "User Accounts Are Enabled & Moved Successfully" -ForegroundColor Cyan

# End of Script
