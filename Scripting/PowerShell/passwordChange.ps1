# Automation script to reset passwords while in user-land

$Password = ConvertTo-SecureString -String "[enterPassword]" -AsPlainText -Force
$Username = Get-LocalUser -Name "[username]"

$Username | Set-LocalUser -Password $Password
