Write-Host "### Print the AD domain information of the Windows instance." -ForegroundColor Blue

Get-WmiObject -Namespace root\cimv2 -Class Win32_ComputerSystem



Write-Host "### Retrieve the password of the AD domain user, Admin, from Secrets Manager and construct a PowerShell PSCredential object." -ForegroundColor Blue

$secret =(aws secretsmanager get-secret-value --secret-id "rdsktest/ad" | ConvertFrom-Json).SecretString | ConvertFrom-Json
$username = "Admin"
$convert_param_map = @{"AsPlainText"=$True; "Force"=$True}
$password = ConvertTo-SecureString $secret.password @convert_param_map
$domainCredential = New-Object System.Management.Automation.PSCredential -ArgumentList ($username, $password)
$secret = $null
Write-Output ""


Write-Host "### Create two AD domain users (dbuser1 and dbuser2) using PowerShell PSCredential object." -ForegroundColor Blue

$dbUserPassword = Read-Host -Prompt "Please enter the new AD domain user password for dbuser1 and dbuser2" -AsSecureString
$dbUserPassword2 = Read-Host -Prompt "Please enter the new AD domain user password again" -AsSecureString
if ( [Runtime.InteropServices.Marshal]::PtrToStringAuto([Runtime.InteropServices.Marshal]::SecureStringToBSTR($dbUserPassword)) -ne
    [Runtime.InteropServices.Marshal]::PtrToStringAuto([Runtime.InteropServices.Marshal]::SecureStringToBSTR($dbUserPassword2)) ) {
    throw "ERROR - Passwords mismatch"
}
$dbUserPassword2 = $null

try {
    $user=$null
    try { $user=Get-ADUser "dbuser1" -Credential $domainCredential } catch { }
    if(-not $user) {
        New-ADUser -Name "dbuser1" -AccountPassword $dbUserPassword -Credential $domainCredential -Enabled $true -PasswordNeverExpires $true -ChangePasswordAtLogon $false
        Write-Output "AD user dbuser1 created."
    }
    else {
        Set-ADAccountPassword dbuser1 -NewPassword $dbUserPassword -Credential $domainCredential -Reset
        Enable-ADAccount dbuser1 -Credential $domainCredential
        Write-Output "AD user dbuser1 password changed."
    }
}
catch {
    Write-Host $_ -ForegroundColor Red
}
try {
    $user=$null
    try { $user=Get-ADUser "dbuser2" -Credential $domainCredential } catch { }
    if(-not $user) {
        New-ADUser -Name "dbuser2" -AccountPassword $dbUserPassword -Credential $domainCredential -Enabled $true -PasswordNeverExpires $true -ChangePasswordAtLogon $false
        Write-Output "AD user dbuser2 created."
    }
    else {
        Set-ADAccountPassword dbuser2 -NewPassword $dbUserPassword -Credential $domainCredential -Reset
        Enable-ADAccount dbuser2 -Credential $domainCredential
        Write-Output "AD user dbuser2 password changed."
    }
}
catch {
    Write-Host $_ -ForegroundColor Red
}

Write-Output ""

Write-Host "### List the two AD domain users using PowerShell PSCredential object." -ForegroundColor Blue



$adusers = Get-ADUser -Filter 'Name -like "dbuser*"' -Credential $domainCredential -properties PwdLastSet | ?{ $_.Enabled -eq $True} 
    
$adusers | ft Name,UserPrincipalName,DistinguishedName,`
    @{Name='PwdLastSet';Expression={[DateTime]::FromFileTime($_.PwdLastSet)}},`
    Enabled  | Format-Table 
    
if (-not $adusers -or -not $adusers.Count -or $adusers.Count -lt 2) {
    throw "ERROR - Enabled AD Domain Users (dbuser*) is less than 2"
}


# Remove-ADUser "dbuser1" -Credential $domainCredential
# Remove-ADUser "dbuser2" -Credential $domainCredential