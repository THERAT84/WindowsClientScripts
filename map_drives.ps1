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
$ShareL = "testshare"
$ShareK = "testshare2"

if ((Get-Content $hostsPath) -match [regex]::Escape($ipNAS)){
    $ImportedCredential = Import-Clixml -Path "C:\secret\cred.xml"
    $Credential = New-Object System.Management.Automation.PSCredential($ImportedCredential.UserName, $ImportedCredential.Password)
    $user= $Credential.UserName
    $password= $Credential.GetNetworkCredential().Password
    net use \\$hostname\ipc$ $password /user:$user /persistent:no
    net use L: \\$hostname\$ShareL $password /user:$user /persistent:no
    net use K: \\$hostname\$ShareK $password /user:$user /persistent:no
    Write-Host "NAS Laufwerke verbunden"
}
    else{
        net use L: \\$hostname\$ShareL /user:$env:USERDOMAIN\$Env:USERNAME /persistent:yes
        net use K: \\$hostname\$ShareK /user:$env:USERDOMAIN\$Env:USERNAME /persistent:yes
        Write-Host "FileServer Laufwerke verbunden"
    }
