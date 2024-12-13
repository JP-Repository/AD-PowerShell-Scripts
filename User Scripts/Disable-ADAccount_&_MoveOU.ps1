<#
.SYNOPSIS
    Disables user accounts in Active Directory and moves them to a specified Organizational Unit (OU) based on input from a CSV file.

.DESCRIPTION
    This script reads a CSV file containing a list of user accounts (SamAccountNames) and performs two key actions for each user:
    1. Disables the user account.
    2. Moves the user account to a specific target Organizational Unit (OU) within Active Directory.
    
    It is designed to automate the process of managing inactive or stale accounts by disabling and relocating them to a designated OU for further review or archiving.

.NOTES
    Script Name    : DisableAndMoveADUsers.ps1
    Version        : 0.1
    Author         : [Your Name]
    Approved By    : [Approver's Name]
    Date           : [Date]
    Purpose        : Automates the disabling and relocation of inactive or stale user accounts in Active Directory.

.PREREQUISITES
    - Active Directory module for PowerShell should be installed.
    - The script must be run with administrative privileges (e.g., as a domain admin).
    - The input CSV file must be available and contain a list of user account names (SamAccountNames).
    - Target Organizational Unit (OU) for moving the users should exist in Active Directory.

.PARAMETERS
    None required for this script. The script operates based on the contents of the input CSV file.

.EXAMPLE
    Example of running the script with the required CSV file:
    
    PS C:\> .\DisableAndMoveADUsers.ps1

    The CSV file (`C:\Temp\BulkUsersDisableTemplate.csv`) should look like the following:
    
    | SamAccountName   |
    |------------------|
    | user1            |
    | user2            |
    | user3            |

    In this example, the script will disable and move the accounts `user1`, `user2`, and `user3` to the specified target OU.
#>

# Start of Script

#'Importing ActiveDirectory Module
Import-Module ActiveDirectory

#'Writing Host
Write-Host "IMPORTING DATA FROM CSV FILE" -ForegroundColor Cyan

#'Defining Target OU Path To Move The User Accounts
$TargetOU = "OU=Not logged into AD or FTP 90,OU=Stale Users,DC=europe,DC=EASYJET,DC=LOCAL"

#'Imports AD Users Details From .CSV File
Import-Csv "C:\Temp\BulkUsersDisableTemplate.csv" |

#'Simple ForEach-Object Command To Read The Data From The CSV File
ForEach-Object {
    $SamAccountName = $_.SamAccountName

    #'One Line Command To Disable User Accounts Mentioned In .CSV File
    Disable-ADAccount -Identity $SamAccountName

    #'One Line Command To Move User Accounts To Another OU
    Get-ADUser $SamAccountName | Move-ADObject -TargetPath $TargetOU

    #'Writing Host
    Write-Host "User Account $SamAccountName Has Been Disabled & Moved To $TargetOU" -ForegroundColor Yellow
}

#'Writing Host
Write-Host "SCRIPT HAS COMPLETED" -ForegroundColor Green

# End of Script
