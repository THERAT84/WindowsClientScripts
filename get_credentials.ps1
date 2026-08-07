<########################################################################
Scriptname:     get_credentials.ps1
Function:       store encrypetd creds in file
Created at:     07.08.2026
Author:         THERAT84
Version:        1.0
Modifications:  
#>
##########################################################################

$credpath = "C:\secret\"
$hostname = "hostname"

$Credential = Get-Credential -Credential $hostname\$Env:USERNAME
if (-not(Test-Path $credpath -PathType Container)) {
    New-Item -Path $credpath -ItemType Directory
}
$Credential | Export-Clixml -Path $credpath\cred.xml
Write-Host "Credentials gespeichert"