#==================================================================================================
#This one line command will fetch all user's in Active Directory with all User-Attributes
#The script will take a while to complete depending upon the number of user's present in AD
#Exported file will be saved in Temp Folder on the current Server
#==================================================================================================
#Importing Module
Import-Module ActiveDirectory

#Fetching all AD Users with all attributes exporting with current date
Get-ADUser -Filter * -Properties * | Export-Csv C:\Temp\All_AD_Users_$(get-date -f dd-MM-yyyy).csv