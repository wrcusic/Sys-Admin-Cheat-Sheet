#Generate ImmutableIDs for all AD users</pre>
Get-ADUser -Filter * | select UserPrincipalName,ObjectGUID,@{n="ImmutableID";e={[System.Convert]::ToBase64String($_.ObjectGUID.tobytearray())} } | Export-Csv -nti C:\Users\Spectrumadmin\Desktop\immutableID.csv
