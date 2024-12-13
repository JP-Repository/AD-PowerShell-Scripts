
Import-Csv "C:\Temp\BulkUsersManagerRemoval.csv" | 

ForEach-Object {
                $SamAccountName = $_.SamAccountName 
                
                Set-ADUser -Identity $SamAccountName -Clear Manager
                    
                    Write-Host "Manager has been removed for $SamAccountName" -ForegroundColor Cyan
                           }