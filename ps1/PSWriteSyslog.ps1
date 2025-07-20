<#
.SYNOPSIS
    Sends structured JSON log entries over TCP to a remote syslog server.

.DESCRIPTION
    The PSWriteSyslog function logs event data as a compact JSON object
    and transmits it over a raw TCP socket to a specified syslog collector.
    It supports centralized logging, traceability, and system auditing.

.PARAMETER ServerName
    Hostname of the machine generating the log entry. Defaults to local computer name.

.PARAMETER Service
    Logical name of the service or application. Used for categorization.

.PARAMETER Process
    Name of the script, executable, or subsystem generating the event.

.PARAMETER Action
    Describes the operation being performed.

.PARAMETER Result
    Outcome of the operation (e.g., "Success", "Failure").

.PARAMETER Message
    Custom message text providing additional context.

.PARAMETER SyslogHost
    IP address or DNS name of the destination syslog server.

.PARAMETER SyslogPort
    TCP port used for syslog input. Defaults to 514.

.PARAMETER Category
    Optional categorization tag, e.g., "Security", "System", "Audit".
    
.PARAMETER User
    Username associated with the event context.

.EXAMPLE
    PSWriteSyslog -Service "BackupAgent" -Process "NightlyRun" `
        -Action "Start" -Result "OK" -Message "Backup process triggered."
#>

function PSWriteSyslog {

    param (
        [string]$ServerName = $env:COMPUTERNAME,
        [string]$Service = "GenericService",
        [string]$Process = "GenericProcess",
        [string]$Action = "unspecified",
        [string]$Result = "undefined",
        [string]$Message = "generic message",
        [string]$SyslogHost = "127.0.0.1",
        [int]$SyslogPort = 514,
        [string]$Category = "undefined",
        [string]$User = $env:USERNAME
    )

    $Timestamp = (Get-Date).ToString("yyyy-MM-ddTHH:mm:ssZ")

    $payload = @{
        timestamp    = $Timestamp
        service      = $Service
        process      = $Process
        server       = $ServerName
        action       = $Action
        result       = $Result
        message      = $Message
        category     = $Category
        user         = $User
        version      = "1.0"
    } | ConvertTo-Json -Depth 2 -Compress

    try {
        $tcpClient = New-Object System.Net.Sockets.TcpClient
        $tcpClient.Connect($SyslogHost, $SyslogPort)

        $stream = $tcpClient.GetStream()
        $writer = New-Object System.IO.StreamWriter($stream)
        $writer.AutoFlush = $true

        $writer.WriteLine($payload)

        $writer.Close()
        $stream.Close()
        $tcpClient.Close()
    }
    catch {
        Write-Warning "Failed to send log: $_"
    }
}
