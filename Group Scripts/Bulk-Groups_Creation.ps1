<#
.SYNOPSIS
    Creates bulk Active Directory groups based on input from a CSV file.

.DESCRIPTION
    This script reads a CSV file containing the details for groups to be created. The CSV file must contain columns for `GroupName`, `DisplayName`, `Description`, and `OUPath` (the Organizational Unit where the group will be created). The script will create security groups with the specified details in Active Directory.

.NOTES
    Script Name    : Bulk-Groups_Creation.ps1
    Version        : 0.1
    Created On     : [Date]
    Created By     : Jonathan Preetham
    Approved By    : [Approver's Name]
    Date           : [Date]
    Purpose        : To create multiple groups in Active Directory based on CSV input.

.PREREQUISITES
    - The script requires the ActiveDirectory module.
    - The CSV file should be located at `C:\Temp\BulkGroupCreationTemplate.csv` and contain the headers `GroupName`, `DisplayName`, `Description`, and `OUPath`.

.PARAMETERS
    - None (CSV file input should be located at `C:\Temp\BulkGroupCreationTemplate.csv`).

.EXAMPLE
    .\Bulk-Groups_Creation.ps1
#>

# Start of Script

# Output informational message
Write-Host "EXECUTING SCRIPT TO CREATE BULK GROUPS" -ForegroundColor Green

# Import the Active Directory module
try {
    Import-Module ActiveDirectory
} catch {
    Write-Warning "The Active Directory module was not found. Please ensure it is installed and available."
    exit
}

# Import the CSV file containing the group details
$CsvFilePath = "C:\Temp\BulkGroupCreationTemplate.csv"
if (Test-Path $CsvFilePath) {
    Write-Host "IMPORTING DATA FROM CSV FILE" -ForegroundColor Cyan
    Import-Csv $CsvFilePath |

    # Loop through each row in the CSV file to create groups
    ForEach-Object {
        $GroupName = $_.GroupName
        $DisplayName = $_.DisplayName
        $Description = $_.Description
        $Path = $_.OUPath

        # Attempt to create the new group
        try {
            New-ADGroup -Name $GroupName -GroupCategory Security -GroupScope Global -Description $Description -DisplayName $DisplayName -Path $Path
            Write-Host "New Group '$GroupName' has been created successfully." -ForegroundColor Cyan
        } catch {
            Write-Warning "Failed to create group '$GroupName'. Error: $_"
        }
    }
} else {
    Write-Warning "The specified CSV file '$CsvFilePath' does not exist. Please check the file path."
    exit
}

# Completion message
Write-Host "SCRIPT HAS COMPLETED" -ForegroundColor Green

# End of Script
