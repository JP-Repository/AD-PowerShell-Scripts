<#
.SYNOPSIS
    This script disables computer accounts in Active Directory and moves them to a specified Organizational Unit (OU) for disabled computers.

.DESCRIPTION
    The script reads a CSV file containing a list of computer names, disables the corresponding computer accounts in Active Directory, and moves them to a designated OU for disabled computers. This helps in managing inactive or retired computers within the Active Directory environment.

.NOTES
    Script Name    : DisableAndMoveComputers.ps1
    Version        : 1.0
    Author         : [Your Name]
    Approved By    : [Approver's Name]
    Date           : [Date]
    Purpose        : Disable computer accounts and move them to the "Disabled Computers" OU for better management and housekeeping.

.PREREQUISITES
    - Active Directory module for PowerShell installed.
    - The script must be run by an account with sufficient privileges to disable computer accounts and move them within AD.
    - Input CSV file with the required computer names (see example below).

.PARAMETERS
    - CsvFilePath [Required] : Path to the CSV file containing a list of computer names.
    - DisabledComputersOU [Required] : Distinguished Name (DN) of the target Organizational Unit where disabled computers will be moved.

.EXAMPLE
    .\DisableAndMoveComputers.ps1

    This will process the computers listed in the CSV file, disable their accounts, and move them to the specified "Disabled Computers" OU.

#>

# Start of Script

# Import the Active Directory module if not already imported
Import-Module ActiveDirectory

# Define the path to the CSV file (adjust this as needed)
$CsvFilePath = "C:\Temp\InactiveComputers.csv"

# Define the target OU for disabled computers (adjust this as needed)
$DisabledComputersOU = "OU=Disabled Computers,DC=yourdomain,DC=com"

# Import the list of computers from the CSV file
$ComputerList = Import-Csv -Path $CsvFilePath

# Check if any computers are in the list
if ($ComputerList.Count -eq 0) {
    Write-Host "No computers found in the CSV file." -ForegroundColor Yellow
    return
}

# Process each computer in the list
foreach ($Computer in $ComputerList) {
    $ComputerName = $Computer.ComputerName  # Replace 'ComputerName' with the correct column header in your CSV

    try {
        # Get the computer object from Active Directory
        $ADComputer = Get-ADComputer -Identity $ComputerName -Properties DistinguishedName, Enabled

        # Check if the account is already disabled
        if ($ADComputer.Enabled -eq $false) {
            Write-Host "$ComputerName is already disabled." -ForegroundColor Green
        } else {
            # Disable the computer account
            Disable-ADAccount -Identity $ADComputer.DistinguishedName
            Write-Host "Disabled: $ComputerName" -ForegroundColor Yellow
        }

        # Move the computer account to the "Disabled Computers" OU
        Move-ADObject -Identity $ADComputer.DistinguishedName -TargetPath $DisabledComputersOU
        Write-Host "Moved: $ComputerName to $DisabledComputersOU" -ForegroundColor Cyan
    } catch {
        Write-Host "Failed to process $ComputerName" -ForegroundColor Red
    }
}

Write-Host "Script completed." -ForegroundColor Green

# End of Script
