<#
.SYNOPSIS
    Update any attribute for Active Directory Users in Bulk

.DESCRIPTION
    This script updates specified attributes for multiple Active Directory users in bulk.

.NOTES
    Script Name    : Set-ADUsers_BulkAttributeUpdate.ps1
    Version        : 0.1
    Author         : [Your Name]
    Approved By    : [Approver's Name]
    Date           : [Date]
    Purpose        : The purpose of the script is to perform bulk updates of a specific attribute for multiple Active Directory user accounts,
                     by reading the attribute values from a CSV file. This automation simplifies and accelerates the process of modifying AD user attributes, 
                     especially when managing a large number of users, ensuring accuracy and consistency while reducing manual effort.

.PREREQUISITES
    - Active Directory PowerShell module installed.
    - Proper permissions to modify user attributes.
    - Input file with required details (e.g., CSV format).

.PARAMETERS
    None

.EXAMPLE
    - Create a new Excel file and type SamAccountName in Cell A1, Type "AttributeValue" in Cell B1,
    - Add the list of users to whom the attribute needs to be updated,
    - Run the Script in Administrator Mode,
    - It can be any attribute that you want to update, Description, Office, DisplayName or any new custom attribute.

#>

# Start of Script

# Update Attribute Name
$AttributeName = "Description"

# Import Active Directory Module
Import-Module ActiveDirectory -ErrorAction Stop

# Define CSV File Path
$CsvFilePath = "C:\Temp\BulkAttributeUpdate.csv"

# Check if the CSV file exists
if (-Not (Test-Path -Path $CsvFilePath)) {
    Write-Host "CSV file not found at path: $CsvFilePath" -ForegroundColor Red
    exit
}

# Import CSV File and Process Each Entry
Import-Csv -Path $CsvFilePath | ForEach-Object {
    $SamAccountName = $_.SamAccountName
    $AttributeValue = $_.AttributeValue

    try {
        # Update User Attribute
        Set-ADUser -Identity $SamAccountName -Replace @{ $AttributeName = $AttributeValue }

        # Write Success Message
        Write-Host "User $SamAccountName has been updated with value '$AttributeValue' for '$AttributeName' attribute." -ForegroundColor Cyan
    }
    catch {
        # Write Error Message
        Write-Host "Failed to update user $SamAccountName: $_" -ForegroundColor Red
    }
}

# End of Script