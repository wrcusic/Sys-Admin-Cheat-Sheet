#Generate ImmutableIDs for all AD users</pre>
Get-ADUser -Filter * | select UserPrincipalName,ObjectGUID,@{n="ImmutableID";e={[System.Convert]::ToBase64String($_.ObjectGUID.tobytearray())} } | Export-Csv -nti path\to\file\immutableID.csv
