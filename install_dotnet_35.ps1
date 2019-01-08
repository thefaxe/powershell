#install_dotnet_35.ps1
#
# Synopsis
#
# Offline-Install DotNet 3.5 Framework on Windows 10
# insert usb-stick or dvd in any drive
#
#
################################################################
#Variables - edit as required
################################################################

################################################################

$drives=get-psdrive | where {$_.Provider -match 'FileSystem'}
foreach ($drive in $drives)
{
 $installwim = $drive.root+"\sources\boot.wim"
 $installpath = $drive.root+"\sources\sxs"

 if (Test-Path $installwim ){
    echo Found Offline Installer in $installpath
    echo Installing .NET Framework 3.5...
    Enable-WindowsOptionalFeature -Online -FeatureName NetFX3 -Source $installpath
    exit
    }
}
Write-Host "no installation media found! Please insert DVD or USB flash drive and start script again."

