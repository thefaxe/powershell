# Prüfen, ob als Admin gestartet
if (-not ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltinRole] "Administrator")) {
    Write-Warning "Bitte als Administrator ausführen!"
    Start-Process -FilePath pwsh -ArgumentList "-NoProfile -ExecutionPolicy Bypass -File `"$PSCommandPath`"" -Verb RunAs
    exit
}

# ImportExcel Modul prüfen und laden/installieren
if (-not (Get-Module -ListAvailable -Name ImportExcel)) {
    Write-Host "ImportExcel Modul wird installiert..."
    Install-Module -Name ImportExcel -Scope CurrentUser -Force
}
Import-Module ImportExcel

$results = @()

# Liste der Registry-Pfade für Autostart (Benutzerspezifisch)
$userRunPaths = @(
    "Software\Microsoft\Windows\CurrentVersion\Run",
    "Software\Microsoft\Windows\CurrentVersion\RunOnce"
)

# Systemweite Registry-Pfade
$systemRunPaths = @(
    "HKLM:\Software\Microsoft\Windows\CurrentVersion\Run",
    "HKLM:\Software\Microsoft\Windows\CurrentVersion\RunOnce",
    "HKLM:\Software\Wow6432Node\Microsoft\Windows\CurrentVersion\Run",
    "HKLM:\Software\Wow6432Node\Microsoft\Windows\CurrentVersion\RunOnce"
)

# 1) Systemweite Einträge auslesen
foreach ($key in $systemRunPaths) {
    try {
        $entries = Get-ItemProperty -Path $key -ErrorAction SilentlyContinue
        if ($entries) {
            $entries.PSObject.Properties |
                Where-Object { $_.Name -notmatch '^PS' } |
                ForEach-Object {
                    $results += [PSCustomObject]@{
                        Quelle      = "Registry (Systemweit)"
                        Benutzer    = ""
                        Pfad        = $key
                        Name        = $_.Name
                        Wert        = $_.Value
                    }
                }
        }
    } catch {}
}

# 2) Benutzerbezogene Einträge für alle Benutzer unter HKEY_USERS auslesen
$sids = Get-ChildItem "Registry::HKEY_USERS" | Where-Object {
    $_.Name -notin @("HKEY_USERS\S-1-5-18","HKEY_USERS\S-1-5-19","HKEY_USERS\S-1-5-20")  # System-Profile ausschließen
}

foreach ($sid in $sids) {
    foreach ($path in $userRunPaths) {
        $fullPath = "$($sid.Name)\$path"
        try {
            $entries = Get-ItemProperty -Path $fullPath -ErrorAction SilentlyContinue
            if ($entries) {
                $entries.PSObject.Properties |
                    Where-Object { $_.Name -notmatch '^PS' } |
                    ForEach-Object {
                        $results += [PSCustomObject]@{
                            Quelle      = "Registry (Benutzer)"
                            Benutzer    = $sid.Name -replace "HKEY_USERS\\", ""
                            Pfad        = $fullPath
                            Name        = $_.Name
                            Wert        = $_.Value
                        }
                    }
            }
        } catch {}
    }
}

# 3) Startup-Ordner aller Benutzer prüfen
$allUserStartup = "$env:ProgramData\Microsoft\Windows\Start Menu\Programs\Startup"

$results += Get-ChildItem -Path $allUserStartup -File -ErrorAction SilentlyContinue | ForEach-Object {
    [PSCustomObject]@{
        Quelle   = "Startup-Ordner (Alle Benutzer)"
        Benutzer = ""
        Pfad     = $allUserStartup
        Name     = $_.Name
        Wert     = $_.FullName
    }
}

# Alle Benutzer-Profile durchsuchen für Startup-Ordner
$userProfiles = Get-ChildItem "C:\Users" -Directory -ErrorAction SilentlyContinue | Where-Object { $_.Name -notin @("Default", "Default User", "Public", "All Users") }

foreach ($profile in $userProfiles) {
    $startupFolder = Join-Path $profile.FullName "AppData\Roaming\Microsoft\Windows\Start Menu\Programs\Startup"
    if (Test-Path $startupFolder) {
        Get-ChildItem -Path $startupFolder -File -ErrorAction SilentlyContinue | ForEach-Object {
            $results += [PSCustomObject]@{
                Quelle   = "Startup-Ordner (Benutzer)"
                Benutzer = $profile.Name
                Pfad     = $startupFolder
                Name     = $_.Name
                Wert     = $_.FullName
            }
        }
    }
}

# Export-Ordner definieren
$exportFolder = "C:\analyse"

# Ordner anlegen, falls nicht vorhanden
if (-not (Test-Path $exportFolder)) {
    New-Item -ItemType Directory -Path $exportFolder | Out-Null
}

# Export-Pfad bauen
$exportPath = Join-Path $exportFolder "Autostart_Eintraege_$(Get-Date -Format 'yyyyMMdd_HHmmss').xlsx"

# Exportieren nach Excel
$results | Export-Excel -Path $exportPath -AutoSize -Title "Autostart Einträge"

Write-Host "Autostart-Einträge wurden exportiert nach:`n$exportPath"
