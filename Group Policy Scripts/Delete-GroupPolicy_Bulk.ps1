<#
.SYNOPSIS
    This script deletes Group Policy Objects (GPOs) based on a list of GPO names provided in a CSV file.

.DESCRIPTION
    The script imports a CSV file containing a list of GPO names, checks if each GPO exists, and deletes those that are found. If the GPO does not exist, a message is displayed to inform the user. This script automates the process of cleaning up unnecessary or obsolete GPOs from the domain.

.NOTES
    Script Name    : Delete-GPOsFromCSV.ps1
    Version        : 1.0
    Author         : [Your Name]
    Approved By    : [Approver's Name]
    Date           : [Date]
    Purpose        : To delete GPOs from a list provided in a CSV file.

.PREREQUISITES
    - The script requires PowerShell 5.1 or later.
    - The Group Policy module must be installed.
    - The user running the script must have the necessary permissions to delete GPOs.
    - The CSV file must contain a column named `GpoName` with the list of GPO names.

.PARAMETERS
    None.

.EXAMPLE
    PS C:\> .\Delete-GPOsFromCSV.ps1
    This will read a CSV file located at "C:\Temp\GPO_To_Delete.csv", check for existing GPOs, and delete those that exist.

#>

# Start of Script

# Import the GroupPolicy module
Import-Module GroupPolicy

# Path to your CSV file
$csvPath = "C:\Temp\GPO_To_Delete.csv"

# Import the CSV file
$gpoList = Import-Csv -Path $csvPath

# Loop through each GPO in the list
foreach ($gpo in $gpoList) {
    # If you are using GpoName in the CSV
    $gpoName = $gpo.GpoName

    # Check if the GPO exists
    $existingGpo = Get-GPO -Name $gpoName -ErrorAction SilentlyContinue

    if ($existingGpo) {
        # Delete the GPO
        Remove-GPO -Name $gpoName -Confirm:$false
        Write-Host "GPO '$gpoName' deleted successfully."
    } else {
        Write-Host "GPO '$gpoName' not found."
    }
}

# End of Script
