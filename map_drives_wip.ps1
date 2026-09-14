<#########################################################################
Scriptname:     map_drives.ps1
Function:       maps shares
Created at:     30.07.2026
Author:         THERAT84
Version:        1.0
Modifications:  
#>
##########################################################################

$ipFileServer ="192.168.x.x"
$ipNAS ="192.168.x.x"
$hostname = "hostname"
$hostsPath = "$env:SystemRoot\System32\drivers\etc\hosts"
$ShareM = "shareA"
$ShareK = "shareb"
$hostnameNAS = "hsotnameNAS"

Write-Host "MAP-Script started"

if ((Get-Content $hostsPath) -match [regex]::Escape($ipNAS)){

   $user = "mucnas-p01\testcifs"

    net use \\$hostname /delete /yes *> $null
    net use M: /delete /yes *> $null
    net use K: /delete /yes *> $null

    Remove-PSDrive -Name K -ErrorAction SilentlyContinue
    Remove-PSDrive -Name M -ErrorAction SilentlyContinue

    Start-Sleep -Seconds 5

    net use M: \\$hostname\$ShareM /user:$user /persistent:no
    net use K: \\$hostname\Marketing_CD /persistent:no

    Write-Host "NAS Laufwerke verbunden"
}
else{
        net use \\$hostname /delete /yes *> $null
        net use M: /delete /yes *> $null
        net use K: /delete /yes *> $null
        Remove-PSDrive -Name K -ErrorAction SilentlyContinue
        Remove-PSDrive -Name M -ErrorAction SilentlyContinue
        Start-Sleep -Seconds 5
        net use M: \\$hostname\$ShareM /user:$env:USERDOMAIN\$Env:USERNAME /persistent:no
        net use K: \\$hostname\Marketing_CD /user:$env:USERDOMAIN\$Env:USERNAME /persistent:no
        Write-Host "FileServer Laufwerke verbunden"
    }
Read-Host "Map-Script beendet, druecke Enter zum Beenden"