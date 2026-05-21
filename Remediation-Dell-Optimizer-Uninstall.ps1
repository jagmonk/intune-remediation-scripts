<#
.SYNOPSIS
    Intune Remediation Script - Dell Optimizer Uninstall
    
.DESCRIPTION
    This script uninstalls Dell Optimizer from Windows devices.
    Designed for use with Microsoft Intune remediation feature.
    
.NOTES
    Run context: System
    Execution policy: RemoteSigned or Unrestricted
    Author: IT Team
    Version: 1.0
#>

# Set error action preference
$ErrorActionPreference = "Continue"

# Variables
$appName = "Dell Optimizer"
$appNames = @("Dell Optimizer", "DellOptimizer")
$uninstallAttempted = $false

# Function to write output for Intune
function Write-RemediationLog {
    param([string]$Message, [string]$Type = "INFO")
    $timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    Write-Host "[$timestamp] [$Type] $Message"
}

Write-RemediationLog "Starting Dell Optimizer uninstall remediation script"

# Check if Dell Optimizer is installed
Write-RemediationLog "Checking for Dell Optimizer installation..."

$installedApps = Get-ItemProperty -Path @(
    'HKLM:\Software\Microsoft\Windows\CurrentVersion\Uninstall\*',
    'HKLM:\Software\Wow6432Node\Microsoft\Windows\CurrentVersion\Uninstall\*'
) -ErrorAction SilentlyContinue | 
    Select-Object DisplayName, UninstallString, PSPath

$dellOptimizerInstalled = $false

foreach ($app in $installedApps) {
    if ($app.DisplayName -match "Dell Optimizer") {
        $dellOptimizerInstalled = $true
        Write-RemediationLog "Found Dell Optimizer: $($app.DisplayName)" "INFO"
        
        # Try to uninstall using the UninstallString
        if ($app.UninstallString) {
            Write-RemediationLog "Attempting uninstall using UninstallString: $($app.UninstallString)" "INFO"
            
            try {
                if ($app.UninstallString -match "msiexec") {
                    # Handle MSI uninstall
                    $uninstallCmd = $app.UninstallString -replace "/I", "/X"
                    $uninstallCmd = "$uninstallCmd /quiet /norestart"
                    Write-RemediationLog "Executing: $uninstallCmd" "INFO"
                    Invoke-Expression $uninstallCmd -ErrorAction Stop
                }
                elseif ($app.UninstallString -match ".exe") {
                    # Handle EXE uninstall
                    $uninstallCmd = "$($app.UninstallString) /quiet /norestart"
                    Write-RemediationLog "Executing: $uninstallCmd" "INFO"
                    & cmd /c $uninstallCmd
                }
                
                $uninstallAttempted = $true
                Write-RemediationLog "Uninstall command executed successfully" "SUCCESS"
            }
            catch {
                Write-RemediationLog "Error executing uninstall command: $($_.Exception.Message)" "ERROR"
            }
        }
    }
}

# If not found in registry, try alternative methods
if (-not $dellOptimizerInstalled) {
    Write-RemediationLog "Dell Optimizer not found in registry. Trying alternative detection methods..." "INFO"
}

# Try winget uninstall (if available)
Write-RemediationLog "Attempting uninstall via Windows Package Manager (winget)..." "INFO"
try {
    $wingetPath = Get-Command winget -ErrorAction SilentlyContinue
    if ($wingetPath) {
        foreach ($name in $appNames) {
            Write-RemediationLog "Searching for: $name" "INFO"
            $uninstallResult = & winget uninstall --name "$name" --silent --force 2>&1
            if ($LASTEXITCODE -eq 0) {
                Write-RemediationLog "Successfully uninstalled via winget: $name" "SUCCESS"
                $uninstallAttempted = $true
            }
        }
    }
    else {
        Write-RemediationLog "winget not available on this system" "INFO"
    }
}
catch {
    Write-RemediationLog "winget uninstall attempt failed: $($_.Exception.Message)" "WARNING"
}

# Try WMI uninstall as fallback
Write-RemediationLog "Attempting uninstall via WMI..." "INFO"
try {
    $wmiProduct = Get-WmiObject -Class Win32_Product -Filter "Name LIKE '%Dell Optimizer%'" -ErrorAction SilentlyContinue
    if ($wmiProduct) {
        Write-RemediationLog "Found via WMI: $($wmiProduct.Name)" "INFO"
        $wmiProduct.Uninstall() | Out-Null
        Write-RemediationLog "Successfully uninstalled via WMI" "SUCCESS"
        $uninstallAttempted = $true
    }
}
catch {
    Write-RemediationLog "WMI uninstall attempt failed: $($_.Exception.Message)" "WARNING"
}

# Verify uninstall
Write-RemediationLog "Verifying uninstall..." "INFO"
$verifyApps = Get-ItemProperty -Path @(
    'HKLM:\Software\Microsoft\Windows\CurrentVersion\Uninstall\*',
    'HKLM:\Software\Wow6432Node\Microsoft\Windows\CurrentVersion\Uninstall\*'
) -ErrorAction SilentlyContinue | 
    Where-Object { $_.DisplayName -match "Dell Optimizer" } |
    Select-Object DisplayName

if ($verifyApps.Count -eq 0) {
    Write-RemediationLog "Dell Optimizer successfully uninstalled" "SUCCESS"
    exit 0
}
else {
    Write-RemediationLog "Dell Optimizer still detected after uninstall attempt. Found: $($verifyApps.Count) instance(s)" "ERROR"
    exit 1
}
