function Is-Admin {
    $myWindowsID = [System.Security.Principal.WindowsIdentity]::GetCurrent();
    $myWindowsPrincipal = New-Object System.Security.Principal.WindowsPrincipal($myWindowsID);
    $adminRole = [System.Security.Principal.WindowsBuiltInRole]::Administrator;

    if (!$myWindowsPrincipal.IsInRole($adminRole))
    {
        throw '请使用管理员权限运行'
    }
}

Is-Admin

function Get-Device {
    return Get-PnpDevice -PresentOnly `
		| where-object {$_.Status -eq 'OK' -and $_.Class -cin $classes -and $_.InstanceId.Remove($_.InstanceId.IndexOf('\')).Trim() -cin $categories } `
		| sort-object -property Class, InstanceId `
		| select Class, FriendlyName, @{n='HardwareIDs';e={[System.String]::Join('|', $_.HardwareID)}}, InstanceId
}

function List-Device() {
	$devices | select @{n='编号';e={$devices.IndexOf($_)}}, @{n='类型';e={$_.Class}}, @{n='名称';e={$_.FriendlyName}} | ft
}

function Rename-Device([int16]$index, [string]$newName) {
	$device = $devices[$index]
	[string]$path = "HKEY_LOCAL_MACHINE\SYSTEM\ControlSet001\Enum\$($device.InstanceId)"
    [string]$result = (REG ADD $path /v FriendlyName /t REG_SZ /d $newName /f)
    Write-Output $result
}

function Run {
    List-Device
    [int16]$inputIndex = read-host "请输入要修改的设备编号"
    [string]$inputName = read-host "请输入要新的设备名称"
    Rename-Device -index $inputIndex -newName $inputName
    $devices = Get-Device
    Run
}

$classes = @("Bluetooth", "DiskDrive", "Display", "Keyboard", "MEDIA", "Monitor", "Mouse", "Net", "Processor")
$categories = @("ACPI", "BTHENUM", "BTHLE", "HDAUDIO", "HID", "PCI", "SCSI", "USB")
$devices = Get-Device
Run





	
	
