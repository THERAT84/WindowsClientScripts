<#########################################################################
Scriptname:     map_drives.ps1
Function:       switches hostsentrys and connects to new share
Created at:     24.07.2026
Author:         THERAT84
Version:        1.0
Modifications:  Added new function for hostsfile handling
#>
##########################################################################

$ipFileServer ="192.168.x.x"
$ipNAS ="192.168.x.x"
$hostname = "hostname"

if($ipNAS){
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
