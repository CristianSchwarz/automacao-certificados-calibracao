# Sistema de Automação da Emissão de Certificados de Calibração — AV04

Projeto acadêmico desenvolvido para o **Projeto Aplicado III — UniSENAI**, com o objetivo de automatizar o processamento demonstrativo de planilhas de calibração, a análise dos resultados e a geração de relatórios em PDF.

A solução utiliza Python e Flask para a aplicação web e serviços da AWS para hospedagem e armazenamento dos arquivos processados.

## Funcionalidades

- Importação de planilhas Excel nos formatos `.xlsx` e `.xlsm`.
- Processamento das abas `Importação` e `Report`, conforme as regras implementadas no MVP.
- Cálculo de limites, erros e classificação dos resultados.
- Geração de relatórios PDF demonstrativos.
- Histórico dos processamentos realizados.
- Consulta resumida de resultados por identificador.
- Geração de QR Code para acesso à consulta dos resultados.
- Armazenamento de planilhas, resultados em JSON e relatórios PDF no Amazon S3.

## Tecnologias utilizadas

- **Python 3.12** — linguagem de programação.
- **Flask** — desenvolvimento da aplicação web.
- **Pandas e OpenPyXL** — leitura e processamento de planilhas.
- **ReportLab** — geração de relatórios PDF.
- **qrcode e Pillow** — geração de QR Codes.
- **Bootstrap 5** — interface web.
- **Docker** — empacotamento da aplicação em contêiner.
- **Amazon ECR** — armazenamento da imagem Docker.
- **AWS Lambda** — execução da aplicação na nuvem.
- **AWS Lambda Web Adapter** — integração da aplicação Flask com o Lambda.
- **Amazon S3** — armazenamento dos arquivos de entrada e resultados.

## Arquitetura da solução

A aplicação é executada na AWS Lambda a partir de uma imagem Docker armazenada no Amazon ECR. O Amazon S3 é utilizado para armazenar os arquivos enviados e os resultados gerados.

Fluxo simplificado:

1. O usuário acessa a aplicação web.
2. Envia uma planilha Excel para processamento.
3. A aplicação analisa os dados e calcula os resultados conforme as regras implementadas.
4. É gerado um relatório PDF demonstrativo e um QR Code para consulta.
5. Os arquivos e resultados são armazenados no Amazon S3.
6. O usuário pode consultar o histórico e visualizar o resumo de um processamento.

### Serviços AWS

| Serviço | Finalidade |
|---|---|
| AWS Lambda | Execução da aplicação |
| Amazon ECR | Armazenamento da imagem Docker |
| Amazon S3 | Armazenamento das planilhas, resultados JSON e PDFs |
| AWS IAM | Controle de permissões de acesso |

**Região AWS:** `us-east-2` — Ohio.

## Estrutura de armazenamento no S3

O bucket utilizado no projeto é `calibracao-certificados-cristian-2026`.

Os arquivos são organizados pelos seguintes prefixos:

- `entradas-excel/` — planilhas enviadas para processamento.
- `resultados-json/` — resultados dos processamentos.
- `relatorios-pdf/` — relatórios PDF gerados.

O acesso ao bucket deve permanecer privado, com permissões concedidas conforme a necessidade da aplicação.

## Rotas principais

| Rota | Descrição |
|---|---|
| `/` | Página inicial para importar e processar uma planilha |
| `/historico` | Consulta do histórico de processamentos |
| `/consulta/<identificador>` | Consulta resumida de um processamento |
| `/qr/<identificador>.png` | Geração do QR Code correspondente |

## Como executar localmente

### Pré-requisitos

- Python 3.11 ou superior.
- Git, caso deseje clonar o repositório.
- Dependências listadas em `requirements.txt`.

### Instalação

Clone o repositório e acesse a pasta do projeto:

```bash
git clone https://github.com/CristianSchwarz/automacao-certificados-calibracao.git
cd automacao-certificados-calibracao
```

Crie e ative um ambiente virtual.

**Windows PowerShell:**

```powershell
python -m venv venv
.\venv\Scripts\Activate.ps1
```

Instale as dependências:

```bash
pip install -r requirements.txt
```

Configure as variáveis de ambiente necessárias, quando aplicável, utilizando o arquivo `.env.example` como referência.

Inicie a aplicação:

```bash
python app.py
```

Acesse o endereço local informado pelo Flask no terminal.

> A execução local sem configuração do S3 depende do comportamento previsto na aplicação. Para utilizar o armazenamento em nuvem, configure o perfil ou as credenciais AWS apropriadas e as permissões necessárias.

## Configuração e segurança na AWS

Na implantação em nuvem, a aplicação utiliza a função IAM associada à AWS Lambda para acessar os recursos necessários.

A variável de ambiente utilizada para identificar o bucket é:

```text
S3_BUCKET_NAME=calibracao-certificados-cristian-2026
```

A região é `us-east-2` e é disponibilizada pelo ambiente AWS. Não é necessário definir manualmente uma variável `AWS_REGION` na Lambda quando ela já é fornecida pelo serviço.

As permissões devem ser limitadas aos recursos utilizados pelo projeto. Credenciais AWS não devem ser incluídas no código-fonte, no arquivo `.env` ou no repositório GitHub.

## Testes realizados

Foram realizados testes funcionais da aplicação publicada, contemplando:

- Acesso à aplicação na nuvem.
- Envio e processamento de planilhas Excel.
- Geração de relatórios PDF.
- Geração e consulta por QR Code.
- Consulta do histórico de processamentos.
- Verificação do armazenamento dos arquivos no Amazon S3.

## Limitação metrológica

Os documentos PDF gerados nesta aplicação são **relatórios demonstrativos acadêmicos** e não constituem certificados metrológicos oficiais.

As regras de cálculo implementadas no MVP devem ser validadas com o docente e com os critérios técnicos aplicáveis antes de qualquer utilização operacional.

## Considerações finais

O projeto demonstra a integração de uma aplicação web em Python com serviços de computação, contêineres e armazenamento em nuvem da AWS. A solução busca reduzir etapas manuais no processamento demonstrativo de planilhas e organizar os resultados para consulta posterior.

---

**Projeto:** Automação da Emissão de Certificados de Calibração — AV04  
**Instituição:** UniSENAI  
**Repositório:** https://github.com/CristianSchwarz/automacao-certificados-calibracao
