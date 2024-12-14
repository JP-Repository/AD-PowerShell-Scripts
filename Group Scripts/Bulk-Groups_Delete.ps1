<#
.SYNOPSIS
    Removes bulk users from specified Active Directory groups based on input from a CSV file.

.DESCRIPTION
    This script reads a CSV file containing the details for groups and users to be removed from those groups. The CSV file must contain columns for `GroupName` and `SamAccountName`. The script will remove users from the specified groups in Active Directory.

.NOTES
    Script Name    : Bulk-Groups_Delete.ps1
    Version        : 0.1
    Created On     : [Date]
    Created By     : [Your Name]
    Approved By    : [Approver's Name]
    Date           : [Date]
    Purpose        : To remove users from Active Directory groups based on CSV input.

.PREREQUISITES
    - The script requires the ActiveDirectory module.
    - The CSV file should be located at `C:\Temp\BulkGroupsDeleteTemplate.csv` and contain the headers `GroupName` and `SamAccountName`.

.PARAMETERS
    - None (CSV file input should be located at `C:\Temp\BulkGroupsDeleteTemplate.csv`).

.EXAMPLE
    .\Bulk-Groups_Delete.ps1
#>

# Start of Script

# Initialize start time for script execution
$StartTime = Get-Date

# Output informational message
Write-Host "EXECUTING SCRIPT TO REMOVE USERS FROM GROUPS" -ForegroundColor Green

# Try to import the Active Directory module
try {
    Import-Module ActiveDirectory
} catch {
    Write-Warning "The Active Directory module was not found. Please ensure it is installed and available."
    exit
}

# Import the CSV file containing the group and user details
$CsvFilePath = "C:\Temp\BulkGroupsDeleteTemplate.csv"
if (Test-Path $CsvFilePath) {
    Write-Host "IMPORTING DATA FROM CSV FILE" -ForegroundColor Cyan
    Import-Csv $CsvFilePath |

    # Loop through each row in the CSV file to remove users from groups
    ForEach-Object {
        $Groups = $_.GroupName
        $SamAccountName = $_.SamAccountName

        # Attempt to remove the user from the group
        try {
            Remove-ADGroupMember -Identity $Groups -Members $SamAccountName -Confirm:$false
            Write-Host "Removed user '$SamAccountName' from group '$Groups'" -ForegroundColor Yellow
        } catch {
            Write-Warning "Failed to remove user '$SamAccountName' from group '$Groups'. Error: $_"
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
