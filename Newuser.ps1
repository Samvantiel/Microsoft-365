clear-host
# Cleaning up en preparing temp directory
Write-host "Creating Temp directory"
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
    if ($null -eq $cred) {Connect-MsolService}
    Write-Output "Connecting to Office 365..."

}

# Get Domainnames of Tenant and stores them in a CSV. After that it stores them in a context menu.
get-msoldomain | Export-Csv c:\temp\domain\domainvalue.csv
$domainarray = Import-Csv c:\temp\domain\domainvalue.csv
$domainarray.Name
Start-Sleep -Seconds 3
Clear-Host
Write-Host Selecteer je domein doormiddel van het nummer:
$0 = $domainarray.Name[0]
$1 = $domainarray.Name[1]
$2 = $domainarray.Name[2]
$3 = $domainarray.Name[3]
$4 = $domainarray.Name[4]
$5 = $domainarray.Name[5]

$tenantname1 = @($domainarray.name) -match '.onmicrosoft.com'
$tenantname2 = $tenantname1.split(".") | Select-Object -Index 0


if ($0 -notcontains '*') {
    Write-Host [0] $0
}else
    {continue}

if ($1 -ne "") {
    Write-Host [1] $1
}else
    {continue}

if ($2 -ne "") {
    Write-Host [2] $2
}else
    {continue}

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


# Licence naming
$m365nolicence = $null
$m365bb = [string] $tenantname2+":O365_BUSINESS_ESSENTIALS"
$FREEFLOW = [string] $tenantname2+":FLOW_FREE"

# Parameter help description
$domainkeuze = Read-Host -Prompt 'domainname'
$finaldomain = $domainarray.Name[$domainkeuze]
Clear-Host 
Write-Host Je maakt een gebruiker aan voor $domainarray.Name[$domainkeuze]
$firstname = Read-Host -Prompt 'First Name'
$Lastname = Read-Host -Prompt 'Last Name'
$upn = Read-Host -Prompt 'UPN'
Write-Host Users current displayname: $firstname $Lastname
$displayname = Read-Host -Prompt 'Change Displayname from displayname above '

# Choose password option
$manualpasswordentry = $null
$Automatepass = New-Object System.Management.Automation.Host.ChoiceDescription '&Automatically create a password', 'The system will automaticlly create a password for the user upon completion'
$Manuel = New-Object System.Management.Automation.Host.ChoiceDescription '&manually Add password', 'You will be able to manually create this users password'
$options = [System.Management.Automation.Host.ChoiceDescription[]]($Automatepass, $Manuel)

$title = 'Password generation'
$message = 'How do you want to add the users password?'
$result = $host.ui.PromptForChoice($title, $message, $options, 0)

switch ($result)
{
    0 { 'The password will be automatically generated' }
    1 { $manualpasswordentry = Read-Host -Prompt 'What should be the password?' }
}




#Cleanup files
Remove-Item C:\Temp\domain\domainvalue.csv
Remove-Item C:\Temp\domain
Start-Sleep -Seconds 3
Clear-Host
Write-Host The user [$displayname] "($firstname $Lastname)" has been created with the email: $upn'@'$finaldomain -ForegroundColor DarkYellow


# Verbose
if ($result -eq 0) {
    Write-Host "The Password for the user will be availible in the creation screen" -ForegroundColor DarkYellow
}else{
    Write-Host "The password for the user will be:" -ForegroundColor DarkYellow $manualpasswordentry} 
    Write-Host The datalocation is assigned to "EUR" -ForegroundColor DarkYellow
    
# Choose Licence
$m365nolicence = New-Object System.Management.Automation.Host.ChoiceDescription '&No Licence', 'The user is assigned no licence'
$m365bb = New-Object System.Management.Automation.Host.ChoiceDescription '&Basic', 'The user is assigned an Microsoft 365 Business Basic licence'
$FREEFLOW = New-Object System.Management.Automation.Host.ChoiceDescription '&flow', 'The user is assigned an Power Automate Free licence'
$options = [System.Management.Automation.Host.ChoiceDescription[]]($m365nolicence, $m365bb, $FREEFLOW)

$title = 'Licence assignment'
$message = 'What licence do you want to assign to the user?'
$result = $host.ui.PromptForChoice($title, $message, $options, 0)

switch ($result)
{
    0 { 'The user is not assigned a licence' }
    1 { $finallicence = $m365bb = [string] $tenantname2+":O365_BUSINESS_ESSENTIALS"}
    2 { $finallicence = $FREEFLOW = [string] $tenantname2+":FLOW_FREE"}
}

#Verbose
# Create 365 User

##!! Usage location is a static value!
if ($result -eq 0) {
    Write-Host debug1
    New-MsolUser -FirstName $firstname -LastName $Lastname -DisplayName $displayname -UserPrincipalName $upn'@'$finaldomain -Password $manualpasswordentry -PasswordNeverExpires $true |  Select-Object -Property Displayname, UserPrincipalName, Password
}else{
    Write-Host debug2
    New-MsolUser -FirstName $firstname -LastName $Lastname -DisplayName $displayname -UserPrincipalName $upn'@'$finaldomain -Password $manualpasswordentry -PasswordNeverExpires $true -LicenseAssignment $finallicence -UsageLocation "NL"|  Select-Object -Property Displayname, UserPrincipalName, Password
}



