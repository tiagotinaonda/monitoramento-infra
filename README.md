# monitoramento-infra
# Export TCP Connections with Process Info and Remote Hostnames (PowerShell)

Este script PowerShell coleta todas as conexões TCP ativas da máquina, resolve os nomes dos hosts remotos (quando aplicável), anexa informações de processo (PID e nome), e exporta os dados para um arquivo de texto UTF-8.

---

## 🛠️ Requisitos

- Windows PowerShell 5.1 ou superior
- Permissões para rodar `Get-Process` e `Get-NetTCPConnection`
- Acesso à internet (para resolver DNS externos, se aplicável)

---

## 📦 O que o script faz

Para cada conexão listada por `Get-NetTCPConnection`, o script:

- Obtém o nome do processo (`ProcessName`) pelo `OwningProcess`
- Resolve o nome do host remoto (`RemoteHost`) se o IP for válido e não for `localhost`
- Formata os dados como um objeto com as seguintes colunas:
  - `LocalAddress`
  - `LocalPort`
  - `RemoteAddress`
  - `RemoteHost`
  - `RemotePort`
  - `State`
  - `ProcessName`
  - `PID`
- Ordena a saída por `LocalPort`
- Salva em `C:\temp\export.txt` com codificação UTF-8

---

## 📜 Exemplo de Uso

```powershell
Get-NetTCPConnection | ForEach-Object {
    $proc = Get-Process -Id $_.OwningProcess -ErrorAction SilentlyContinue

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
        ProcessName   = $proc.ProcessName
        PID           = $_.OwningProcess
    }
} | Sort-Object LocalPort | Out-File -FilePath "C:\temp\export.txt" -Encoding UTF8


##Exemplo de saida

LocalAddress : 0.0.0.0
LocalPort    : 8080
RemoteAddress: 172.16.0.10
RemoteHost   : server.internal.domain
RemotePort   : 53784
State        : Listen
ProcessName  : myservice
PID          : 1234



##para converter o resultado em uma planilha utilize o scrip convert.py