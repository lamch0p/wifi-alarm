﻿
# wifi-alarm.ps1

## Description

This PowerShell script actively monitors the status of a specified WiFi connection, logs any detected outages, and optionally plays an audible alarm when disconnections occur within a defined time window. It's designed to run as a scheduled task, ensuring continuous monitoring even when a user isn't actively logged in.

## Parameters

- ssid: (Required) The SSID of the WiFi network to monitor.
- pollSeconds: (Optional) The interval in seconds between each monitoring loop. Defaults to 1 second.
- outageThreshold: (Optional) The duration in seconds after which a disconnection is considered an outage. Defaults to 0 seconds. Increasing this value can help reduce false alarms.
- audioFilename: (Optional) The name of a WAV audio file within the res/audio folder to play as the alarm. Defaults to alarm.wav.
- startTime: (Optional) The start time of the alarm window, in 24-hour HH:mm format. Must be used together with -endTime.
- endTime: (Optional) The end time of the alarm window, in 24-hour HH:mm format. Must be used together with -startTime.
- outputLog: (Optional) Switch to enable logging outage events to a CSV file within a logs folder (created automatically). Disabled by default.
- verbose: (Optional) Switch to enable real-time log messages in the terminal. Useful for debugging. Disabled by default.
## Usage Instructions (TBD)

Schedule the Script:
Open Task Scheduler.
Create a new task.
... (Provide detailed steps for scheduling the script to run on user login)
## Expected Output

Logging: If enabled, daily log files will be generated within the logs folder, containing outage events (SSID, detection time, restoration time, duration).
Verbose Output: If enabled, real-time status messages will be displayed in the terminal, indicating monitoring status and outage details.
## Error Handling (TBD)

## Additional Information

Dependencies: None
Author: (Your Name or Contact Information)
Version History: (Optional)
