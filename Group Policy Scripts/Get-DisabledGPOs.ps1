<#
.SYNOPSIS
    This script retrieves all disabled Group Policy Objects (GPOs) in the environment and exports their details to a CSV file.

.DESCRIPTION
    This PowerShell script queries all GPOs in the environment using `Get-GPO -All` and filters for those that have the status "AllSettingsDisabled".
    The script then exports information about these GPOs to a CSV file. The file includes the GPO name, creation time, modification time, and status.
    The output file is named based on the current date for easy identification.

.NOTES
    Script Name    : Export-DisabledGPOs.ps1
    Version        : 1.0
    Author         : [Your Name]
    Approved By    : [Approver's Name]
    Date           : [Date]
    Purpose        : To export details of disabled GPOs to a CSV file for reporting or analysis.

.PREREQUISITES
    - The script requires the Active Directory and Group Policy modules.
    - The user running the script must have permissions to query GPO details and write to the specified output folder.
    - The script assumes that the "C:\Temp" folder exists. If it doesn't, the script will create it.

.PARAMETERS
    [Optional] - OutputFile (Path where the CSV file will be saved. Default: "C:\Temp\Disabled_GPO_<Date>.csv").

.EXAMPLE
    # Example 1: Run the script without any parameters, it will save the CSV to C:\Temp\Disabled_GPO_<date>.csv
    .\Export-DisabledGPOs.ps1

    # Example 2: Run the script with a custom output file path
    .\Export-DisabledGPOs.ps1 -OutputFile "D:\Reports\Disabled_GPO_$(get-date -f yyyy-MM-dd).csv"
#>

# Start of Script

# Importing required modules
Import-Module ActiveDirectory
Import-Module GroupPolicy

# Define the output directory and ensure it exists
$OutputDir = "C:\Temp"
if (-not (Test-Path $OutputDir)) {
    New-Item -ItemType Directory -Path $OutputDir
}

# Define the output file name with current date
$Date = Get-Date -Format "yyyy-MM-dd"
$OutputFile = if ($PSCmdlet.MyInvocation.BoundParameters["OutputFile"]) {
    $OutputFile
} else {
    "$OutputDir\Disabled_GPO_$Date.csv"
}

# Export disabled GPOs to CSV with error handling
try {
    # Query all GPOs and filter for those that are disabled
    Get-GPO -All |
        Where-Object {$_.GPOStatus -eq "AllSettingsDisabled"} | # Filter for disabled GPOs
        Sort-Object Name | # Sort by the GPO name
        Select-Object DisplayName, CreationTime, ModificationTime, GPOStatus | # Select relevant properties
        Export-Csv -Path $OutputFile -NoTypeInformation -Force # Export to CSV with no type information

    Write-Host "Export completed successfully: $OutputFile"
} catch {
    Write-Error "An error occurred while exporting disabled GPOs: $_"
}

# End of Script
