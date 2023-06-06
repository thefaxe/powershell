#sync_intune_devices.ps1
#
# Synopsis
# 
# Force sync for windows devices registered in Intune
#
#
################################################################

Import-Module WindowsAutoPilotIntune
Import-Module -Name Microsoft.Graph.Intune


if(!(Connect-MSGraph)){Connect-MSGraph}

$Devices = Get-IntuneManagedDevice -Filter "contains(operatingsystem, 'Windows')"
Foreach ($Device in $Devices)
{
 
Invoke-IntuneManagedDeviceSyncDevice -managedDeviceId $Device.managedDeviceId
Write-Host "Sende Synchronisationsanforderung an Gerät mit ID DeviceID $($Device.managedDeviceId)" -ForegroundColor Yellow
 
}