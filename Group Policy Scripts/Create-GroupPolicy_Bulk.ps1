<#
.SYNOPSIS
    This script creates new Group Policy Objects (GPOs) based on a list of GPO names from a CSV file.

.DESCRIPTION
    The script imports a CSV file containing a list of GPO names, checks if each GPO already exists in the domain, and if not, creates the GPO. The script provides feedback on whether each GPO was created or already exists. This is useful for automating the creation of GPOs in bulk from a predefined list.

.NOTES
    Script Name    : Create-GPOsFromCSV.ps1
    Version        : 1.0
    Author         : [Your Name]
    Approved By    : [Approver's Name]
    Date           : [Date]
    Purpose        : To create new GPOs based on a list of names provided in a CSV file.

.PREREQUISITES
    - The script requires PowerShell 5.1 or later.
    - The Group Policy module must be installed.
    - The user running the script must have the necessary permissions to create GPOs.
    - The CSV file must contain a column named `GpoName` with the list of GPO names.

.PARAMETERS
    None.

.EXAMPLE
    PS C:\> .\Create-GPOsFromCSV.ps1
    This will read a CSV file located at "C:\Temp\GPO_List.csv", check for existing GPOs, and create new ones based on the list.

#>

# Start of Script

# Import the GroupPolicy module
Import-Module GroupPolicy

# Path to your CSV file
$csvPath = "C:\Temp\GPO_List.csv"

# Import the CSV file
$gpoList = Import-Csv -Path $csvPath

# Loop through each GPO and create it
foreach ($gpo in $gpoList) {
    $gpoName = $gpo.GpoName

    # Check if the GPO already exists
    $existingGpo = Get-GPO -Name $gpoName -ErrorAction SilentlyContinue

    if (-not $existingGpo) {
        # Create the new GPO
        $newGpo = New-GPO -Name $gpoName
        Write-Host "GPO '$gpoName' created successfully."
    } else {
        Write-Host "GPO '$gpoName' already exists."
    }
}

# End of Script
