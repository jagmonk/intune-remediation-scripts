# Configuring Windows Update Policy
Write-Host "Configuring Windows Update Policy..."
Set-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate" -Name WUServer -Value "https://windowsupdate.microsoft.com"
Set-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate" -Name WUStatusServer -Value "https://windowsupdate.microsoft.com"