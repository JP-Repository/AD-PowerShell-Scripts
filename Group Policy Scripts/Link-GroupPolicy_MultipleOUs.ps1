<#
.SYNOPSIS
    Links a specified Group Policy Object (GPO) to a list of Organizational Units (OUs) from a text file.

.DESCRIPTION
    This script reads a list of OU Distinguished Names (DNs) from a text file and links the specified GPO to each OU. It checks if the GPO is already linked to the OU and skips it if already linked. The results are logged to a file.

.NOTES
    Script Name    : Link-GPOToOUs.ps1
    Version        : 1.0
    Author         : [Your Name]
    Approved By    : [Approver's Name]
    Date           : [Date]
    Purpose        : To link a GPO to multiple OUs as defined in a text file.

.PREREQUISITES
    - The script requires the Group Policy module.
    - The user running the script must have permission to link GPOs to the specified OUs.
    - A valid text file containing OU Distinguished Names.

.PARAMETERS
    - GPOName (String): The name of the GPO to be linked.
    - OUFilePath (String): The path to the text file containing OU DNs.
    - LogFilePath (String): The path where the log file will be saved.

.EXAMPLE
    .\Link-GPOToOUs.ps1 -GPOName "GPO Name" -OUFilePath "C:\Temp\OUs.txt" -LogFilePath "C:\Temp\LinkingLog.txt"
#>

# Start of Script

param (
    [string]$GPOName = "CABOT GLOBAL - PROD - Citrix Workspace 2402 Client Policy",
    [string]$OUFilePath = "C:\Temp\OUs.txt",
    [string]$LogFilePath = "C:\Temp\GPO_Link_Log_$(Get-Date -Format 'yyyy-MM-dd_HH-mm-ss').txt"
)

# Check if the file exists
if (Test-Path $OUFilePath) {
    # Read OUs from the file
    $OUs = Get-Content -Path $OUFilePath

    # Check if the GPO exists
    $GPO = Get-GPO -Name $GPOName -ErrorAction SilentlyContinue

    if ($GPO) {
        foreach ($OU in $OUs) {
            try {
                # Check if the GPO is already linked to the OU
                $existingLink = Get-GPLink -Target $OU | Where-Object {$_.Name -eq $GPOName}
                
                if ($existingLink) {
                    Add-Content -Path $LogFilePath -Value "GPO '$GPOName' already linked to OU '$OU'. Skipping." 
                } else {
                    # Link the GPO to the OU
                    New-GPLink -Name $GPOName -Target $OU -Enforced No
                    Add-Content -Path $LogFilePath -Value "Successfully linked GPO '$GPOName' to OU '$OU'."
                }
            } catch {
                Add-Content -Path $LogFilePath -Value "Failed to link GPO '$GPOName' to OU '$OU'. Error: $_"
            }
        }
    } else {
        Add-Content -Path $LogFilePath -Value "GPO '$GPOName' does not exist. Please check the GPO name."
    }
} else {
    Add-Content -Path $LogFilePath -Value "The file '$OUFilePath' does not exist. Please provide a valid file path."
}

# End of Script
