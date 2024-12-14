<#
.SYNOPSIS
    This script updates the security filtering of a specified GPO by adding computer accounts from a given list.

.DESCRIPTION
    The script reads a list of computer names from a file, checks whether each computer account exists in Active Directory, 
    and adds the valid computer accounts to the security filtering of a specified Group Policy Object (GPO). 
    The script ensures that the computers have 'Read' and 'Apply Group Policy' permissions on the GPO. 
    This operation is useful for managing which computers a GPO applies to, particularly in environments like WSUS or other group policies tied to specific machine accounts.

.NOTES
    Script Name    : Update-GPOSecurityFiltering.ps1
    Version        : 1.0
    Author         : [Your Name]
    Approved By    : [Approver's Name]
    Date           : [Date]
    Purpose        : To update the security filtering of a GPO by adding specified computer accounts.

.PREREQUISITES
    - The script requires PowerShell 5.1 or later.
    - The Active Directory PowerShell module must be installed.
    - The Group Policy Management module must be installed.
    - Input file should be a plain text file (.txt) with each line containing a computer name.
    - The specified GPO must already exist in the environment.

.PARAMETERS
    $GPOName (string)
        - The name of the GPO to be updated. Default is "Group Policy Name".
    
    $ComputerListPath (string)
        - The path to the text file that contains the list of computer names to be added to the GPO's security filtering. Default is "C:\Temp\computers.txt".

.EXAMPLE
    PS C:\> .\Update-GPOSecurityFiltering.ps1
    This will update the security filtering for the GPO "Group Policy Name" using the computer names listed in "C:\Temp\computers.txt".

    PS C:\> .\Update-GPOSecurityFiltering.ps1 -GPOName "MyGPO" -ComputerListPath "D:\ComputerList.txt"
    This will update the security filtering for the GPO "MyGPO" using the computer names listed in "D:\ComputerList.txt".

#>

# Start of Script

# Define variables
$GPOName = "Group Policy Name" # Replace with your GPO name
$ComputerListPath = "C:\Temp\Computers.txt" # Replace with the path to your computer list file

# Import the computer names from the file
$ComputerNames = Get-Content -Path $ComputerListPath

# Ensure the GPO exists
$GPO = Get-GPO -Name $GPOName -ErrorAction Stop

# Get the GPO's security descriptor
$GPOAcl = Get-GPPermissions -Name $GPOName -All

# Loop through each computer and add to security filtering
foreach ($ComputerName in $ComputerNames) {
    # Check if the computer account exists in AD
    $Computer = Get-ADComputer -Identity $ComputerName -ErrorAction SilentlyContinue
    if ($Computer) {
        Write-Host "Adding $ComputerName to security filtering..."

        # Add the computer account to the GPO with 'Read' and 'Apply Group Policy' permissions
        Set-GPPermissions -Name $GPOName -TargetName $ComputerName -TargetType Computer -PermissionLevel GpoApply
    } else {
        Write-Warning "$ComputerName not found in Active Directory. Skipping."
    }
}

Write-Host "Completed updating security filtering for GPO: $GPOName"

# End of Script
