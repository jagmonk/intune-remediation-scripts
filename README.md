# Intune Remediation Scripts

Collection of PowerShell remediation scripts for Microsoft Intune device management.

## Scripts

### Remediation-Dell-Optimizer-Uninstall.ps1

**Purpose:** Uninstall Dell Optimizer from Windows devices

**Description:** This remediation script safely removes Dell Optimizer from Windows systems. It uses multiple detection and removal methods to ensure reliable uninstallation across various system configurations.

**Features:**
- ✅ Multiple uninstall methods (Registry, winget, WMI)
- ✅ Silent uninstallation with no user interaction
- ✅ Comprehensive logging for troubleshooting
- ✅ Verification checks to confirm success
- ✅ Proper exit codes for Intune (0 = success, 1 = failure)

**Requirements:**
- Windows 10/11
- PowerShell 5.0 or later
- Admin/System rights

## Intune Deployment Instructions

### Step 1: Access Remediation Scripts
1. Go to **Microsoft Endpoint Manager** (https://endpoint.microsoft.com)
2. Navigate to **Devices** → **Remediation scripts**
3. Click **Create**

### Step 2: Configure Script
1. Enter a name: `Dell Optimizer Uninstall`
2. Enter a description: `Removes Dell Optimizer from Windows devices`
3. Copy the entire script content from `Remediation-Dell-Optimizer-Uninstall.ps1`
4. Paste into the **Script** field

### Step 3: Script Settings
- **Run this script using the logged-in credentials:** No (System context)
- **Run script in 64-bit PowerShell:** Yes
- **Check script signature:** No (if unsigned)
- **Enforce script signature check:** No

### Step 4: Remediation
- **Enable pre-remediation detection script:** No (optional)
- **Remediate non-compliant devices:** Yes

### Step 5: Assign
1. Click **Next** and assign to your target device groups
2. Review and click **Create**

## Monitoring

After deployment, monitor in Intune:
1. Go to **Devices** → **Remediation scripts**
2. Select the script
3. View **Device status** for success/failure details
4. Check device logs for detailed output

## Exit Codes

- **0** - Dell Optimizer successfully uninstalled
- **1** - Dell Optimizer still detected after uninstall attempt

## Troubleshooting

### Script runs but Dell Optimizer remains installed
- Check if the application is in use
- Verify device has required permissions
- Review script logs in Intune device details

### Script fails to execute
- Ensure PowerShell Execution Policy allows script execution
- Verify device has admin/system rights
- Check device has internet connectivity for winget operations

## Notes

- The script runs in System context, ensuring no user interaction is required
- Multiple removal methods increase compatibility across different Dell Optimizer versions
- The script includes built-in verification to confirm successful removal
- Logs are written to the standard output stream for Intune monitoring
