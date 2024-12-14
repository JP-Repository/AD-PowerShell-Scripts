<#
.SYNOPSIS
This script checks the manager of each Active Directory group, determines whether the manager account 
is enabled or disabled, and exports the results to a CSV file.

.DESCRIPTION
The script queries all Active Directory groups, retrieves their manager, checks if the manager account 
is enabled or disabled, and includes the group's creation date. The results are then exported to a CSV file 
for further review.

.NOTES
    Script Name    : Get-ADGroupManagerStatus.ps1
    Version        : 1.0
    Author         : [Your Name]
    Approved By    : [Approver's Name]
    Date           : [Date]
    Purpose        : To automate the process of checking AD group managers' account status and export results.

.PREREQUISITES
    - The script requires the Active Directory PowerShell module to be installed.
    - The user running the script must have appropriate permissions to query AD groups and user accounts.

.PARAMETERS
    None

.EXAMPLE
    Get-ADGroupManagerStatus.ps1
    This will check the manager status for all AD groups and export the results to a CSV file.

#>

# Define the output CSV file path
$outputCsvPath = "C:\ADGroupManagerStatus.csv"

# Get all AD groups
$groups = Get-ADGroup -Filter * -Properties Description, ManagedBy, WhenCreated

# Initialize an array to store the results
$results = @()

# Loop through each group
foreach ($group in $groups) {
    # Get the manager of the group (if any)
    $manager = Get-ADUser -Identity $group.ManagedBy -Properties Enabled, SamAccountName | Select-Object Name, Enabled, SamAccountName

    # Check if the manager exists and retrieve the status
    if ($manager) {
        $managerStatus = if ($manager.Enabled) { "Enabled" } else { "Disabled" }
    } else {
        $managerStatus = "No Manager"
        $manager = New-Object PSObject -property @{ Name = "No Manager"; SamAccountName = "None"; Enabled = $false }
    }

    # Create a custom object with the group and manager details
    $groupDetails = New-Object PSObject -property @{
        GroupName        = $group.Name
        GroupDescription = $group.Description
        ManagerName      = $manager.Name
        ManagerAccountState = $managerStatus
        GroupCreatedDate = $group.WhenCreated
    }

    # Add the result to the array
    $results += $groupDetails
}

# Export the results to a CSV file
$results | Export-Csv -Path $outputCsvPath -NoTypeInformation

Write-Host "Export completed. The results have been saved to $outputCsvPath."