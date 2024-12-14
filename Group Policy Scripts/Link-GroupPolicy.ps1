<#
.SYNOPSIS
    Links a specified GPO to all Organizational Units (OUs) named "Computers" in Active Directory.

.DESCRIPTION
    This script retrieves all Organizational Units (OUs) with the name "Computers" and links the specified GPO to each of them. It ensures that the GPO exists before proceeding with the linking process.

.NOTES
    Script Name    : Link-GPOToComputersOUs.ps1
    Version        : 1.0
    Author         : [Your Name]
    Approved By    : [Approver's Name]
    Date           : [Date]
    Purpose        : To link a specified GPO to all OUs named "Computers".

.PREREQUISITES
    - The script requires the GroupPolicy and ActiveDirectory modules.
    - The user running the script must have permission to link GPOs to the specified OUs.

.PARAMETERS
    - GPOName (String): The name of the GPO to be linked.

.EXAMPLE
    .\Link-GPOToComputersOUs.ps1 -GPOName "Your-GPO-Name"
#>

# Start of Script

param (
    [string]$GPOName = "Your-GPO-Name"  # Replace with your GPO name
)

# Ensure the GPO exists
$GPO = Get-GPO -Name $GPOName -ErrorAction Stop

# Get all OUs named "Computers"
$OUs = Get-ADOrganizationalUnit -Filter 'Name -eq "Computers"'

# Loop through each OU and link the GPO
foreach ($OU in $OUs) {
    Write-Host "Linking GPO '$GPOName' to OU: $($OU.DistinguishedName)"
    try {
        New-GPLink -Name $GPOName -Target $OU.DistinguishedName -LinkEnabled Yes
        Write-Host "Successfully linked GPO '$GPOName' to OU: $($OU.DistinguishedName)" -ForegroundColor Green
    } catch {
        Write-Host "Failed to link GPO '$GPOName' to OU: $($OU.DistinguishedName). Error: $_" -ForegroundColor Red
    }
}

Write-Host "Completed linking GPO: $GPOName to all OUs named 'Computers'"

# End of Script
