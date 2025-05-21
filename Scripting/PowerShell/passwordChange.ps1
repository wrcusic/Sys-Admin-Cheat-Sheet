# Automation script to reset local user passwords

ECHO 'Y' Set-ExecutionPolicy Bypass

$Password = ConvertTo-SecureString -String "[enterPassword]" -AsPlainText -Force
$Username = Get-LocalUser -Name "[username]"

$Username | Set-LocalUser -Password $Password

# Uncomment if you want the user's password to never expire
#$Username | Set-LocalUser -PasswordNeverExpires $True
