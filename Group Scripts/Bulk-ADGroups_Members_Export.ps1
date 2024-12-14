<#
.SYNOPSIS
    Exports the list of members from multiple Active Directory groups specified in a text file.

.DESCRIPTION
    This script reads group names from a text file (`ListofGroups.txt`), retrieves all members of those groups, and exports the user attributes such as `Name`, `SamAccountName`, `Enabled`, `GroupName`, and `Description` to a CSV file (`GroupMemberShip.csv`). The script handles multiple groups and includes the group description as an additional attribute.

.NOTES
    Script Name    : Bulk-ADGroups_Members_Export.ps1
    Version        : 0.1
    Created On     : 
    Created By     : Pugazhendhi Devarasu
    Modified By    : Jonathan Preetham
    Approved By    : [Approver's Name]
    Date           : [Date]
    Purpose        : To export members of multiple AD groups to a CSV file with selected attributes.

.PREREQUISITES
    - The script requires the ActiveDirectory module.
    - The text file `ListofGroups.txt` must contain one AD group name per line.
    - Ensure the script is executed with appropriate permissions to read group memberships.

.PARAMETERS
    - None (Group names are read from the `C:\ListofGroups.txt` file).

.EXAMPLE
    .\Bulk-ADGroups_Members_Export.ps1
#>

# Start of Script

# Writing informational messages to Host
Write-Host " "
Write-Host "INFORMATION - PLEASE READ" -ForegroundColor Red
Write-Host "The script will take some time to complete depending on the number of groups mentioned in the text file" -ForegroundColor Cyan

# Import the ActiveDirectory module
Import-Module ActiveDirectory

# Get AD groups from the ListofGroups.txt file (ensure the file exists)
$Groups = Get-Content C:\ListofGroups.txt

# Loop through each group in the text file and retrieve user details
$Results = ForEach ($Group in $Groups) {
    
    # Get group members and user details, including group name and description
    Get-ADGroupMember $Group -Recursive | Get-ADUser -Properties * | Select-Object Name, samAccountName, Enabled, 
    @{n='GroupName'; e={$Group}}, 
    @{n='Description'; e={(Get-ADGroup $Group -Properties Description).Description}}
}

# Export the results to a CSV file
$Results | Export-Csv C:\GroupMemberShip.csv -NoTypeInformation

# Display a completion message in a popup dialog box
$wshell = New-Object -ComObject Wscript.Shell
$wshell.Popup("Script completed successfully. Output file saved under C:\GroupMemberShip.csv")

# End of Script
