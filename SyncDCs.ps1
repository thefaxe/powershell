#SyncDCs.ps1
#
# Synopsis
# 
# Force AD Replication for all existing DCs
#
#
################################################################
$DomainControllers = Get-ADDomainController -Filter *
ForEach ($DC in $DomainControllers.Name) {
    Write-Host "Processing for "$DC -ForegroundColor Green
    REPADMIN /kcc $DC
    REPADMIN /syncall /A /e /q $DC
}