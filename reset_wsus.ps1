#reset_wsus.ps1
#
# Synopsis
# 
# clean wsuscontent folder after removing approval in wsus console
#
#
################################################################

stop-service wsusservice
cd "C:\Program Files\Update Services\Tools"
wsusutil.exe reset
write-host "Delete WSUS Folder Content"
for /d %%i in ( C:\wsus\WsusContent\*.* ) do rd /s /q %%i
start-service wsusservice