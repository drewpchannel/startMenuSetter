if (Test-Path -Path .\sms)
{
    Remove-Item -Path .\sms -Recurse
}

if (Test-Path -Path .\sms.zip)
{
    Remove-Item -Path .\sms.zip
}

#get files from GitHub
Invoke-WebRequest https://github.com/drewpchannel/startMenuSetter/archive/refs/heads/main.zip -OutFile .\sms.zip
Expand-Archive .\sms.zip -Force

#get machine username, user has to be logged in or the hive might not be mounted
$SID = & ".\sms\startMenuSetter-main\SIDget\GetSID.ps1"

$filePath = Resolve-Path ".\sms\startMenuSetter-main"

#Start menu editing
Import-StartLayout -LayoutPath "$filePath\NewHireMenu.xml" -MountPath C:\
if (-Not (Test-Path -Path "Registry::HKEY_USERS\$SID\SOFTWARE\Policies\Microsoft\Windows\Explorer"))
{
    New-Item -Path "Registry::HKEY_USERS\$SID\SOFTWARE\Policies\Microsoft\Windows" -Name Explorer
}

Set-ItemProperty -Path "Registry::HKEY_USERS\$SID\SOFTWARE\Policies\Microsoft\Windows\Explorer" -Name "LockedStartLayout" -Value 1 -Type DWord -Force
Set-ItemProperty -Path "Registry::HKEY_USERS\$SID\SOFTWARE\Policies\Microsoft\Windows\Explorer" -Name "StartLayoutFile" -Value "$filePath\NewHireMenu.xml" -Type ExpandString -Force
Stop-Process -ProcessName explorer -Force
Start-Sleep -s 10
#sleep is to let explorer finish restart b4 deleting reg keys
Remove-ItemProperty -Path "Registry::HKEY_USERS\$SID\SOFTWARE\Policies\Microsoft\Windows\Explorer" -Name "LockedStartLayout" -Force
Remove-ItemProperty -Path "Registry::HKEY_USERS\$SID\SOFTWARE\Policies\Microsoft\Windows\Explorer" -Name "StartLayoutFile" -Force
Stop-Process -ProcessName explorer -Force

Remove-Item -Path .\sms.zip