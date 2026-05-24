# Path to the Adobe Acrobat PDF Printer settings in the Registry
$RegistryPath = "HKCU:\Software\Adobe\Acrobat Distiller\DC"

Function Set-PDFPrinterToUseSystemFonts {
    Param (
        [string]$PrinterSettingsPath
    )
    
    # Check if the registry key exists
    if (-Not (Test-Path -Path $PrinterSettingsPath)) {
        Write-Output "Registry path $PrinterSettingsPath does not exist. Exiting."
        return
    }

    # Modify the setting to use System Fonts (Setting value to 1 means enabled)
    try {
        Set-ItemProperty -Path $PrinterSettingsPath -Name "UseSystemFonts" -Value 1
        Write-Output "Set the Acrobat PDF printer to use system fonts successfully."
    } catch {
        Write-Error "Failed to set Acrobat PDF Printer to use system fonts. Error: $_"
    }
}

# Call the function with registry path
Set-PDFPrinterToUseSystemFonts -PrinterSettingsPath $RegistryPath