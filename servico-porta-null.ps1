Get-NetTCPConnection | ForEach-Object {
    $proc = $null
    $procName = 'N/A'

    if ($_.OwningProcess) {
        try {
            $proc = Get-Process -Id $_.OwningProcess -ErrorAction SilentlyContinue
            if ($proc) {
                $procName = $proc.ProcessName
            }
        } catch {
            $procName = 'N/A'
        }
    }

    # Tenta resolver o hostname remoto
    $remoteHost = $null
    if ($_.RemoteAddress -and $_.RemoteAddress -ne '127.0.0.1' -and $_.RemoteAddress -ne '::1') {
        try {
            $remoteHost = [System.Net.Dns]::GetHostEntry($_.RemoteAddress).HostName
        } catch {
            $remoteHost = 'N/A'
        }
    }

    [PSCustomObject]@{
        LocalAddress  = $_.LocalAddress
        LocalPort     = $_.LocalPort
        RemoteAddress = $_.RemoteAddress
        RemoteHost    = $remoteHost
        RemotePort    = $_.RemotePort
        State         = $_.State
        ProcessName   = $procName
        PID           = $_.OwningProcess
    }
} | Sort-Object LocalPort | Out-File -FilePath "C:\temp\export.txt" -Encoding UTF8
