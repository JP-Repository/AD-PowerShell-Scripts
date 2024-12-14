<#
.SYNOPSIS
This script checks for empty Active Directory groups (groups without members) and exports the details to a CSV file.

.DESCRIPTION
The script queries all Active Directory groups, checks if they have any members, and if not, retrieves 
the group's name, description, creation date, manager, and manager's account status. The results are then 
exported to a CSV file.

.NOTES
    Script Name    : Get-EmptyADGroups.ps1
    Version        : 1.0
    Author         : [Your Name]
    Approved By    : [Approver's Name]
    Date           : [Date]
    Purpose        : To automate the process of identifying empty AD groups and exporting relevant details.

.PREREQUISITES
    - The script requires the Active Directory PowerShell module to be installed.
    - The user running the script must have appropriate permissions to query AD groups and user accounts.

.PARAMETERS
    None

.EXAMPLE
    Get-EmptyADGroups.ps1
    This will check for empty AD groups and export the results to a CSV file.

#>

# Define the output CSV file path
$outputCsvPath = "C:\EmptyADGroups.csv"

# Get all AD groups
$groups = Get-ADGroup -Filter * -Properties Description, ManagedBy, WhenCreated

# Initialize an array to store the results
$results = @()

# Loop through each group
foreach ($group in $groups) {
    # Get the members of the group
    $groupMembers = Get-ADGroupMember -Identity $group -Recursive

    # Check if the group has no members
    if ($groupMembers.Count -eq 0) {
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
}

# Export the results to a CSV file
$results | Export-Csv -Path $outputCsvPath -NoTypeInformation

Write-Host "Export completed. The results have been saved to $outputCsvPath."