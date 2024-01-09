$SSID = "WifiSSID"  # Replace with your WiFi network name
$AudioFile = ".\alarm.wav"  # Replace with your sound file path
$ConnectionLost = $false
$AudioFile =  (New-Object Media.SoundPlayer $AudioFile)
Write-Host "Monitoring for connection to SSID: $SSID"

while ($true) {
    $ConnectedSSID = (Get-NetConnectionProfile).Name  
    if ($ConnectedSSID -ne $SSID) {
        $AudioFile.Play()
        $ConnectionLost = $true
        Write-Host "WiFi connection lost!"
    }
    elseif ($ConnectionLost) {
        Write-Host "WiFi connection restored."
        $AudioFile.Stop()
        $ConnectionLost = $false
    }
    Start-Sleep -Seconds 5  # Check every 5 seconds (adjust as needed)
}