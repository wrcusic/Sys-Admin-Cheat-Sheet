:: Run Dell Command Update

echo

cd %PROGRAMFILES\Dell\CommandUpdate\

dcu-cli.exe /scan -outputLog

&&

dcu-cli.exe /applyUpdates -outputLog
