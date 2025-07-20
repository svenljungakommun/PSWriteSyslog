# PSWriteSyslog — PowerShell JSON Syslog Logger (TCP)

`PSWriteSyslog` is a lightweight PowerShell function for structured logging to a remote syslog server over **TCP**, using compact JSON. Designed for automation, error reporting, audit trails, and telemetry.

---

## ✅ Features

- Sends structured JSON logs over raw TCP
- Works with syslog-ng, rsyslog, Graylog, etc.
- Zero dependencies – pure PowerShell
- Easily embeddable in scripts and jobs

---

## 🚀 Usage

```powershell
PSWriteSyslog -Service "MyApp" -Process "InitScript" -Action "Start" `
    -Result "Success" -Message "Startup complete" -Category "System"
````

---

## 📥 Parameters

| Name       | Description                         | Default             |
| ---------- | ----------------------------------- | ------------------- |
| ServerName | Hostname of the sending machine     | `$env:COMPUTERNAME` |
| Service    | Application or service name         | `"GenericService"`  |
| Process    | Subsystem or script name            | `"GenericProcess"`  |
| Action     | Action being logged                 | `"unspecified"`     |
| Result     | Outcome ("Success", "Error", etc.)  | `"undefined"`       |
| Message    | Human-readable message              | `"generic message"` |
| Category   | Tag or classification of event      | `"undefined"`       |
| User       | Identity of user running the script | `$env:USERNAME`     |
| SyslogHost | IP or FQDN of syslog server         | `"127.0.0.1"`       |
| SyslogPort | TCP port (standard 514 or custom)   | `514`               |

---

## 🔧 Customization

### ➕ Add fields

Extend the `$payload` object in `PSWriteSyslog`:

```powershell
$payload.environment = "production"
$payload.jobId = "abc123"
```

### 🔁 Use in automation

```powershell
try {
    Start-MyCriticalJob
    PSWriteSyslog -Action "MyCriticalJob" -Result "Success"
}
catch {
    PSWriteSyslog -Action "MyCriticalJob" -Result "Failure" -Message $_.Exception.Message
}
```

---

## 🧪 **example.ps1**

```powershell
. "$PSScriptRoot\PSWriteSyslog.ps1"

PSWriteSyslog -Service "Inventory" -Process "ScanJob" -Action "Run" `
    -Result "OK" -Message "Scan complete. No issues found." -Category "Maintenance"
````
