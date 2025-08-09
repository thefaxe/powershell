# Powershell Scripts

## Installation

create folder c:\batch and copy ps1-file to folder

## Scripts

regkeys-autostart_fuer_alle_benutzer.ps1 => use "run as admin" and get all autostart-regkeys for all users exported as Excel in folder "C:\analyse"

change_user_cn.ps1 => Get all users from an active directory organisation unit change display name, distinguished name and companyname

change_user_cn.ps1 => Get all users from an active directory organisation unit change change upn (f.e. migrating users to azure)

reset_wsus.ps1 => clean wsuscontent folder after removing approval in wsus console

install_dotnet_35.ps1 => offline install for .NET 3.5 on Windows 10 from dvd or usb-drive

remove_windows_apps.ps1 => remove unnecessary windows 10 apps from logged in user

SyncDCs.ps1 => force AD replication for all existing DCs

import_gpo.ps1 => Imports GPOs from selected folder, german translation and added logging to c:\temp\import.log 

sync_intune_devices.ps1 => force sync of up to 1000 windows devices connected to Intune

## Links
https://johnpenford.wordpress.com/category/gpo/
