<#
.SYNOPSIS
    This script identifies and backs up unlinked Group Policy Objects (GPOs) and generates HTML reports for each.

.DESCRIPTION
    The script searches for all Group Policy Objects (GPOs) in the domain, filters those that are not linked to any Active Directory container (OU, site, or domain), and performs the following actions for each unlinked GPO:
    - Backs up the GPO to a specified directory.
    - Generates an HTML report of the GPO's settings.
    - Logs the name of the unlinked GPO to a CSV file for record-keeping.
    - Optionally, it can remove the unlinked GPOs (this step is currently commented out).
    The backups and reports are stored in a directory named with the current date, ensuring easy identification of when the operation was performed.

.NOTES
    Script Name    : Backup-UnlinkedGPOs.ps1
    Version        : 1.0
    Author         : [Your Name]
    Approved By    : [Approver's Name]
    Date           : [Date]
    Purpose        : To identify unlinked GPOs, back them up, generate reports, and log the details.

.PREREQUISITES
    - The script requires PowerShell 5.1 or later.
    - The Group Policy module must be installed.
    - Sufficient permissions to read GPOs and perform backups.
    - The user running the script must have the necessary permissions to delete GPOs if required.
    - The script assumes a "c:\temp" directory exists or is created during execution.

.PARAMETERS
    None.

.EXAMPLE
    PS C:\> .\Backup-UnlinkedGPOs.ps1
    This will identify all unlinked GPOs, back them up, generate HTML reports, and log the results in a CSV file in "c:\temp".

#>

# Start of Script

Import-Module GroupPolicy
$Date = Get-Date -Format dd_MM_yyyy
$BackupPath = "C:\Temp\Unlinked_GroupPolicy_Objects_$Date"

# Ensure the backup directory exists
if (-Not(Test-Path -Path $BackupPath)) 
{ 
    New-Item -ItemType Directory $BackupPath -Force
}

# Loop through all GPOs, check for unlinked ones, and perform actions
Get-GPO -All | Sort-Object displayname | Where-Object { 
    If ( $_ | Get-GPOReport -ReportType XML | Select-String -NotMatch "<LinksTo>" )
    {
        # Backup the unlinked GPO
        Backup-GPO -Name $_.DisplayName -Path $BackupPath

        # Generate an HTML report for the GPO
        Get-GPOReport -Name $_.DisplayName -ReportType Html -Path "c:\temp\Unlinked_GroupPolicy_Objects_$Date\$($_.DisplayName).html"

        # Log the name of the unlinked GPO in a CSV file
        $_.DisplayName | Out-File "c:\temp\Unlinked_GroupPolicy_Objects_$Date\UnLinkedGPOs.csv" -Append

        # Optionally, remove the GPO (currently commented out)
        # $_.Displayname | remove-gpo -Confirm
    }
}

# End of Script
