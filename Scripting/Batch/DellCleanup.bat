ECHO "Running Clean-up Job..."
ECHO OFF

dism /online /cleanup-image /scanhealth&&dism /online cleanup-image /restorehealth$$sfc /scannow&&cd C:\Program Files (x86)\Dell\CommandUpdate\&&dcu-cli.exe /scan&&dcu-cli.exe /applyUpdates

ECHO "Clean-up Job Complete."
