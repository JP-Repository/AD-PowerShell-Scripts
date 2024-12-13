<#
.SYNOPSIS
    Updates multiple attributes for Active Directory user accounts in bulk based on data provided in a CSV file.

.DESCRIPTION
    This script automates the process of updating multiple attributes for Active Directory users by reading the user data from a CSV file. 
    The SamAccountName column serves as the unique identifier for each user, and additional columns represent the attributes to be updated with their respective values. 
    The script dynamically processes all attributes provided in the CSV file, ensuring flexibility and scalability.

    It includes:
	•	Error handling to capture and log any failures.
	•	Skip logic to ignore empty values for attributes.
	•	Logging of successful updates with details of the attributes modified.

.NOTES
    Script Name    : Update-ADUser_MultipleAttributes.ps1
    Version        : 0.1
    Author         : [Your Name]
    Approved By    : [Approver's Name]
    Date           : [Date]
    Purpose        : 

.PREREQUISITES
    - 
    - 
    - Input file with required details (e.g., CSV format).

.PARAMETERS
    [Optional] Define any script parameters here if applicable.

.EXAMPLE
    # Save the script as Update-ADUserAttributes.ps1 and execute it.
    # CSV File: C:\Temp\BulkAttributeUpdate.csv
    # Example content:
    # SamAccountName,Title,Department,Manager,pilotUser
    # jdoe,Developer,IT,cn=jsmith,ou=Users,dc=example,dc=com,True
    # asmith,Analyst,Finance,cn=jdoe,ou=Users,dc=example,dc=com,False

# Run the script
.\Update-ADUser_MultipleAttributes.ps1

#>

# Start of Script

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

    # Prepare Attributes HashTable for Update
    $Attributes = @{}
    $_.PsObject.Properties.Where({ $_.Name -ne "SamAccountName" }) | ForEach-Object {
        if ($_.Value -ne $null -and $_.Value -ne "") {
            $Attributes[$_.Name] = $_.Value
        }
    }

    try {
        # Update User Attributes
        if ($Attributes.Count -gt 0) {
            Set-ADUser -Identity $SamAccountName -Replace $Attributes

            # Write Success Message
            Write-Host "User $SamAccountName has been updated with attributes: $($Attributes.Keys -join ', ')" -ForegroundColor Cyan
        } else {
            Write-Host "No attributes to update for user $SamAccountName." -ForegroundColor Yellow
        }
    }
    catch {
        # Write Error Message
        Write-Host "Failed to update user $SamAccountName: $_" -ForegroundColor Red
    }
}

# End of Script