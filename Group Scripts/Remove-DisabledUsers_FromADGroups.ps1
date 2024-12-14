#'===========================================================================================================================================
#'This PowerShell script is designed to manage disabled user accounts in Active Directory by removing them from all groups.
#'Except for a specified group ("Domain Users") and excluding certain accounts and Organizational Units (OUs). 
#'The script also generates a report detailing which users were removed from which groups and exports this information to a CSV file.,
#'Requires DNSServer PS Module.
#'===========================================================================================================================================
#'The script identifies all disabled user accounts in Active Directory that are not the specified exceptions 
#'-------(krbtgt, ILS_ANONYMOUS_USER, padministrator), and excludes users from a specific OU.
#'It then removes these users from all groups except "Domain Users".
#'Finally, the script exports the results to a CSV file for documentation and review.
#'=======================================================================================================================
#********KEY ACTIONS********
#'
#'Filter Users: Retrieves disabled users, excluding specific accounts and those in the specified OU.
#'Remove from Groups: For each eligible user, removes them from all groups except "Domain Users".
#'Export Results: Outputs the details of removed users and their group memberships to a CSV file.
#********Output********
#'
#'A CSV file containing the SamAccountName of each user and a comma-separated list of the groups they were removed from.
#'Prerequisites
#'===========================================================================================================================================
#********DO NOT MAKE ANY MODIFICATIONS TO THE SCRIPT WITHOUT MARTY CONFIRMATION*********
#'======================================================================================
#'Script Name: Remove-DisabledUsers_FromADGroups.ps1
#'Owner: CABOT
#'Created By: Jonathan Preetham
#'Created On: 01/09/2024
#'Version: 0.1
#'======================================================================================


#'**Script Start**

 #'Import the Active Directory module
Import-Module ActiveDirectory

#'Define the distinguished name (DN) of the OU to exclude
$excludedOU1 = "OU=Resources,DC=cabot,DC=cabot-corp,DC=com"
$excludedOU2 = "OU=SharedMailboxes,DC=cabot,DC=cabot-corp,DC=com"

#'Initialize an array to store the results
$results = @()

#'Get all disabled users, excluding specific accounts and those in the specified OU
$disabledUsers = Get-ADUser -Filter {
    Enabled -eq $false -and
    SamAccountName -notlike "krbtgt" -and
    SamAccountName -notlike "ILS_ANONYMOUS_USER" -and
    SamAccountName -notlike "padministrator"
} -Properties SamAccountName, MemberOf, DistinguishedName | 
Where-Object { $_.DistinguishedName -notlike "*$excludedOU1*" -and $_.DistinguishedName -notlike "*$excludedOU2*" } |
Select-Object SamAccountName, MemberOf

#'Loop through each filtered disabled user
foreach ($user in $disabledUsers) {
    $userSamAccountName = $user.SamAccountName
    $userGroups = $user.MemberOf | ForEach-Object { Get-ADGroup -Identity $_ } | Where-Object { $_.Name -notlike "Domain Users" }

    #'Remove the user from all groups except "Domain Users"
    foreach ($group in $userGroups) {
        Remove-ADGroupMember -Identity $group -Members $userSamAccountName -Confirm:$false
    }

    #'Add the result to the array
    $results += [PSCustomObject]@{
        SamAccountName = $userSamAccountName
        RemovedFromGroups = ($userGroups | ForEach-Object { $_.Name }) -join ","
    }
}

#'Output the results to a CSV file
$results | Export-Csv -Path "C:\Temp\DisabledUsersGroupRemovalResults.csv" -NoTypeInformation

Write-Host "Completed removing disabled users from AD groups, excluding specific accounts and the specified OU. Results exported to C:\Temp\DisabledUsersGroupRemovalResults.csv." -ForegroundColor Green


#'**Script End**

