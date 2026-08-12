<#########################################################################
Scriptname:     map_drives.ps1
Function:       maps shares
Created at:     .07.2026
Author:         THERAT84
Version:        1.0
Modifications:  
#>
##########################################################################

$ipFileServer ="192.168.13.21"
$ipNAS ="192.168.13.23"
$hostname = "nvds05"
$hostsPath = "$env:SystemRoot\System32\drivers\etc\hosts"
$ShareL = "testshare"

Write-Host "Map-Script gestartet"
Write-Host "Benutzer: $([System.Security.Principal.WindowsIdentity]::GetCurrent().Name)"
Write-Host "Session: $env:SESSIONNAME"

if ((Get-Content $hostsPath) -match [regex]::Escape($ipNAS)){
    $Credential = Import-Clixml -Path "C:\secret\cred.xml"
    #$Credential = New-Object System.Management.Automation.PSCredential($ImportedCredential.UserName, $ImportedCredential.Password)
    #$user= $Credential.UserName
    #$password= $Credential.GetNetworkCredential().Password
    #New-SmbMapping -RemotePath "\\$hostname\ipc$" -UserName $Credential.Username -Password ($Credential.GetNetworkCredential().Password) -Persistent $false
    New-SmbMapping -LocalPath "K:" -RemotePath "\\$hostname\$ShareL" -UserName $Credential.username -Password $Credential.Password -Persistent $false
    #New-SmbMapping -RemotePath "\\$hostname\$ShareL" -Persistent $false
    #net use L: \\$hostname\$ShareL /persistent:no
    #net use L: \\$hostname\$ShareL $password /user:$user /persistent:no
    #net use K: \\$hostname\$ShareK $password /user:$user /persistent:no
    Write-Host "NAS Laufwerke verbunden"
}
else{
        net use L: \\$hostname\$ShareL /user:$env:USERDOMAIN\$Env:USERNAME /persistent:yes
        #net use K: \\$hostname\$ShareK /user:$env:USERDOMAIN\$Env:USERNAME /persistent:yes
        Write-Host "FileServer Laufwerke verbunden"
    }

Write-Host "Map-Script beendet"
Read-Host "Druecke Enter zum Beenden"

#"User: $(whoami)" | Out-File C:\temp\maptest.txt
#"Session: $env:SESSIONNAME" | Out-File C:\temp\maptest.txt -Append
