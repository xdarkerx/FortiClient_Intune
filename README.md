# FortiClient_Intune

**Intune Script to Deploy FortiClient Configuration**

Este repositório contém um script para implantação da configuração do FortiClient utilizando o Microsoft Intune.

### Como Configurar o Script

1. **Editar o Script de Configuração**:  
   Personalize o script de configuração de acordo com os parâmetros da sua VPN.

2. **Preparação para Deploy no Intune**:  
   Para configurar o deploy no Intune, baixe a ferramenta `apps-win32-prepare` através do link [Microsoft Intune Win32 App Packaging Tool](https://learn.microsoft.com/en-us/mem/intune/apps/apps-win32-prepare).  
   Em seguida, crie uma pasta chamada `FortiClient_Config` onde você armazenará o arquivo de configuração e o script.

3. **Configuração do Intune**:  
   Ao adicionar o pacote no Intune, configure os parâmetros conforme a sua necessidade.

### Observações

- Verifique as permissões e políticas de segurança para garantir que o script tenha as permissões necessárias para executar a configuração no dispositivo.
- O script pode ser adaptado para diferentes cenários e necessidades de VPN, por isso, ajuste-o conforme necessário para seu ambiente específico.
