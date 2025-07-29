Get-NetTCPConnection | ForEach-Object {
    $proc = Get-Process -Id $_.OwningProcess -ErrorAction SilentlyContinue

    # Tenta resolver o hostname remoto, se o IP não for vazio e diferente de 127.0.0.1
    $remoteHost = $null
    if ($_.RemoteAddress -and $_.RemoteAddress -ne '127.0.0.1' -and $_.RemoteAddress -ne '::1') {
        try {
            $remoteHost = [System.Net.Dns]::GetHostEntry($_.RemoteAddress).HostName
        } catch {
            $remoteHost = 'N/A'
        }
    }

    [PSCustomObject]@{
        LocalAddress = $_.LocalAddress
        LocalPort    = $_.LocalPort
        RemoteAddress = $_.RemoteAddress
        RemoteHost   = $remoteHost
        RemotePort   = $_.RemotePort
        State        = $_.State
        ProcessName  = $proc.ProcessName
        PID          = $_.OwningProcess
    }
} | Sort-Object LocalPort |out-file -FilePath "C:\temp\export.txt" -Encoding UTF8
