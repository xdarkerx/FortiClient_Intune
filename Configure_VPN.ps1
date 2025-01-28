#log
$logDir = "C:\IntuneLogs\FortiClient\Configure_VPN_Logs"
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

Write-Log "Iniciando instalação do FortiClient..."

# Remove conexões antigas (comente caso deseja manter tuneis antigos)
Remove-Item -Path HKLM:\SOFTWARE\Fortinet\FortiClient\Sslvpn -Recurse -Force -ErrorAction SilentlyContinue

New-Item -Path HKLM:\SOFTWARE\Fortinet\FortiClient\Sslvpn -Force
Write-Log "Chave base criada em HKLM:\SOFTWARE\Fortinet\FortiClient\Sslvpn"

# Propriedade do Software Forticlient
Set-ItemProperty HKLM:\SOFTWARE\Fortinet\FortiClient\Sslvpn -Name log_level_daemon -Value "1" -Type Dword # Logs
Set-ItemProperty HKLM:\SOFTWARE\Fortinet\FortiClient\Sslvpn -Name log_level_gui -Value "1" -Type Dword # Logs
Set-ItemProperty HKLM:\SOFTWARE\Fortinet\FortiClient\Sslvpn -Name no_warn_invalid_cert -Value "0" -Type Dword # Avisar se o certificado for invalido
Set-ItemProperty HKLM:\SOFTWARE\Fortinet\FortiClient\Sslvpn -Name PreferDtlsTunnel -Value "0" -Type Dword # Tunel
Write-Log "Valores de configuração do FortiClient definidos."

New-Item -Path HKLM:\SOFTWARE\Fortinet\FortiClient\Sslvpn\Tunnels -Force
Write-Log "Chave Tunnels criada em HKLM:\SOFTWARE\Fortinet\FortiClient\Sslvpn\Tunnels"

#Particularidade de cada Tunel
$tunnels = @(
        @{ Name = "Nome"; Server = "Servidor.remoto"; Description = "Descrição"; Sso =  "1" },
        @{ Name = "Nome"; Server = "Servidor.remoto"; Description = "Descrição"; Sso =  "1" }
)

foreach ($tunnel in $tunnels) {
        $tunnelPath = "HKLM:\SOFTWARE\Fortinet\FortiClient\Sslvpn\Tunnels\$($tunnel.Name)"
        New-Item -Path $tunnelPath -Force
        Set-ItemProperty -Path $tunnelPath -Name DATA1 -Value "" -Type String
        Set-ItemProperty -Path $tunnelPath -Name DATA3 -Value "" -Type String
        Set-ItemProperty -Path $tunnelPath -Name Description -Value $tunnel.Description -Type String
        Set-ItemProperty -Path $tunnelPath -Name Server -Value $tunnel.Server -Type String
        Set-ItemProperty -Path $tunnelPath -Name dual_stack -Value "0" -Type Dword
        Set-ItemProperty -Path $tunnelPath -Name promptcertificate -Value "0" -Type Dword
        Set-ItemProperty -Path $tunnelPath -Name promptusername -Value "0" -Type Dword
        Set-ItemProperty -Path $tunnelPath -Name sso_enabled -Value $tunnel.Sso -Type Dword
        Set-ItemProperty -Path $tunnelPath -Name use_external_browser -Value "0" -Type Dword
        Set-ItemProperty -Path $tunnelPath -Name ServerCert -Value "0" -Type Dword
        Set-ItemProperty -Path $tunnelPath -Name azure_auto_login -Value "0" -Type Dword
        Write-Log "Configuração do Tunnel '$($tunnel.Name)' aplicada."
}

Write-Log "Configuração do FortiClient foi instalada com sucesso."


