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
1. Open Task Scheduler.
2. Create a Basic Task...
3. Fill out the required fields, stepping through the task creation.
4. Recommended settings
   - Run whether user is logged on or not (Do not store password. The task will only have access to local computer resources.)
   - Run Trigger 'At Startup'
   - Action 'Start a Program'
     - Program/script: C:\Windows\System32\WindowsPowerShell\v1.0\powershell.exe (64-bit)
     - Add arguments: -ExecutionPolicy Bypass -File "C:\path\to\wifi-alarm\wifi-alarm.ps1" -ssid {YOUR_SSID} -outputLog -outageThreshold 3
     - Start in: C:\path\to\wifi-alarm
   - Conditions (all options should be disabled, except)
     - Wake the computer to run this task.
    - Settings
       - Allow task to be run on demand
       - If the running task does not end when requested, force it to stop
       - If the task is already running, then the following rule applies: 'Do not start a new instance'

## Expected Output

Logging: If enabled, daily log files will be generated within the logs folder, containing outage events (SSID, detection time, restoration time, duration).
Verbose Output: If enabled, real-time status messages will be displayed in the terminal, indicating monitoring status and outage details.
## Error Handling (TBD)

## Additional Information

- Dependencies: None
- Author: @lamch0p
- Version History: v0.0.1

## Purpose

- Monitors a specified WiFi connection for disconnection events.
- Raises an audible alarm when a disconnection occurs, optionally within a specified time window.
- Logs outage events to a CSV file if enabled.

## Key Features

- **Parameterization:** Allows customization of various settings through parameters.
- **Alarm control:** Plays a specified audio file when an outage is detected, obeying alarm window restrictions.
- **Logging:** Generates CSV files with outage details for analysis.
- **Verbose output:** Provides optional real-time status updates for debugging.

## Code Structure

1. **Parameters:** Defines input options for the script's behavior.
2. **Functions:**
    - DoAlarm controls audio playback based on outage conditions and time window.
    - WriteHost provides optional verbose output if enabled.
3. **Main Logic:**
    - Validates SSID input.
    - Configures logging if enabled.
    - Sets up audio file path and player.
    - Initializes variables for tracking disconnection status and duration.
    - Enters a continuous monitoring loop:
        - Checks current WiFi connection status.
        - If disconnected and meets outage conditions:
            - Records outage details.
            - Triggers the alarm (if within time window).
        - If reconnected:
            - Stops the alarm.
            - Logs outage event details (if logging enabled).
            - Resets outage tracking variables.
        - Pauses for the specified polling interval.

## Additional Notes

- The script is designed to run continuously as a scheduled task or background process.
- It provides flexibility through parameters for customization and debugging.
- Consider incorporating error handling and edge case management for robustness.
