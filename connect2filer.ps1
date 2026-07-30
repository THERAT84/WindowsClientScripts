<#########################################################################
Scriptname:     connect2filer.ps1
Function:       
Created at:     24.07.2026
Author:         THERAT84
Version:        1.0
Modifications:
#>
##########################################################################

#declare variables
$ipFileServer ="192.168.x.x"
$ipNAS ="192.168.x.x"
$hostsPath = "$env:SystemRoot\System32\drivers\etc\hosts"
$hostname = "Hostname"
$hostsentryFileServer ="$ipFileServer`t$hostname"
$hostsentryNAS = "$ipNAS`t$hostname"

#declare function
function Set-Hostsfile {
    $hostsContent = Get-Content -Path $hostsPath
    $existingEntry = $hostsContent | Where-Object { $_ -match "\b$hostname\b" }

        if ($existingEntry) {
            Write-Output ">>> Eintrag für $hostname gefunden – wird entfernt."
            # Entfernen des Eintrags
            $hostsContent = $hostsContent | Where-Object { $_ -notmatch "\b$hostname\b" }

            # Hosts-Datei überschreiben (mit Admin-Rechten erforderlich!)
            Set-Content -Path $hostsPath -Value $hostsContent -Force
            Write-Output ">>> Hosts-Datei erfolgreich aktualisiert."
        } else {
    Write-Output ">>> Kein Eintrag für $hostname gefunden. Keine Änderung erforderlich."
}
} 
function Set-Server {
    param([string]$IP)
    $entry = "$IP`t$hostname"
    Write-Host "Eintrag $entry wird hinzugefügt"
    Add-Content $hostsPath $entry
    Remove-SmbMapping -LocalPath "L:" -Force -ErrorAction SilentlyContinue
    Remove-SmbMapping -LocalPath "K:" -Force -ErrorAction SilentlyContinue
    Write-Host "ClearDNS Cache"
    Clear-DnsClientCache
    net stop workstation /y 
    net start workstation
    $Credential = Import-Clixml "C:\Secure\Credential.xml"
    New-PSDrive -Persist -Name L -PSProvider FileSystem -Root "\\$hostname\test1" -Credential $Credential
    New-PSDrive -Persist -Name K -PSProvider FileSystem -Root "\\$hostname\test2" -Credential $Credential
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
            Set-Hostsfile
            Start-Sleep -Milliseconds 200
            Set-Server -IP $ipFileServer
            Write-Host "Konfiguration für Arbeiten auf FileServer abgeschlossen"
        }
        '2' {
            Set-Hostsfile
            Start-Sleep -Milliseconds 200
            Set-Server -IP $ipNAS
            Write-Host "Konfiguration für Arbeiten auf dem NAS abgeschlossen"
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




<#Write-Output ">>> Starte Rücksetzung für Arbeiten außerhalb von Trapez..."

# Hosts-Datei einlesen
$hostsContent = Get-Content -Path $hostsPath

# Prüfen, ob ein Eintrag für den Host existiert
$existingEntry = $hostsContent | Where-Object { $_ -match "\b$hostname\b" }

if ($existingEntry) {
    Write-Output ">>> Eintrag für $hostname gefunden – wird entfernt."
    # Entfernen des Eintrags
    $hostsContent = $hostsContent | Where-Object { $_ -notmatch "\b$hostname\b" }

    # Hosts-Datei überschreiben (mit Admin-Rechten erforderlich!)
    Set-Content -Path $hostsPath -Value $hostsContent -Force
    Write-Output ">>> Hosts-Datei erfolgreich aktualisiert."
} else {
    Write-Output ">>> Kein Eintrag für $._hostname gefunden. Keine Änderung erforderlich."
}
#>

# DNS-Cache leeren
Write-Output ">>> Leere DNS-Cache..."
ipconfig /flushdns | Out-Null

Write-Output ">>> Rücksetzung abgeschlossen. Bitte Verbindung testen."

#Fileserver

Write-Host "Suche offene SMB Dateien zu $server..."

# Offene Dateien schließen
Get-SmbOpenFile | Where-Object {
    $_.Path -like "*$server*"
} | ForEach-Object {
    Write-Host "Schließe Datei: $($_.Path)"
    Close-SmbOpenFile -FileId $_.FileId -Force
}

# Sessions schließen
Write-Host "Beende SMB Sessions zu $server..."
Get-SmbSession | Where-Object {
    $_.ClientComputerName -or $_.ServerName -like "*$server*"
} | ForEach-Object {
    Close-SmbSession -SessionId $_.SessionId -Force
}

nbtstat -R | Out-Null

Start-Sleep -Seconds 2

Write-Host "SMB Cleanup abgeschlossen."

#Erstellung des neuen Eintrags

#$newIP = "IP"

Write-Output ">>> Starte Konfiguration für Standort Trapez..."

# Hosts-Datei einlesen
$hostsContent = Get-Content -Path $hostsPath

# Prüfen, ob ein Eintrag für den Host bereits existiert
$existingEntry = $hostsContent | Where-Object { $_ -match "\b$hostname\b" }

if ($existingEntry) {
    Write-Output ">>> Vorhandenen Eintrag für $hostname gefunden - wird entfernt."
    # Entfernen des bestehenden Eintrags
    $hostsContent = $hostsContent | Where-Object { $_ -notmatch "\b$hostname\b" }
} else {
    Write-Output ">>> Kein bestehender Eintrag für $hostname gefunden."
}

# Neuen Eintrag hinzufügen
$newEntry = "$newIP`t$hostname"
Write-Output ">>> Füge neuen Eintrag hinzu: $newEntry"
$hostsContent += $newEntry

# Hosts-Datei überschreiben (mit Admin-Rechten erforderlich!)
Set-Content -Path $hostsPath -Value $hostsContent -Force
Write-Output ">>> Hosts-Datei erfolgreich aktualisiert."

# DNS-Cache leeren
Write-Output ">>> Leere DNS-Cache..."
ipconfig /flushdns | Out-Null

Write-Output ">>> Konfiguration abgeschlossen. Bitte Verbindung testen."

# Vorhandene Laufwerke trennen
net use K: /delete /y 2>$null
net use L: /delete /y 2>$null

# Optional kurz warten
Start-Sleep -Seconds 1

# Netzlaufwerke mit NAS verbinden
net use L: "\\hostname\folder" /user:user cred /persistent:yes
net use K: "\\hostname\folder" /user:user cred /persistent:yes