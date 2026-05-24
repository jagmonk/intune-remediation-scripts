# Disable Local Administrator Access Script
$accountsToRemove = @('Guest', 'ExtraAdmin') # Specify accounts to remove

foreach ($account in $accountsToRemove) {
    try {
        Write-Host "Removing account: $account from Administrators"
        Remove-LocalGroupMember -Group "Administrators" -Member $account -ErrorAction Stop
    } catch {
        Write-Host "Error removing account $account: $_"
    }
}