#Bulk update ImmutableID based on a CSV file
$var = Import-CSV path\to\file\immutableID.csv
$var | % { Update-MgUser -UserId $_.UserPrincipalName -OnPremisesImmutableId $_.ImmutableId }
