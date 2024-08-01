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
if (-Not (Test-Path -Path "Registry::HKEY_USERS\$SID\SOFTWARE\Policies\Microsoft\Windows"))
{
    New-Item -Path "Registry::HKEY_USERS\$SID\SOFTWARE\Policies\Microsoft\Windows" -Name Explorer
}

Reg Add "HKEY_USERS\$SID\SOFTWARE\Policies\Microsoft\Windows\Explorer" /V LockedStartLayout /T REG_DWORD /D 1 /F
Reg Add "HKEY_USERS\$SID\SOFTWARE\Policies\Microsoft\Windows\Explorer" /V StartLayoutFile /T REG_EXPAND_SZ /D "$filePath\NewHireMenu.xml" /F
Stop-Process -ProcessName explorer -Force
Start-Sleep -s 10
#sleep is to let explorer finish restart b4 deleting reg keys
Remove-ItemProperty -Path "Registry::HKEY_USERS\$SID\SOFTWARE\Policies\Microsoft\Windows\Explorer" -Name "LockedStartLayout" -Force
Remove-ItemProperty -Path "Registry::HKEY_USERS\$SID\SOFTWARE\Policies\Microsoft\Windows\Explorer" -Name "StartLayoutFile" -Force
Stop-Process -ProcessName explorer -Force

Remove-Item -Path .\sms.zip