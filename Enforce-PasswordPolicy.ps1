# Enforce Password Policy
New-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Password Policy" -Name MinPasswordLength -Value 10 -PropertyType DWORD -Force
Write-Host "Minimum password length set to 10 characters."