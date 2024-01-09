param(
    [string] $ssid,
    [int] $pollSeconds = 1,
    [int] $outageThreshold = 15,
    [string] $audioFilename,
    [string] $startTime,
    [string] $endTime,
    [switch] $outputLog = $false,
    [switch] $verbose = $false
)

function DoAlarm {
    if ($outageDuration -ge $outageThreshold ) {
        $currentTime = Get-Date -Format "HH:mm"
        # Check if the current time falls within the specified range
        if (($currentTime -ge $startTime -and $currentTime -le $endTime) -or ($startTime -eq "" -or $endTime -eq "")) {
            $audioFile.Play()
            return
        }
    }
    $audioFile.Stop()
}

function WriteHost {
    param(
        [string] $message,
        [Alias('m')] $messageAlias
    )
    if ($verbose) {
        Write-Host $messageAlias
    }
}

if (!$ssid) {
    Write-Error "No SSID provided. Exiting."
    exit 1
}

function ConfigureLogging {
    $date = Get-Date -Format "yyyy-MM-dd"
    $csvPath = ".\logs\$date-wifi-alarm-outage-log.csv"
    if (!(Test-Path $csvPath)) {
        if ($verbose) {
            New-Item $csvPath -ItemType File -Force
        }
        else {
            New-Item $csvPath -ItemType File -Force | Out-Null
        }
        $headers = [PSCustomObject]@{
            SSID     = $null
            Detected = $null
            Restored = $null
            Duration = $null
        }
        $headers | Export-Csv $csvPath -NoTypeInformation
    }
    return $csvPath
}

# Check if file exists
$filePath = [System.IO.Path]::Combine(".\res\audio", $audioFilename)

if ([System.IO.File]::Exists($filePath)) {
    WriteHost -m "Using audio file '$filePath'"
    $audioFile = (New-Object Media.SoundPlayer $filePath)
}
else {
    WriteHost -m "The audio file at '$filePath' does not exist. Using default audio file."
    $audioFile = (New-Object Media.SoundPlayer '.\res\audio\alarm.wav')
}

$wifiDisconnected = $false
$outageDuration = 0

Write-Host "Monitoring connection to SSID: $ssid"

$outageEvent = [PSCustomObject]@{ SSID = $null; Detected = $null; Restored = $null; Duration = $null }

while ($true) {
    if ($outputLog) {
        $csvPath = ConfigureLogging
    }
    $connectedSSID = (Get-NetConnectionProfile).Name 
    $outageEvent.SSID = $connectedSSID
    if ($wifiDisconnected) {
        $outageDuration += $pollSeconds
    }
    if ($connectedSSID -ne $ssid) {
        if (!$outageEvent.Detected) {
            $outageEvent.Detected = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
        }
        WriteHost -m "WiFi disconnected at $($outageEvent.Detected) ($outageDuration seconds)"
        $wifiDisconnected = $true 
        DoAlarm
    }
    elseif ($wifiDisconnected) {
        WriteHost -m "WiFi connection restored."
        $audioFile.Stop()
        $wifiDisconnected = $false
        $outageEvent.Restored = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
        $outageEvent.Duration = $outageDuration
        if ($outputLog) {
            $outageEvent | Export-Csv $csvPath -NoTypeInformation -Append
        }
        $outageEvent = [PSCustomObject]@{ SSID = $null; Detected = $null; Restored = $null; Duration = $null }
        $outageDuration = 0
    }
    Start-Sleep -Seconds $pollSeconds 
}

