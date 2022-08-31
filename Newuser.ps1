
# Cleaning up en preparing temp directory
if (Test-Path c:\temp\domain) {Remove-Item C:\Temp\domain\domainvalue.csv
    Remove-Item C:\Temp\domain}

if (Test-Path c:\temp\domain) {continue}
else {
    mkdir c:\Temp\domain
}

# Try Log into MsOnline
try
{
    Get-MsolDomain -ErrorAction Stop > $null
}
catch 
{
    if ($cred -eq $null) {Connect-MsolService}
    Write-Output "Connecting to Office 365..."

}

# Get Domainnames of Tenant and stores them in a CSV. After that it stores them in a context menu.
get-msoldomain | Export-Csv c:\temp\domain\domainvalue.csv
$domainarray = Import-Csv c:\temp\domain\domainvalue.csv
$domainarray.Name
Start-Sleep -Seconds 3
Write-Host $domainarray
Clear-Host
Write-Host Selecteer je domein doormiddel van het nummer:
$0 = $domainarray.Name[0]
$1 = $domainarray.Name[1]
$2 = $domainarray.Name[2]
$3 = $domainarray.Name[3]
$4 = $domainarray.Name[4]
$5 = $domainarray.Name[5]

do {
    Write-Host $domainarray.c
} until ( $0 -is $null, $1 -is $null, $2 -is $null, $3 -is $null, $4 -is $null, $5 -is $null
    <# Condition that stops the loop if it returns true #>
)

if ($0 -notcontains '*') {
    Write-Host [0] $0
}else
    {continue}

if ($1 -ne "") {
    Write-Host [1] $1
}else
    {continue}

if ($2 -ne "*") {
    Write-Host [2] $2
}else
    {break}

if ($3 -ne "") {
    Write-Host [3] $3
}else
    {continue}
    
if ($4 -ne "") {
    Write-Host [4] $4
}else
    {continue}

if ($5 -ne "") {
     Write-Host [5] $5
}else
    {continue}


# Parameter help description
$domainkeuze = Read-Host -Prompt 'domainname'
$finaldomain = $domainarray.Name[$domainkeuze]
Clear-Host 
Write-Host Je maakt een gebruiker aan voor $domainarray.Name[$domainkeuze]
$firstname = Read-Host -Prompt 'First Name'
$Lastname = Read-Host -Prompt 'Last Name'
$upn = Read-Host -Prompt 'UPN'

#Cleanup files
Remove-Item C:\Temp\domain\domainvalue.csv
Remove-Item C:\Temp\domain

Write-Host De user $firstname $Lastname is aangemaakt met de email $upn'@'$finaldomain
Test-Connection