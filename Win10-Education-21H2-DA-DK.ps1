Write-Host  -ForegroundColor Green "Starting OSDCloud ZTI"
Start-Sleep -Seconds 5

#Change Display Resolution for Virtual Machine
if ((Get-MyComputerModel) -match 'Virtual') {
    Write-Host  -ForegroundColor Green "Setting Display Resolution to 1600x"
    Set-DisRes 1600
}

#Make sure I have the latest OSD Content
#Write-Host  -ForegroundColor Green "Updating OSD PowerShell Module"
#Install-Module OSD -Force

#Write-Host  -ForegroundColor Green "Importing OSD PowerShell Module"
#Import-Module OSD -Force

#Start OSDCloud ZTI the RIGHT way
Write-Host  -ForegroundColor Green "Start OSDCloud"
Start-OSDCloud -OSVersion 'Windows 10' -OSBuild 21H2 -OSEdition Education -OSLanguage da-dk -OSLicense Volume -Firmware -ZTI

#Cleanup ESD files
Write-Host  -ForegroundColor Green "Removing ESD files..."
Remove-Item -Path C:\OSDCloud\OS\*.esd -Recurse -Force
#Patch reg for TPM functionality
Write-Host  -ForegroundColor Green "Patching registry for TPM fuctionality..."
reg add HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Setup\OOBE /v SetupDisplayedEula /t REG_DWORD /d 00000001 /f
#If model is Lenovo 82J1/82HY - RoboCopy drv pack from USB to C:\drivers
$models = "82J1","82HY"
if ((Get-CimInstance win32_computersystem).Model -cin $models) {
    Write-Host  -ForegroundColor Green "Applying Lenovo 100w Gen 3 / 300w Gen 3 driverpack to OS..."
    Start-Process -FilePath "RoboCopy.exe" -ArgumentList "D:\OSDCloud\DriverPacks\Lenovo C:\drivers lnv_100w300w_gen3*.exe"
}
#Restart from WinPE
Write-Host  -ForegroundColor Green "Restarting in 20 seconds!"
Start-Sleep -Seconds 20
wpeutil reboot
