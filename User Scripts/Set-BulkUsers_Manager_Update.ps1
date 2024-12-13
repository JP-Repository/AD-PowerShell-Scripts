
Import-Csv "C:\Temp\BulkUsersManagerUpdate.csv" | 

ForEach-Object {
                $SamAccountName = $_.SamAccountName 
                $Manager = $_.Manager 
                
                $ManagerDN = Get-ADUser $Manager -Properties * | Select-Object DistinguishedName
                $ManagerName = Get-ADUser $Manager -Properties * | Select-Object DisplayName
                
                Set-ADUser -Identity $SamAccountName -Manager $ManagerDN
                    
                    Write-Host "For user $SamAccountName manager $ManagerName has been updated" -ForegroundColor Cyan
                           }