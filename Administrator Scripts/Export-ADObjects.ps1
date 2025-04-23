<#
.SYNOPSIS
    Menu-driven PowerShell script to export Active Directory objects.

.DESCRIPTION
    This script provides a prompt to the user to select which AD object to export.
    Based on the selection, it exports Users, Groups, Computers, OUs, or GPO names.

.NOTES
    Script Name    : Export-ADObjects.ps1
    Version        : 1.0
    Author         : Jonathan Preetham
    Approved By    : 
    Date           : 2025-04-22
    Purpose        : Export different AD objects based on user selection.

.PREREQUISITES
    - Run with AD PowerShell module
    - RSAT tools installed

.EXAMPLE
    Just run the script and follow the prompt.

#>

Import-Module ActiveDirectory

function Export-ADUsers {
    Get-ADUser -Filter * -Properties DisplayName, SamAccountName, EmailAddress | 
    Select-Object DisplayName, SamAccountName, EmailAddress |
    Export-Csv -Path "AD_Users.csv" -NoTypeInformation
    Write-Host "Exported AD Users to AD_Users.csv"
}

function Export-ADGroups {
    Get-ADGroup -Filter * | 
    Select-Object Name, GroupScope, Description |
    Export-Csv -Path "AD_Groups.csv" -NoTypeInformation
    Write-Host "Exported AD Groups to AD_Groups.csv"
}

function Export-ADComputers {
    Get-ADComputer -Filter * -Properties Name, OperatingSystem |
    Select-Object Name, OperatingSystem |
    Export-Csv -Path "AD_Computers.csv" -NoTypeInformation
    Write-Host "Exported AD Computers to AD_Computers.csv"
}

function Export-ADOrganizationalUnits {
    Get-ADOrganizationalUnit -Filter * |
    Select-Object Name, DistinguishedName |
    Export-Csv -Path "AD_OUs.csv" -NoTypeInformation
    Write-Host "Exported AD OUs to AD_OUs.csv"
}

function Export-GPOs {
    Get-GPO -All | 
    Select-Object DisplayName, Id, CreationTime |
    Export-Csv -Path "AD_GPOs.csv" -NoTypeInformation
    Write-Host "Exported Group Policy Objects to AD_GPOs.csv"
}

function Show-Menu {
    Clear-Host
    Write-Host "Select the AD object to export:"
    Write-Host "1. Users"
    Write-Host "2. Groups"
    Write-Host "3. Computers"
    Write-Host "4. Organizational Units (OUs)"
    Write-Host "5. Group Policy Objects (GPOs)"
    Write-Host "6. Exit"
}

do {
    Show-Menu
    $choice = Read-Host "Enter your choice [1-6]"

    switch ($choice) {
        '1' { Export-ADUsers }
        '2' { Export-ADGroups }
        '3' { Export-ADComputers }
        '4' { Export-ADOrganizationalUnits }
        '5' { Export-GPOs }
        '6' { Write-Host "Exiting..." }
        default { Write-Host "Invalid selection. Please try again." }
    }

    if ($choice -ne '6') {
        Pause
    }

} while ($choice -ne '6')
