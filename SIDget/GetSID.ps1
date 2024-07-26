$GetUsername = Get-WMIObject -class Win32_ComputerSystem | Select-Object -ExpandProperty username
$ConvToSSP = New-Object System.Security.Principal.NTAccount($GetUsername)
$SID = $ConvToSSP.Translate([System.Security.Principal.SecurityIdentifier]).Value
return $SID