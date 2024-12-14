<#
.SYNOPSIS
    Adds bulk users to specified Active Directory groups using a CSV file as input.

.DESCRIPTION
    This script reads a CSV file containing a list of groups and corresponding users, and adds those users to the specified groups. The CSV file should contain two columns: `GroupName` and `SamAccountName`. The script will import the necessary data and add users to the appropriate groups in Active Directory.

.NOTES
    Script Name    : Bulk-Groups_Addition.ps1
    Version        : 0.1
    Created On     : 
    Created By     : Jonathan Preetham
    Approved By    : [Approver's Name]
    Date           : [Date]
    Purpose        : To add users to Active Directory groups based on input from a CSV file.

.PREREQUISITES
    - The script requires the ActiveDirectory module.
    - The CSV file should be located at `C:\Temp\BulkGroupsAdditionTemplate.csv` and contain the headers `GroupName` and `SamAccountName`.

.PARAMETERS
    - None (CSV file input should be located at `C:\Temp\BulkGroupsAdditionTemplate.csv`).

.EXAMPLE
    .\Bulk-Groups_Addition.ps1
#>

# Start of Script

# Initialize start time for script execution
$StartTime = Get-Date

# Output informational message
Write-Host "EXECUTING SCRIPT" -ForegroundColor Green

# Try to import the Active Directory module
try {
    Import-Module ActiveDirectory
} catch {
    Write-Warning "The Active Directory module was not found. Please ensure it is installed and available."
    exit
}

# Output message indicating the script is importing data from CSV
Write-Host "IMPORTING DATA FROM CSV FILE" -ForegroundColor Cyan

# Import the CSV file containing the list of groups and users
$CsvFilePath = "C:\Temp\BulkGroupsAdditionTemplate.csv"
if (Test-Path $CsvFilePath) {
    Import-Csv $CsvFilePath |
    
    # Loop through each row in the CSV file
    ForEach-Object {
        $Groups = $_.GroupName
        $SamAccountName = $_.SamAccountName

        # Add the user to the group
        try {
            Add-ADGroupMember -Identity $Groups -Members $SamAccountName
            Write-Host "Added User '$SamAccountName' to Group '$Groups'" -ForegroundColor Yellow
        } catch {
            Write-Warning "Failed to add user '$SamAccountName' to group '$Groups'. Error: $_"
        }
    }
} else {
    Write-Warning "The specified CSV file '$CsvFilePath' does not exist. Please check the file path."
    exit
}

# Final completion message
Write-Host "SCRIPT HAS COMPLETED" -ForegroundColor Green

# Calculate and display script execution time
$EndTime = Get-Date
$ExecutionTime = New-TimeSpan -Start $StartTime -End $EndTime
Write-Host "Time taken for the script to complete: $($ExecutionTime.ToString())"

# End of Script
