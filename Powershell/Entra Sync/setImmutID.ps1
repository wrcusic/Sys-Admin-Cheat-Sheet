#Bulk update ImmutableID based on a CSV file
$var = Import-CSV C:\Users\Spectrumadmin\Desktop\immutableID.csv
$var | % { Update-MgUser -UserId $_.UserPrincipalName -OnPremisesImmutableId $_.ImmutableId }
