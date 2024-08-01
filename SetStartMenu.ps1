#get machine username, user has to be logged in or the hive might not be mounted
$SID = & ".\SIDget\GetSID.ps1"
Write-Host $SID
#Start menu editing
add-content 'C:\treeline_files\NewHireMenu.xml' $StartLayoutStr
Import-StartLayout -LayoutPath "C:\treeline_files\NewHireMenu.xml" -MountPath C:\
New-Item -Path "Registry::HKEY_USERS\$SID\SOFTWARE\Policies\Microsoft\Windows" -Name Explorer -ErrorAction SilentlyContinue
Reg Add "Registry::HKEY_USERS\$SID\SOFTWARE\Policies\Microsoft\Windows\Explorer" /V LockedStartLayout /T REG_DWORD /D 1 /F
Reg Add "Registry::HKEY_USERS\$SID\SOFTWARE\Policies\Microsoft\Windows\Explorer" /V StartLayoutFile /T REG_EXPAND_SZ /D 'C:\treeline_files\NewHireMenu.xml' /F
Stop-Process -ProcessName explorer
Start-Sleep -s 10
#sleep is to let explorer finish restart b4 deleting reg keys
Remove-ItemProperty -Path "Registry::HKEY_USERS\$SID\SOFTWARE\Policies\Microsoft\Windows\Explorer" -Name "LockedStartLayout" -Force
Remove-ItemProperty -Path "Registry::HKEY_USERS\$SID\SOFTWARE\Policies\Microsoft\Windows\Explorer" -Name "StartLayoutFile" -Force
Stop-Process -ProcessName explorer