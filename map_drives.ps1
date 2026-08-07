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

if ((Get-Content $hostsPath) -match [regex]::Escape($ipNAS)){
    $Credential = Import-Clixml -Path "C:\secret\cred.xml"
    $user= $Credential.UserName
    $password= $Credential.GetNetworkCredential().Password
    net use L: \\$hostname\testshare $password /user:$user /persistent:yes
    net use K: \\$hostname\testshare $password /user:$user /persistent:yes
    Write-Host "NAS Laufwerke verbunden"
}
    else{
        New-PSDrive -Name L -PSProvider FileSystem -Root "\\$hostname\testshare" -Scope Global
        New-PSDrive -Name K -PSProvider FileSystem -Root "\\$hostname\testshare2" -Scope Global
        Write-Host "FileServer Laufwerke verbunden"
    }
