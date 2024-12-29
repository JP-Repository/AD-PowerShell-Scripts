<#
.SYNOPSIS
    This PowerShell script removes disabled user accounts from all AD groups, except "Domain Users", excluding specified accounts and OUs.
    It also exports a CSV report with the removed users and the groups they were removed from.
    
.DESCRIPTION
    The script fetches all disabled user accounts from Active Directory, excluding certain accounts (e.g., "krbtgt", "ILS_ANONYMOUS_USER", "padministrator")
    and users from specified OUs (e.g., "Resources" and "SharedMailboxes"). It then removes these users from all groups except "Domain Users".
    The results are exported to a CSV file for documentation and review.

.NOTES
    Script Name    : Remove-DisabledUsers_FromADGroups.ps1
    Version        : 0.1
    Created By     : 
    Date           : 
    Owner          : 
    Approved By    : [Approver's Name]
    Tested By      : [Tester Name]
    Purpose        : To remove disabled users from Active Directory groups while excluding certain users and OUs.
    
.EXAMPLE
    .\Remove-DisabledUsers_FromADGroups.ps1

Example 1: Excluding Specific Users by SamAccountName
If you want to exclude specific users based on their SamAccountName, you can add conditions in the filter to exclude them.

# Exclude users with specific SamAccountNames (e.g., "admin", "guest", or "serviceAccount")
$disabledUsers = Get-ADUser -Filter {
    Enabled -eq $false -and
    SamAccountName -notlike "krbtgt" -and
    SamAccountName -notlike "ILS_ANONYMOUS_USER" -and
    SamAccountName -notlike "padministrator" -and
    SamAccountName -notlike "admin" -and
    SamAccountName -notlike "guest" -and
    SamAccountName -notlike "serviceAccount"
} -Properties SamAccountName, MemberOf, DistinguishedName

Example 2: Excluding Users from Specific Organizational Units (OUs)

# Define the DN (Distinguished Name) of the OUs to exclude
$excludedOU1 = "OU=Resources,DC=contoso,DC=contoso-corp,DC=com"
$excludedOU2 = "OU=SharedMailboxes,DC=contoso,DC=contoso-corp,DC=com"

# Get all disabled users, excluding users in certain OUs
$disabledUsers = Get-ADUser -Filter {
    Enabled -eq $false -and
    SamAccountName -notlike "krbtgt" -and
    SamAccountName -notlike "ILS_ANONYMOUS_USER" -and
    SamAccountName -notlike "padministrator"
} -Properties SamAccountName, MemberOf, DistinguishedName |
Where-Object { 
    $_.DistinguishedName -notlike "*$excludedOU1*" -and
    $_.DistinguishedName -notlike "*$excludedOU2*" 
} |
Select-Object SamAccountName, MemberOf

Example 3: Excluding Specific Groups from Being Processed

# Exclude users from being removed from the "Domain Users" group or any other group
$excludedGroups = @("Domain Users", "Group1", "Group2")  # List of groups to exclude

foreach ($group in $userGroups) {
    if ($excludedGroups -contains $group.Name) {
        Write-Host "Skipping removal from group: $($group.Name)" -ForegroundColor Yellow
        continue
    }

    # Remove the user from all groups except "Domain Users"
    Remove-ADGroupMember -Identity $group -Members $userSamAccountName -Confirm:$false
}

Example 4: Excluding Specific Accounts from Being Processed

# Define the list of accounts to exclude
$excludedAccounts = @("krbtgt", "ILS_ANONYMOUS_USER", "padministrator")

# Get all disabled users, excluding specific accounts
$disabledUsers = Get-ADUser -Filter {
    Enabled -eq $false
} -Properties SamAccountName, MemberOf | 
Where-Object { $excludedAccounts -notcontains $_.SamAccountName } |
Select-Object SamAccountName, MemberOf

Example 5: Excluding Disabled Users Based on Specific Conditions

If you have specific conditions for disabled users (such as users who haven't been disabled for a certain number of days), you can modify the filter accordingly. 
For example, excluding users who have been disabled for more than 30 days:

# Exclude users who have been disabled for more than 30 days
$daysInactive = 30
$disabledUsers = Get-ADUser -Filter { Enabled -eq $false } -Properties SamAccountName, MemberOf, WhenChanged |
Where-Object {
    ($_.'WhenChanged' -lt (Get-Date).AddDays(-$daysInactive))  # Exclude users disabled for more than 30 days
} |
Select-Object SamAccountName, MemberOf

#>

# Script Start

# Import the Active Directory module
Import-Module ActiveDirectory

# Define the distinguished names (DN) of the OUs to exclude
$excludedOU1 = "OU=Resources,DC=contoso,DC=contoso-corp,DC=com"
$excludedOU2 = "OU=SharedMailboxes,DC=contoso,DC=contoso-corp,DC=com"

# Initialize an array to store the results
$results = @()

# Get all disabled users, excluding specific accounts and those in the specified OUs
$disabledUsers = Get-ADUser -Filter {
    Enabled -eq $false -and
    SamAccountName -notlike "krbtgt" -and
    SamAccountName -notlike "ILS_ANONYMOUS_USER" -and
    SamAccountName -notlike "padministrator"
} -Properties SamAccountName, MemberOf, DistinguishedName | 
Where-Object { $_.DistinguishedName -notlike "*$excludedOU1*" -and $_.DistinguishedName -notlike "*$excludedOU2*" } |
Select-Object SamAccountName, MemberOf

# Total number of disabled users for progress bar
$totalUsers = $disabledUsers.Count
$counter = 0

# Loop through each filtered disabled user and remove them from groups
foreach ($user in $disabledUsers) {
    $counter++
    $progress = ($counter / $totalUsers) * 100
    Write-Progress -PercentComplete $progress -Status "Processing Disabled Users" -Activity "Removing user $counter of $totalUsers"

    $userSamAccountName = $user.SamAccountName
    $userGroups = $user.MemberOf | ForEach-Object { Get-ADGroup -Identity $_ } | Where-Object { $_.Name -notlike "Domain Users" }

    # Remove the user from all groups except "Domain Users"
    foreach ($group in $userGroups) {
        Remove-ADGroupMember -Identity $group -Members $userSamAccountName -Confirm:$false
    }

    # Add the result to the array
    $results += [PSCustomObject]@{
        SamAccountName = $userSamAccountName
        RemovedFromGroups = ($userGroups | ForEach-Object { $_.Name }) -join ","
    }
}

# Output the results to a CSV file
$results | Export-Csv -Path "C:\Temp\DisabledUsersGroupRemovalResults.csv" -NoTypeInformation

Write-Host "Completed removing disabled users from AD groups, excluding specific accounts and the specified OU. Results exported to C:\Temp\DisabledUsersGroupRemovalResults.csv." -ForegroundColor Green

# End of Script
