# Powershell Scripts

## Synopsis

Sample Powershell Scripts for daily administration

## Motivation

Make Windows Server administration simpler

## Installation

create folder c:\batch and copy ps1-file to folder

## Scripts

change_user_cn.ps1 => Get all users from an active directory organisation unit change display name, distinguished name and companyname

change_user_cn.ps1 => Get all users from an active directory organisation unit change change upn (f.e. migrating users to azure)

reset_wsus.ps1 => clean wsuscontent folder after removing approval in wsus console

install_dotnet_35.ps1 => offline install for .NET 3.5 on Windows 10 from dvd or usb-drive

remove_windows_apps.ps1 => remove unnecessary windows 10 apps from logged in user

SyncDCs.ps1 => force AD replication for all existing DCs

import_gpo.ps1 => Imports GPOs from selected folder, german translation and added logging to c:\temp\import.log 

## Links
https://johnpenford.wordpress.com/category/gpo/