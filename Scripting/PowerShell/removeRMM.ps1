Get-ItemProperty HKLM:\SOFTWARE\WOW6432Node\Microsoft\Windows\CurrentVersion\Uninstall\* | Where-Object { $_.DisplayName -eq "ITSPlatform" } | Select-Object DisplayName, DisplayVersion, Publisher, InstallDate  | Format-Table -AutoSize
 
# Check if the processes are running
$communicatortrayProcess = Get-Process -Name "platform-communicator-tray" -ErrorAction SilentlyContinue
$communicatorpluginProcess = Get-Process -Name "platform-communicator-plugin" -ErrorAction SilentlyContinue
$itsplatformcoreProcess = Get-Process -Name "platform-agent-core" -ErrorAction SilentlyContinue
$itsplatformmanagerProcess = Get-Process -Name "platform-agent-manager" -ErrorAction SilentlyContinue
$eventlogProcess = Get-Process -Name "platform-eventlog-plugin" -ErrorAction SilentlyContinue
$syseventsProcess = Get-Process -Name "platform-sysevents-plugin" -ErrorAction SilentlyContinue
 
if ($communicatortrayProcess -ne $null) {
   # Stop the tray process
   Stop-Process -Name "platform-communicator-tray" -Force
   Write-Host "Process 'platform-communicator-tray' terminated."
} else {
   Write-Host "Process 'platform-communicator-tray' not found."
}
 
if ($communicatorpluginProcess -ne $null) {
   # Stop the plugin process
   Stop-Process -Name "platform-communicator-plugin" -Force
   Write-Host "Process 'platform-communicator-plugin' terminated."
} else {
   Write-Host "Process 'platform-communicator-plugin' not found."
}
 
if ($itsplatformcoreProcess -ne $null) {
   # Stop the itsplatform process
   Stop-Process -Name "platform-agent-core" -Force
   Write-Host "Process 'platform-agent-core' terminated."
} else {
   Write-Host "Process 'platform-agent-core' not found."
}
 
 
if ($itsplatformmanagerProcess -ne $null) {
   # Stop the itsplatformmanager Process
   Stop-Process -Name "platform-agent-manager" -Force
   Write-Host "Process 'platform-agent-manager' terminated."
} else {
   Write-Host "Process 'platform-agent-manager' not found."
}
 
if ($eventlogProcess -ne $null) {
   # Stop the tray process
   Stop-Process -Name "platform-sysevents-plugin" -Force
   Write-Host "Process 'platform-sysevents-plugin' terminated."
} else {
   Write-Host "Process 'platform-sysevents-plugin' not found."
}
 
if ($syseventsProcess -ne $null) {
   # Stop the tray process
   Stop-Process -Name "platform-eventlog-plugin" -Force
   Write-Host "Process 'platform-eventlog-plugin' terminated."
} else {
   Write-Host "Process 'platform-eventlog-plugin' not found."
}
 
# Check if ITSPlatform entry is found in the registry
$itsPlatformEntry32 = Get-ItemProperty HKLM:\Software\Microsoft\Windows\CurrentVersion\Uninstall\* | Where-Object { $_.DisplayName -eq "ITSPlatform" }
$itsPlatformEntry64 = Get-ItemProperty HKLM:\SOFTWARE\WOW6432Node\Microsoft\Windows\CurrentVersion\Uninstall\* | Where-Object { $_.DisplayName -eq "ITSPlatform" }
 
if ($itsPlatformEntry32 -or $itsPlatformEntry64) {
   # Uninstall ITSPlatform
   Get-Package -Name "ITSPlatform*" | Uninstall-Package -Force
   Write-Host "ITSPlatform uninstalled."
}
 
# Run uninstall.exe with Administrator rights
$uninstallPath = "C:\PROGRA~2\SAAZOD\Uninstall\uninstall.exe"
if (Test-Path $uninstallPath) {
   Start-Process -FilePath $uninstallPath -ArgumentList "/U:C:\PROGRA~2\SAAZOD\Uninstall\uninstall.xml", "/silent" -Wait
} else {
   Write-Host "Uninstall.exe not found at $uninstallPath."
}
 
# Delete registry entries
Remove-Item -Path "HKLM:\SOFTWARE\WOW6432Node\SAAZOD" -ErrorAction SilentlyContinue
 
# Delete SAAZOD and ITSPlatform related registry entries
Remove-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\*" -Name "SAAZOD" -ErrorAction SilentlyContinue
Remove-ItemProperty -Path "HKLM:\SOFTWARE\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\*" -Name "SAAZOD" -ErrorAction SilentlyContinue
 
# Delete ITSPlatform entries from Computer\HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Installer\Folders
$itsPlatformInstallerFolders = Get-Item -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Installer\Folders" | Where-Object { $_.Name -match "ITSPlatform" }
 
# Remove registry entries
Remove-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Services" -Name "itsplatform" -ErrorAction SilentlyContinue
Remove-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Services" -Name "itsplatformmanager" -ErrorAction SilentlyContinue
Remove-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Services" -Name "itsplatform service" -ErrorAction SilentlyContinue
Remove-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Services" -Name "itsplatformmanager service" -ErrorAction SilentlyContinue
 
# Stop and delete services if already present
$servicesToDelete = @("itsplatform", "itsplatformmanager", "itsplatform service", "itsplatformmanager service")
foreach ($service in $servicesToDelete) {
   if (Get-Service -Name $service -ErrorAction SilentlyContinue) {
       try {
           Stop-Service -Name $service -Force
           Remove-Service -Name $service -Force
           Write-Host "Service ${service} stopped and removed."
       } catch {
           Write-Host "Error while stopping or removing ${service}: $_"
       }
   } else {
       Write-Host "Service ${service} is not present."
   }
}
 
foreach ($folder in $itsPlatformInstallerFolders) {
   if (Test-Path $folder.PSPath) {
       Remove-Item -Path $folder.PSPath
   } else {
       Write-Host "Folder not found at $($folder.PSPath)."
   }
}
 
# Delete SAAZOD and ITSPlatform folders from C:\Program Files (x86)
$saazodPath = "C:\Program Files (x86)\SAAZOD"
$itsPlatformPath = "C:\Program Files (x86)\ITSPlatform"
 
if (Test-Path $saazodPath) {
   Remove-Item -Path $saazodPath -Recurse -Force
} else {
   Write-Host "Folder not found at $saazodPath."
}
 
if (Test-Path $itsPlatformPath) {
   Remove-Item -Path $itsPlatformPath -Recurse -Force
} else {
   Write-Host "Folder not found at $itsPlatformPath."
}
 
Write-Host "Uninstallation completed."
