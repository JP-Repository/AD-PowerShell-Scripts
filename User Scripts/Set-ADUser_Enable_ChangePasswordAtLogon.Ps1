#=========================================================================================
#Below Script will Check the "ChangePasswordAtLogon" for user accuounts in Temp Folder
#=========================================================================================
#Created By: Jonathan Preetham
#Script Name: Set-ADUser_Enable_ChangePasswordAtLogon.ps1
#Script Version: 0.1
#=========================================================================================

#Importing AD Module
Import-Module ActiveDirectory

Import-Csv "C:\Temp\Users.csv" | ForEach-Object {
 $samAccountName = $_."samAccountName"

 #One Line Command
 Get-ADUser -Identity $samAccountName | Set-ADUser -ChangePasswordAtLogon:$True
 }