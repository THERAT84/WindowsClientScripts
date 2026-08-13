<#########################################################################
Scriptname:     map_drives.ps1
Function:       maps shares
Created at:     .07.2026
Author:         THERAT84
Version:        1.0
Modifications:  
#>
##########################################################################

$ipFileServer ="192.168.x.x"
$ipNAS ="192.168.x.x"
$hostname = "hostname"
$hostsPath = "$env:SystemRoot\System32\drivers\etc\hosts"
$ShareL = "testshare"
$ShareK = "testshare2"
$hostnameNAS = "hostname-NAS"
$ShareNAS = "PRD"

Write-Host "Map-Script gestartet"
Write-Host "Benutzer: $([System.Security.Principal.WindowsIdentity]::GetCurrent().Name)"

if ((Get-Content $hostsPath) -match [regex]::Escape($ipNAS)){ 
    $Credential = Get-Credential -UserName mucnas-p01\testcifs -Message "Passwort hier eingeben"
    $user= $Credential.UserName
    $password= $Credential.GetNetworkCredential().Password
    net use \\$hostname /delete /yes 
    net use L: /delete /yes 
    net use K: /delete /yes 
    Remove-PSDrive -Name L -ErrorAction SilentlyContinue
    Remove-PSDrive -Name K -ErrorAction SilentlyContinue
    Start-Sleep 5
    net use \\$hostnameNAS\$ShareNAS $password /user:$user /persistent:yes
    net use L: \\$hostname\$ShareL $password /user:$user /persistent:yes
    net use K: \\$hostname\$ShareK $password /user:$user /persistent:yes
    Write-Host "NAS Laufwerke verbunden"
}
else{
        net use \\$hostname /delete /yes 
        net use L: /delete /yes 
        net use K: /delete /yes 
        Remove-PSDrive -Name L -ErrorAction SilentlyContinue
        Remove-PSDrive -Name K -ErrorAction SilentlyContinue
        Start-Sleep 5
        net use L: \\$hostname\$ShareL /user:$env:USERDOMAIN\$Env:USERNAME /persistent:no
        net use K: \\$hostname\$ShareK /user:$env:USERDOMAIN\$Env:USERNAME /persistent:no
        Write-Host "FileServer Laufwerke verbunden"
    }

Write-Host "Map-Script beendet"
Read-Host "Druecke Enter zum Beenden"
