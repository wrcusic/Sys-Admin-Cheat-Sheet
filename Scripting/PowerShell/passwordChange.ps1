# Reset local user passwords. Content in "[]" needs to be changed to relevant usernames and passwords. Will work on an interactive version of this script.

ECHO 'Y' Set-ExecutionPolicy Bypass

$Password = ConvertTo-SecureString -String "[enterPassword]" -AsPlainText -Force
$Username = Get-LocalUser -Name "[username]"

$Username | Set-LocalUser -Password $Password

# Uncomment below if you want the user's password to never expire:
#$Username | Set-LocalUser -PasswordNeverExpires $True
