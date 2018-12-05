#change_user_upn.ps1
#
# Synopsis
# 
# Get all Users from an active directory organisation unit and change upn
#
#
################################################################
#Variables - edit as required
################################################################

$container = "OU=ouname,DC=domain,DC=local"
$oldupn = "domain.local"
$newupn = "newupn"
$server = "server"

################################################################

Import-Module ActiveDirectory

Get-ADUser -SearchBase $container -filter * | ForEach-Object { 
	$setnewUpn = $_.UserPrincipalName.Replace($oldupn,$newupn)
	$_ | Set-ADUser -server $server -UserPrincipalName $setnewupn 
	}