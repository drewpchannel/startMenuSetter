$treelineFilePath = "c:\treeline_files"

#Setup Folder
if (-not (Test-Path -Path $treelineFilePath))
{
    New-Item -Path $treelineFilePath -ItemType Directory | Out-Null
}

if (Test-Path -Path $treelineFilePath\sms.zip)
{
    Remove-Item -Path $treelineFilePath\sms.zip
}

#get files from GitHub
Invoke-WebRequest https://github.com/drewpchannel/startMenuSetter/archive/refs/heads/main.zip -OutFile $treelineFilePath\sms.zip
Expand-Archive -Path "$treelineFilePath\sms.zip" -DestinationPath "$treelineFilePath" -Force

#get machine username, user has to be logged in or the hive might not be mounted
$SID = & "c:\treeline_files\startMenuSetter-main\SIDget\GetSID.ps1"
$pathAfterExtract = "c:\treeline_files\startMenuSetter-main\"

#Start menu editing
Import-StartLayout -LayoutPath "$pathAfterExtract\NewHireMenu.xml" -MountPath C:\
if (-Not (Test-Path -Path "Registry::HKEY_USERS\$SID\SOFTWARE\Policies\Microsoft\Windows\Explorer"))
{
    New-Item -Path "Registry::HKEY_USERS\$SID\SOFTWARE\Policies\Microsoft\Windows" -Name Explorer
}

Set-ItemProperty -Path "Registry::HKEY_USERS\$SID\SOFTWARE\Policies\Microsoft\Windows\Explorer" -Name "LockedStartLayout" -Value 1 -Type DWord -Force
Set-ItemProperty -Path "Registry::HKEY_USERS\$SID\SOFTWARE\Policies\Microsoft\Windows\Explorer" -Name "StartLayoutFile" -Value "$pathAfterExtract\NewHireMenu.xml" -Type ExpandString -Force
Stop-Process -ProcessName explorer -Force
Start-Sleep -s 10
#sleep is to let explorer finish restart b4 deleting reg keys
Remove-ItemProperty -Path "Registry::HKEY_USERS\$SID\SOFTWARE\Policies\Microsoft\Windows\Explorer" -Name "LockedStartLayout" -Force
Remove-ItemProperty -Path "Registry::HKEY_USERS\$SID\SOFTWARE\Policies\Microsoft\Windows\Explorer" -Name "StartLayoutFile" -Force
Stop-Process -ProcessName explorer -Force

exit 0