# Log
$logDir = "C:\IntuneLogs\FortiClient\Remove_VPN"
$logFile = "$logDir\log_$(Get-Date -Format 'yyyy-MM-dd').txt"

if (-not (Test-Path $logDir)) {
    New-Item -Path $logDir -ItemType Directory -Force
}

function Write-Log {
    param (
        [string]$logMessage
    )
    $timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    $logMessage = "$timestamp - $logMessage"
    Write-Host $logMessage
    Add-Content -Path $logFile -Value "$logMessage"
}

Write-Log "Iniciando remoção da configuração do FortiClient..."

# Verificar e remover a chave de registro do FortiClient (SSL VPN)
$regPath = "HKLM:\SOFTWARE\Fortinet\FortiClient\Sslvpn"
if (Test-Path $regPath) {
    Remove-Item -Path $regPath -Recurse -Force
    Write-Log "Configuração do FortiClient foi removida com sucesso do registro."
} else {
    Write-Log "A chave de registro '$regPath' não foi encontrada. Nenhuma remoção necessária."
}

# Remove a tarefa agendada (se existir)
$taskName = "FortiClient_VPN_Configurator"
$existingTask = Get-ScheduledTask -TaskName $taskName -ErrorAction SilentlyContinue
if ($existingTask) {
    Write-Log "Removendo a tarefa agendada '$taskName'."
    Unregister-ScheduledTask -TaskName $taskName -Confirm:$false
    Write-Log "Tarefa agendada '$taskName' removida com sucesso."
} else {
    Write-Log "Nenhuma tarefa agendada encontrada com o nome '$taskName'."
}

# Remover os arquivos de configuração
$sourcePath = "C:\IntuneFiles\FortiClient\Configure_VPN.ps1"
if (Test-Path $sourcePath) {
    Write-Log "Removendo o arquivo de configuração $sourcePath."
    Remove-Item -Path $sourcePath -Force
    Write-Log "Arquivo de configuração removido com sucesso."
} else {
    Write-Log "Arquivo de configuração $sourcePath não encontrado."
}

Write-Log "Remoção completa da configuração do FortiClient."
