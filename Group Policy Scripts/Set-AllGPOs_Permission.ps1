<#
.SYNOPSIS
    Delegates specified permissions to a user or group for all Group Policy Objects (GPOs) in the domain.

.DESCRIPTION
    This script grants specified permission levels to a user or group for all GPOs in the domain. The permissions are defined in the `$PermissionLevels` array and are applied to each GPO found in the domain.

.NOTES
    Script Name    : Delegate-GPOPermissions.ps1
    Version        : 1.0
    Author         : [Your Name]
    Approved By    : [Approver's Name]
    Date           : [Date]
    Purpose        : To delegate permissions to a user or group for all GPOs in the domain.

.PREREQUISITES
    - The script requires the GroupPolicy module.
    - The user running the script must have permission to modify GPO permissions.

.PARAMETERS
    - AccountOrGroup (String): The account or group to which the permissions will be delegated.
    - PermissionLevels (Array): The list of permissions to be delegated (default: GpoRead, GpoEdit, GpoApply).

.EXAMPLE
    .\Delegate-GPOPermissions.ps1 -AccountOrGroup "Domain\YourAccountOrGroup"
#>

# Start of Script

param (
    [string]$AccountOrGroup = "Domain\YourAccountOrGroup",  # Replace with the account or group
    [string[]]$PermissionLevels = @("GpoRead", "GpoEdit", "GpoApply")  # Default permission levels
)

# Get all GPOs in the domain
$GPOs = Get-GPO -All

# Loop through each GPO and set permissions
foreach ($GPO in $GPOs) {
    foreach ($PermissionLevel in $PermissionLevels) {
        try {
            Set-GPPermissions -Name $GPO.DisplayName -TargetName $AccountOrGroup -TargetType Group -PermissionLevel $PermissionLevel
            Write-Host "Successfully delegated '$PermissionLevel' permission to '$AccountOrGroup' for GPO '$($GPO.DisplayName)'" -ForegroundColor Green
        } catch {
            Write-Host "Failed to delegate '$PermissionLevel' permission to '$AccountOrGroup' for GPO '$($GPO.DisplayName)'. Error: $_" -ForegroundColor Red
        }
    }
}

Write-Host "Delegation completed for all GPOs."

# End of Script
