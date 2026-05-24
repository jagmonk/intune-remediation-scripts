# Remove Bloatware
$bloatware = @('XboxGameOverlay', 'OneDrive', 'Microsoft.YourPhone', 'OfficeHub')
foreach ($app in $bloatware) {
    Write-Host "Removing: $app"
    Get-AppxPackage -Name *$app* | Remove-AppxPackage -ErrorAction SilentlyContinue
}