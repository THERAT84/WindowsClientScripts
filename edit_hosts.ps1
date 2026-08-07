<#########################################################################
Scriptname:     edit_hosts.ps1
Function:       Edits hosts entrys
Created at:     30.07.2026
Author:         THERAT84
Version:        1.0
Modifications:  
#>
##########################################################################

#declare variables
$ipFileServer ="192.168.x.x"
$ipNAS ="192.168.x.x"
$hostname = "hostname"
$MapScriptPath = "c:\secret\map_drives.ps1"
$TaskName ="RunAsLoggedOnUserTask"

#declare function
function Set-Hostsfile {
    param(
        [ValidateSet('FileServer','NAS')]
        [string]$Server
    )

    $hostsPath = "$env:SystemRoot\System32\drivers\etc\hosts"
    $hostsentryFileServer = "$ipFileServer`t$hostname"
    $hostsentryNAS        = "$ipNAS`t$hostname"
    $backup = "$hostsPath.bak"

    $Target = switch ($Server) {
        'FileServer' { $hostsentryFileServer }
        'NAS'        { $hostsentryNAS }
    }
    if (-not (Test-Path $backup))
        {Copy-Item $hostsPath $backup -Force}

    # Hosts aus sauberem Backup wiederherstellen
    Copy-Item $backup $hostsPath -Force
    # Originalinhalt laden
    $lines = @(Get-Content $backup)
    $lines += $target
    $tempFile = "$hostsPath.tmp"
    $lines | Set-Content $tempFile -Encoding ASCII
    Copy-Item $tempFile $hostsPath -Force
    Remove-Item $tempFile
    Write-Host "Hosts-Eintrag gesetzt: $Target"
}
function Set-Server {
    Remove-SmbMapping -LocalPath "L:" -Force -ErrorAction SilentlyContinue
    Remove-SmbMapping -LocalPath "K:" -Force -ErrorAction SilentlyContinue
    Write-Host "ClearDNS Cache"
    Clear-DnsClientCache
    net stop workstation /y 
    net start workstation
    $Action = New-ScheduledTaskAction -Execute "powershell.exe" -Argument "-NoProfile -ExecutionPolicy Bypass -File `"$MapScriptPath`""
    $Principal = New-ScheduledTaskPrincipal -GroupId "S-1-5-32-545" 
    $Task = New-ScheduledTask -Action $Action -Principal $Principal
    Register-ScheduledTask -TaskName $TaskName -InputObject $Task -Force | Out-Null
    Start-ScheduledTask -TaskName $TaskName
    Start-Sleep -Seconds 3
    Read-Host "Press Enter to continue"
    Unregister-ScheduledTask -TaskName $TaskName -Confirm:$false
}

do {
    Clear-Host
    Write-Host "=== MEIN AUSWAHLMENÜ ==="
    Write-Host "1: Verbindung FileServer"
    Write-Host "2: Verbindung NAS"
    Write-Host "3: Beenden"
    
    $wahl = Read-Host "Bitte eine Zahl eingeben"

    switch ($wahl) {
        '1' {
            Set-Hostsfile -Server FileServer
            Start-Sleep -Milliseconds 200
            Set-Server 
            Write-Host "Konfiguration für Arbeiten auf FileServer abgeschlossen"
            Read-Host "Drücke Enter zum Fortfahren..."
        }
        '2' {
            Set-Hostsfile -Server NAS
            Start-Sleep -Milliseconds 200
            Set-Server 
            Write-Host "Konfiguration für Arbeiten auf dem NAS abgeschlossen"
            Read-Host "Drücke Enter zum Fortfahren..."
        }
        '3' {
            Write-Host "Tschüss!"
        }
        default {
            Write-Host "Falsche Eingabe, bitte nochmal." -ForegroundColor Red
            Start-Sleep -Seconds 2
        }
    }
} until ($wahl -eq '3')
