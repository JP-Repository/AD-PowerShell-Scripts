<#
.SYNOPSIS
    Checks for Active Directory user account lockout events on the PDC emulator.

.DESCRIPTION
    This script prompts the user to enter a specific username and then queries the PDC emulator 
    for any lockout events (Event ID 4740) related to that user within the past 365 days.

.NOTES
    Script Name    : Get-UserLockoutEvents.ps1
    Version        : 1.0
    Author         : Jonathan Preetham
    Approved By    : [Approver's Name]
    Date           : [Date]
    Purpose        : To identify the source and details of account lockout events for a specified user.

.PREREQUISITES
    - ActiveDirectory module must be available.
    - Run with appropriate permissions to query event logs on the domain controller.
    - The script must be run from a domain-joined system with network access to the PDC emulator.

.PARAMETERS
    None. The script will prompt for the username interactively.

.EXAMPLE
    .\Get-UserLockoutEvents.ps1
    (Then enter the username when prompted)

#>

# Start of Script

# Prompting the user for the username to check
$specificUser = Read-Host "Enter the username to check for lockout events"

# Getting the PDC emulator DC
$pdc = (Get-ADDomain).PDCEmulator

# Creating filter criteria for events
$filterHash = @{
    LogName   = "Security"
    Id        = 4740
    StartTime = (Get-Date).AddDays(-365)
}

# Getting lockout events from the PDC emulator
$lockoutEvents = Get-WinEvent -ComputerName $pdc -FilterHashTable $filterHash -ErrorAction SilentlyContinue

# Filtering events for the specific user
$specificUserEvents = $lockoutEvents | Where-Object { $_.Properties[0].Value -eq $specificUser }

# Checking if any events were found for the user
if ($specificUserEvents) {
    # Building output based on advanced properties
    $specificUserEvents | Select-Object `
        @{Name = "LockedUser"; Expression = { $_.Properties[0].Value }}, `
        @{Name = "SourceComputer"; Expression = { $_.Properties[1].Value }}, `
        @{Name = "DomainController"; Expression = { $_.Properties[4].Value }}, `
        TimeCreated
} else {
    Write-Host "No lockout events found for the user '$specificUser' in the last 365 days." -ForegroundColor Yellow
}

# End of Script
