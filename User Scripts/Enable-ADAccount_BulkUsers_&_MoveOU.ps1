#'Importing ActiveDirectory Module,
Import-Module ActiveDirectory
 
    #'Imports AD Users Details From .CSV File & Assigns It To Variable
    $Imported = Import-Csv -Path "C:\Temp\BulkUsersEnableTemplate.csv"
        
        #'Writing Host,
        Write-Host "Data Imported" -ForegroundColor Cyan

    #'Simple ForEach-Object Command To Read The Data From The Excel File
    $Imported | ForEach-Object {
                                $SamAccountName = $_.SamAccountName

                #'One Line Command To Enable User Accounts Mentioned In .CSV File
                Enable-ADAccount -Identity $SamAccountName

#'Retrieve DN Of User
$UserDN = (Get-ADUser -Identity $_.SamAccountName).DistinguishedName

#'Retrieve Data From .CSV File & Move Enabled Accounts To Target OU Present In .CSV File
$TargetOU = $_.TargetOU

    #'Writing Host,
    Write-Host "Started Moving Accounts ....." -ForegroundColor Green
 
                #'One Line Command To Move User Accounts Mentioned In .CSV File To Their Respective OU
                Move-ADObject -Identity $UserDN -TargetPath $TargetOU
}
    #'Writing Host,
    Write-Host "Completed AD User's Enablement & OU-Movement" -ForegroundColor Green

#'Simple Command To Know The Count,
$Total = ($Imported).Count
    
    #'Writing Host,
    Write-Host $Total "User Accounts Are Enabled & Moved Successfully" -ForegroundColor Cyan