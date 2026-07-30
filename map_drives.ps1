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

if((Get-Content $hostsPath) -contains $ipNAS){
    $Credential = Import-Clixml -Path "C:\secret\cred.xml"
    New-PSDrive -Persist -Name L -PSProvider FileSystem -Root "\\$hostname\testshare" -Credential $Credential
    New-PSDrive -Persist -Name K -PSProvider FileSystem -Root "\\$hostname\testshare2" -Credential $Credential
    Write-Host "NAS Laufwerke verbunden"
}
    else{
        New-PSDrive -Persist -Name L -PSProvider FileSystem -Root "\\$hostname\testshare"
        New-PSDrive -Persist -Name K -PSProvider FileSystem -Root "\\$hostname\testshare2"
        Write-Host "FileServer Laufwerke verbunden"
    }
