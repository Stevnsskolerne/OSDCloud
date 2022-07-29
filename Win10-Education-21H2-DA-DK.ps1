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

#Replace OSD.WinPE.ps1 with custom version from github - (WinPE)
#Get file from github
Write-Host -ForegroundColor Green "Requesting custom PowerShell files from GitHub..."
Invoke-WebRequest -Uri https://raw.githubusercontent.com/Stevnsskolerne/OSDCloud/dev/OSD.WinPE.ps1 -OutFile $env:TEMP\OSD.WinPE.ps1
Start-Sleep -Seconds 20
#Get path to OSD module on X:
Write-Host -ForegroundColor Green "Getting OSD module path..."
$modPath = (Get-Module -Name OSD -ListAvailable).ModuleBase
$modPath
Start-Sleep -Seconds 20
#Make path to latest version of module and add public to path
Write-Host -ForegroundColor Green "Calculating path..."
$modReplacePath = $modPath[0] + "\Public"
$modReplacePath
Start-Sleep -Seconds 20
#Copy ps from temp to replacement path
Write-Host -ForegroundColor Green "Moving file from" + $env:TEMP + "to" + $modReplacePath
Copy-Item -Path $env:TEMP\OSD.WinPE.ps1 -Destination $modReplacePath -Force -Verbose
Start-Sleep -Seconds 20

#Start OSDCloud ZTI the RIGHT way
Write-Host  -ForegroundColor Green "Start OSDCloud"
Start-OSDCloud -OSVersion 'Windows 10' -OSBuild 21H2 -OSEdition Education -OSLanguage da-dk -OSLicense Volume -Firmware -ZTI

#Clean up ESD files
Write-Host  -ForegroundColor Green "Removing ESD files..."
Remove-Item -Path C:\OSDCloud\OS\*.esd -Recurse -Force
#Replace OSD.WinPE.ps1 with custom version from github - (Win)
Copy-Item -Path $env:TEMP\OSD.WinPE.ps1 -Destination "C:\Program Files\WindowsPowerShell\Modules\OSD\22.7.12.1\Public" -Force -Verbose
#Patch reg for TPM to function 
#Write-Host  -ForegroundColor Green "Patching registry for TPM fuctionality..."
#reg add HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Setup\OOBE /v SetupDisplayedEula /t REG_DWORD /d 00000001 /f
#Restart from WinPE
Write-Host  -ForegroundColor Green "Restarting in 20 seconds!"
Start-Sleep -Seconds 20
wpeutil reboot
