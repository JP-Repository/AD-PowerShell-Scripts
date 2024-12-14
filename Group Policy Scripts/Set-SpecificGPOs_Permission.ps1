<#
.SYNOPSIS
    Delegates specified permissions to a user or group for selected GPOs in the domain.

.DESCRIPTION
    This script grants specified permission levels to a user or group for specific GPOs in the domain. It ensures that the selected GPOs exist before applying the permissions.

.NOTES
    Script Name    : Delegate-SpecificGPOPermissions.ps1
    Version        : 1.0
    Author         : [Your Name]
    Approved By    : [Approver's Name]
    Date           : [Date]
    Purpose        : To delegate permissions to a user or group for selected GPOs in the domain.

.PREREQUISITES
    - The script requires the GroupPolicy module.
    - The user running the script must have permission to modify GPO permissions.

.PARAMETERS
    - AccountOrGroup (String): The account or group to which the permissions will be delegated.
    - GPOsToModify (Array): The list of GPO names to modify.
    - PermissionLevels (Array): The list of permissions to be delegated (default: GpoRead, GpoEdit, GpoApply).

.EXAMPLE
    .\Delegate-SpecificGPOPermissions.ps1 -AccountOrGroup "Domain\YourAccountOrGroup" -GPOsToModify @("GPO1", "GPO2", "GPO3")
#>

# Start of Script

param (
    [string]$AccountOrGroup = "Domain\YourAccountOrGroup",  # Replace with the account or group
    [string[]]$GPOsToModify = @("GPO1", "GPO2", "GPO3"),  # Replace with the GPO names to modify
    [string[]]$PermissionLevels = @("GpoRead", "GpoEdit", "GpoApply")  # Default permission levels
)

# Loop through each specified GPO and set permissions
foreach ($GPOName in $GPOsToModify) {
    $GPO = Get-GPO -Name $GPOName -ErrorAction SilentlyContinue
    if ($GPO) {
        foreach ($PermissionLevel in $PermissionLevels) {
            try {
                Set-GPPermissions -Name $GPO.DisplayName -TargetName $AccountOrGroup -TargetType Group -PermissionLevel $PermissionLevel
                Write-Host "Successfully delegated '$PermissionLevel' permission to '$AccountOrGroup' for GPO '$GPOName'" -ForegroundColor Green
            } catch {
                Write-Host "Failed to delegate '$PermissionLevel' permission to '$AccountOrGroup' for GPO '$GPOName'. Error: $_" -ForegroundColor Red
            }
        }
    } else {
        Write-Host "GPO '$GPOName' not found." -ForegroundColor Yellow
    }
}

Write-Host "Delegation completed for specified GPOs."

# End of Script
