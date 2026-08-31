param(
    [string]$Porta = 'COM6',
    [int]$BaudRate = 115200,
    [string]$Arquivo = 'tmp/monitor-serial-bluepulse.log'
)

$ErrorActionPreference = 'Stop'

$monitorExe = Join-Path $env:LOCALAPPDATA 'Arduino15\packages\builtin\tools\serial-monitor\0.15.0\serial-monitor.exe'
if (-not (Test-Path -LiteralPath $monitorExe)) {
    throw "Monitor serial do Arduino não encontrado em: $monitorExe"
}

$arquivoAbsoluto = if ([IO.Path]::IsPathRooted($Arquivo)) {
    $Arquivo
} else {
    Join-Path (Get-Location) $Arquivo
}

$pasta = Split-Path -Parent $arquivoAbsoluto
New-Item -ItemType Directory -Force -Path $pasta | Out-Null

$listener = [Net.Sockets.TcpListener]::new([Net.IPAddress]::Loopback, 0)
$processo = $null
$cliente = $null
$leitor = $null
$gravador = $null

function Enviar-ComandoMonitor([string]$Comando) {
    $processo.StandardInput.WriteLine($Comando)
    $processo.StandardInput.Flush()
    $linhas = [Collections.Generic.List[string]]::new()
    do {
        $linhaResposta = $processo.StandardOutput.ReadLine()
        if ($null -eq $linhaResposta) {
            throw "O monitor encerrou ao receber: $Comando"
        }
        $linhas.Add($linhaResposta)
    } while ($linhaResposta.Trim() -ne '}')

    $resposta = $linhas -join [Environment]::NewLine
    $evento = $resposta | ConvertFrom-Json
    if ($evento.message -ne 'OK') {
        throw "Falha do monitor em '$Comando': $($evento.message)"
    }
    Write-Host "MONITOR_OK comando=$Comando"
}

try {
    $listener.Start()
    $portaTcp = ([Net.IPEndPoint]$listener.LocalEndpoint).Port

    $inicio = [Diagnostics.ProcessStartInfo]::new()
    $inicio.FileName = $monitorExe
    $inicio.UseShellExecute = $false
    $inicio.RedirectStandardInput = $true
    $inicio.RedirectStandardOutput = $true
    $inicio.RedirectStandardError = $true
    $inicio.CreateNoWindow = $true
    $processo = [Diagnostics.Process]::Start($inicio)

    Enviar-ComandoMonitor 'HELLO 1 "bluepulse-capture"'
    Enviar-ComandoMonitor "CONFIGURE baudrate $BaudRate"
    Enviar-ComandoMonitor 'CONFIGURE dtr off'
    Enviar-ComandoMonitor 'CONFIGURE rts off'
    Enviar-ComandoMonitor "OPEN 127.0.0.1:$portaTcp $Porta"

    $cliente = $listener.AcceptTcpClient()
    $leitor = [IO.StreamReader]::new($cliente.GetStream())
    $gravador = [IO.StreamWriter]::new($arquivoAbsoluto, $false, [Text.UTF8Encoding]::new($false))
    $gravador.AutoFlush = $true

    Write-Host "COLETA_SERIAL_ATIVA porta=$Porta arquivo=$arquivoAbsoluto"
    while (($linha = $leitor.ReadLine()) -ne $null) {
        if ($linha -match '^SEQ=') {
            $gravador.WriteLine($linha)
            Write-Host $linha
        }
    }
} finally {
    if ($null -ne $gravador) { $gravador.Dispose() }
    if ($null -ne $leitor) { $leitor.Dispose() }
    if ($null -ne $cliente) { $cliente.Dispose() }
    $listener.Stop()
    if ($null -ne $processo -and -not $processo.HasExited) {
        $processo.Kill()
        $processo.WaitForExit()
    }
}
