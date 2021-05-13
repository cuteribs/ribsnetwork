$myPath = $MyInvocation.MyCommand.Path;
$jobName = "BingDailyWallpaper"
$job = Get-ScheduledJob | Where-Object Name -eq $jobName

if (($Args.Length -gt 0) -And ($Args[0] -eq "uninstall")) {
    if ($job) {
        Unregister-ScheduledJob -Name $jobName
    }
    
    Write-Host("$jobName job removed")
    Exit
}

if (-Not ($job)) {
    $job = Register-ScheduledJob -Name $jobName -FilePath $myPath
    $trigger1 = New-JobTrigger -Daily -At 00:00
    $trigger2 = New-JobTrigger -Daily -At 12:00
    Add-JobTrigger -Trigger $trigger1 -Name $jobName
    Add-JobTrigger -Trigger $trigger2 -Name $jobName
    Write-Host("$jobName job added")
}
