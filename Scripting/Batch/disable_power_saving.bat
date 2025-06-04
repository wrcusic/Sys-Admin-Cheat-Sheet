@echo off
echo Disabling Hibernate and Sleep Settings...

:: Disable Hibernate
powercfg -hibernate off
echo Hibernate disabled.

:: Set sleep to 'Never' for both plugged in and battery (if applicable)
:: Set AC (plugged in) sleep timeout to 0 minutes (never)
powercfg /change standby-timeout-ac 0
:: Set DC (battery) sleep timeout to 0 minutes (never)
powercfg /change standby-timeout-dc 0

:: Also prevent display from turning off (optional)
powercfg /change monitor-timeout-ac 0
powercfg /change monitor-timeout-dc 0

echo Sleep settings updated to never.
pause
