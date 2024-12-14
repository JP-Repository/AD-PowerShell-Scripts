<#
.SYNOPSIS
    This script retrieves and exports information about Group Policy Objects (GPOs) in the environment, including their links, enabled statuses for computer and user, and associated WMI filters.

.DESCRIPTION
    This script uses PowerShell cmdlets to gather data on all GPOs in the Active Directory environment. For each GPO, it generates an XML report and extracts the following details:
    - GPO Name
    - Link Path (the scope where the GPO is linked)
    - Computer-enabled status
    - User-enabled status
    - WMI Filter (if applicable)
    The results are exported to a CSV file for later analysis or reporting.

.NOTES
    Script Name    : Get-AllGPOs_WithLinks.ps1
    Version        : 1.0
    Author         : [Your Name]
    Approved By    : [Approver's Name]
    Date           : [Date]
    Purpose        : Retrieve and export GPO details to a CSV file.

.PREREQUISITES
    - Active Directory PowerShell module installed.
    - The user running the script must have permissions to read GPO details in Active Directory.
    - Input CSV file with the required details (optional if parameters are used).

.PARAMETERS
    [Optional] - InputFile (Path to input CSV with GPO details, if required by the script).
    [Optional] - OutputFile (Path to the CSV file where results will be saved. Default: C:\Temp\All_GPOList_WithLinks.csv).

.EXAMPLE
    # Example 1: Run the script without any parameters.
    .\Get-AllGPOs_WithLinks.ps1

    # Example 2: Run the script with a custom output file path.
    .\Get-AllGPOs_WithLinks.ps1 -OutputFile "D:\Reports\GPOReport.csv"

#>

# Start of Script

# Define parameters if needed
param (
    [string]$InputFile = "",      # Optional input file path
    [string]$OutputFile = "C:\Temp\All_GPOList_WithLinks.csv"  # Default output file path
)

# Check for the existence of the output file and remove it if it exists
if (Test-Path $OutputFile) {
    Remove-Item $OutputFile
}

# Write header to CSV file
"Name;LinkPath;ComputerEnabled;UserEnabled;WmiFilter" | Out-File $OutputFile

# Retrieve all GPOs from the environment
$GPOs = Get-GPO -All

# Process each GPO and export details
$GPOs | ForEach-Object {
    [xml]$Report = $_ | Get-GPOReport -ReportType XML
    $Links = $Report.GPO.LinksTo

    # Loop through each link (scope) of the GPO
    foreach ($Link in $Links) {
        $WmiFilter = if ($_.WmiFilter) { $_.WmiFilter.Name } else { "None" }

        # Format the output string for the CSV
        $Output = $Report.GPO.Name + ";" + $Link.SOMPath + ";" + $Report.GPO.Computer.Enabled + ";" + $Report.GPO.User.Enabled + ";" + $WmiFilter
        
        # Append the output to the CSV file
        $Output | Out-File $OutputFile -Append
    }
}

# End of Script
