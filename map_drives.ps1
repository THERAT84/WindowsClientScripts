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

if ((Get-Content $hostsPath) -match [regex]::Escape($ipNAS)){
    $ImportedCredential = Import-Clixml -Path "C:\secret\cred.xml"
    $Credential = New-Object System.Management.Automation.PSCredential($ImportedCredential.UserName, $ImportedCredential.Password)
    net use L: \\$hostname\$ShareL $password $user
    #New-PSDrive -Persist -Name L -PSProvider FileSystem -Root "\\$hostname\testshare" -Credential $Credential
    #New-PSDrive -Persist -Name K -PSProvider FileSystem -Root "\\$hostname\testshare2" -Credential $Credential
    Write-Host "NAS Laufwerke verbunden"
}
    else{
        net use L: \\$hostname\$ShareL /user:$env:userdomain\$env:username /persistent:yes
        net use K: \\$hostname\$ShareK /user:$env:userdomain\$env:username /persistent:yes
        #New-PSDrive -Persist -Name L -PSProvider FileSystem -Root "\\$hostname\testshare" -Scope Global
        #New-PSDrive -Persist -Name K -PSProvider FileSystem -Root "\\$hostname\testshare2" -Scope Global
        Write-Host "FileServer Laufwerke verbunden"
    }
