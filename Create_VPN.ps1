# Log
$logDir = "C:\IntuneLogs\FortiClient\Create_VPN_Logs"
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

#mover o arquivo de configura��o
function Move-ConfigFile {
    $sourcePath = Join-Path -Path $PSScriptRoot -ChildPath "Configure_VPN.ps1"
    $destinationPath = "C:\IntuneFiles\FortiClient\Configure_VPN.ps1"
    $destinationDir = [System.IO.Path]::GetDirectoryName($destinationPath)  # Pega o diret�rio de destino

    if (Test-Path $sourcePath) {
        Write-Log "Movendo o arquivo de configura��o para $destinationPath"
        
        
        if (-not (Test-Path $destinationDir)) {
            Write-Log "Criando diret�rio de destino: $destinationDir"
            New-Item -Path $destinationDir -ItemType Directory -Force
        }

        # Ler o conte�do do arquivo de origem com a codifica��o UTF-8
        $content = Get-Content -Path $sourcePath -Encoding UTF8
        
        Set-Content -Path $destinationPath -Value $content -Encoding UTF8
        
        Write-Log "Arquivo de configura��o movido com sucesso."
    } else {
        Write-Log "Arquivo de configura��o n�o encontrado no caminho original: $sourcePath"
        exit 1
    }
}

Move-ConfigFile

# Nome da Tarefa
$taskName = "FortiClient_VPN_Configurator"
$taskDescription = "Executa o script Configure_VPN.ps1 na inicializa��o do sistema."

$existingTask = Get-ScheduledTask -TaskName $taskName -ErrorAction SilentlyContinue
if ($existingTask) {
    Write-Log "A tarefa '$taskName' j� existe. Nenhuma nova tarefa ser� criada."
} else {
    # A��o para rodar o script Configure_VPN.ps1
    $taskAction = New-ScheduledTaskAction -Execute "Powershell.exe" -Argument "-ExecutionPolicy Bypass -File C:\IntuneFiles\FortiClient\Configure_VPN.ps1"

    $taskTrigger = New-ScheduledTaskTrigger -AtStartup

    $taskPrincipal = New-ScheduledTaskPrincipal -UserId "SYSTEM" -LogonType ServiceAccount

    Register-ScheduledTask -Action $taskAction -Trigger $taskTrigger -Principal $taskPrincipal -TaskName $taskName -Description $taskDescription
    Write-Log "Tarefa agendada para execu��o do script Configure_VPN.ps1 na inicializa��o criada com sucesso."
}

Write-Log "Iniciando a execu��o imediata da tarefa agendada '$taskName'."
Start-ScheduledTask -TaskName $taskName
Write-Log "Tarefa '$taskName' executada com sucesso."
