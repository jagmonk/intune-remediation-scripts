# VPN Configuration
Add-VpnConnection -Name "CorporateVPN" -ServerAddress "vpn.yourcompany.com" -TunnelType SplitTunnel -AuthenticationMethod EAP -EncryptionLevel Required
Write-Host "VPN Connection configured."