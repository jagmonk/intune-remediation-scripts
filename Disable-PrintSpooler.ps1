# Disable Print Spooler Service
Set-Service -Name Spooler -StartupType Disabled
Stop-Service -Name Spooler
Write-Host "Print Spooler service disabled."