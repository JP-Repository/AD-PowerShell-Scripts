<#
.SYNOPSIS
    This script retrieves all users from Active Directory, including their `SamAccountName`, `Enabled`, `EmailAddress`, `DisplayName`, and `MemberOf` attributes, and exports them to a CSV file. The script includes a progress bar to show the status of the operation.

.DESCRIPTION
    The script fetches all Active Directory user accounts and their group memberships (`MemberOf`), along with other attributes such as `SamAccountName`, `Enabled`, and `EmailAddress`. It then exports the results to a CSV file located in the `C:\Temp` folder. The script includes a progress bar to show the status of the operation.

.NOTES
    Script Name    : Get-ADUsers_With_MemberOf_Export.ps1
    Version        : 0.1
    Created By     : [Your Name]
    Approved By    : [Approver's Name]
    Tested By      : [Tester Name]
    Date           : [Date]
    Purpose        : To gather all AD users and their group memberships and export them to a CSV file.

.PARAMETERS
    - None.

.EXAMPLE
    .\Get-ADUsers_With_MemberOf_Export.ps1
#>

# Start of Script

# Inform the user that the script is starting and may take a while
Write-Host " "
Write-Host "INFORMATION-PLEASE READ" -ForegroundColor Green
Write-Host "The script will take more than an hour to complete depending upon the number of users in Active Directory."
Write-Host "The output will be saved in the Temp folder as a CSV file."
Write-Host "Once the script is completed, you will receive a pop-up dialog box."

# Try to import the Active Directory module
try {
    Import-Module ActiveDirectory
} catch {
    Write-Warning "The Active Directory module was not found. Please ensure it is installed and available."
    exit
}

# Retrieve all AD users and their group memberships, then export to CSV
try {
    # Get the total number of users in AD for progress tracking
    $totalUsers = (Get-ADUser -Filter *).Count

    # Initialize progress bar
    $progressBar = 0
    $counter = 0

    # Create an array to store the results
    $results = @()

    # Retrieve all users and process their group memberships
    Get-ADUser -Filter * -Properties DisplayName, SamAccountName, Enabled, EmailAddress, MemberOf | ForEach-Object {
        $counter++
        $progressBar = ($counter / $totalUsers) * 100

        # Create a custom PSObject for each user and their group memberships
        $userObject = New-Object PSObject -Property @{
            UserName      = $_.DisplayName
            SamAccountName = $_.SamAccountName
            Enabled       = $_.Enabled
            EmailAddress  = $_.EmailAddress
            Groups        = ($_.MemberOf | Get-ADGroup | Select -ExpandProperty Name) -join ","
        }

        # Add the user data to the results array
        $results += $userObject

        # Update the progress bar
        Write-Progress -PercentComplete $progressBar -Status "Processing Users" -Activity "Processing user $counter of $totalUsers"
    }

    # Export results to CSV
    $csvPath = "C:\Temp\ADUsers_With_MemberOf_$(get-date -f dd-MM-yyyy).csv"
    $results | Select UserName, SamAccountName, Enabled, EmailAddress, Groups | Export-Csv $csvPath -NoTypeInformation

    Write-Host "Export completed successfully. The output file is saved in C:\Temp."

} catch {
    Write-Warning "An error occurred while retrieving user group memberships: $_"
}

# Popup dialog box to notify completion
$wshell = New-Object -ComObject Wscript.Shell 
$Output = $wshell.Popup("The script has completed successfully. The output file is saved in the Temp folder.")

# End of Script
