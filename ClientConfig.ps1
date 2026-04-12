<#########################################################################

Skriptname:     ClientConfig.ps1
Funktion:       Default Client Config for W11
Erstellt am:    06.04.2026
Author:         THERAT84
Version:        1.0

Aenderungen:

#>
##########################################################################

# Change Explorer start to this Computer
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v LaunchTo /t REG_DWORD /d 1 /f

# Change rightclick contextmenu to pre W11 settings
reg.exe add "HKCU\Software\Classes\CLSID\{86ca1aa0-34aa-4e8b-a509-50c905bae2a2}\InprocServer32" /f /ve

# Set Taskbar to left instead of centered 
New-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced\" -Name "TaskbarAl" -PropertyType DWord -Value 0 -Force

# Disable Taskbar Widgets
reg add "HKLM\Software\Policies\Microsoft\Dsh" /v "AllowNewsAndInterests" /t REG_DWORD /d "0" /f

# Disable Search on taskbar
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Search" /v "SearchButtonMarkup" /t REG_DWORD /d 0 /f
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Search" /v "SearchboxTaskbarMode" /t REG_DWORD /d 0 /f

# Restart explorer
Get-Process -Name explorer | Stop-Process -Force

$abfrage = Read-Host "Would you like to rename this pc? (yes/no)"
if ($abfrage -eq "yes") {
    $hostname = Read-Host "Enter new hostname: "
    Write-Host "Set new hostname: $hostname and restart computer"
    Rename-Computer -NewName $hostname -Restart
} else {
    Write-Host "Abort."
}
