# Sistema de Calibração de Instrumentos — AV04 (versão inicial)

Projeto acadêmico do Projeto Aplicado III, com foco na importação e análise demonstrativa de planilhas de calibração.

## Funcionalidades existentes e incluídas nesta versão

- Importação de planilhas Excel `.xlsx` e `.xlsm`.
- Processamento das abas `Importação` e `Report` conforme as regras existentes no MVP.
- Cálculo de limites, erros e classificação dos resultados.
- Geração de relatório PDF demonstrativo.
- **Novo:** página de histórico dos processamentos guardados localmente.
- **Novo:** página de consulta resumida acessível por QR Code.
- **Novo:** geração do QR Code de consulta após processar uma planilha.

## Tecnologias

- Python
- Flask
- Pandas e OpenPyXL
- ReportLab
- qrcode / Pillow
- Bootstrap 5 para a interface

## Como executar localmente

1. Instale Python 3.11 ou superior.
2. Abra um terminal nesta pasta.
3. Crie e ative um ambiente virtual:

   ```bash
   python -m venv venv
   ```

   Windows PowerShell:

   ```powershell
   .\venv\Scripts\Activate.ps1
   ```

4. Instale as dependências:

   ```bash
   pip install -r requirements.txt
   ```

5. Inicie a aplicação:

   ```bash
   python app.py
   ```

6. Acesse o endereço local mostrado no terminal pelo Flask.

## Rotas principais

- `/` — importar e processar uma planilha.
- `/historico` — visualizar processamentos salvos nesta instância.
- `/consulta/<identificador>` — consultar o resumo de um processamento.
- `/qr/<identificador>.png` — gerar o QR Code de consulta.

## Situação da AV04

Esta versão mantém o modo local e inclui uma integração opcional com S3 para planilhas, resultados JSON e PDFs. **Ainda não é o deploy da AV04.** É necessário configurar as variáveis de ambiente e permissões AWS, testar a integração na conta e preparar um ambiente de hospedagem compatível antes de considerar a aplicação publicada.

O QR Code utiliza o endereço base pelo qual o usuário acessa a aplicação. Em execução local, ele não será acessível de outros dispositivos se apontar para `127.0.0.1`/`localhost`. Para leitura pelo celular, a aplicação deve estar acessível pela rede local usando o IP do computador ou publicada na nuvem.

## Limitação metrológica importante

O PDF é um **relatório demonstrativo acadêmico**, não um certificado metrológico oficial. As regras de cálculo já existentes no MVP devem ser confirmadas com o docente e com os critérios técnicos aplicáveis antes de qualquer uso operacional.

## Integração opcional com Amazon S3

A aplicação continua funcionando localmente quando `S3_BUCKET_NAME` não está definido. Para habilitar o armazenamento no S3, configure as variáveis de ambiente no ambiente de execução:

- `S3_BUCKET_NAME=calibracao-certificados-cristian-2026`
- `AWS_REGION=us-east-2`

Com o bucket configurado, a aplicação envia planilhas para `entradas-excel/`, os resultados JSON para `resultados-json/` e os PDFs para `relatorios-pdf/`. O prefixo `resultados-json/` é criado automaticamente quando o primeiro resultado é gravado; não é necessário criar uma pasta manualmente no console.

### Permissões AWS

O usuário ou papel de execução precisa de permissões limitadas ao bucket do projeto para `s3:PutObject`, `s3:GetObject` e `s3:ListBucket`. Não habilite acesso público ao bucket. Em hospedagem AWS, prefira um papel IAM de execução em vez de armazenar chaves de acesso no código ou no repositório. Para desenvolvimento local, use um perfil AWS configurado na máquina, se necessário.

### Importante sobre a hospedagem

A integração com o S3 não publica o site automaticamente. A aplicação ainda é Flask e precisa de um ambiente de hospedagem compatível. Antes de criar outros serviços AWS, confira a elegibilidade do plano gratuito, os limites e os custos aplicáveis à conta.
