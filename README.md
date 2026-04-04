<div align="center">

# 🚀 Setup Vem Fazer

### Instalador Unificado de Ferramentas Open Source

[![Canal YouTube](https://img.shields.io/badge/YouTube-Vem%20Fazer-red?style=for-the-badge&logo=youtube)](https://www.youtube.com/@VemFazer)
[![License](https://img.shields.io/badge/License-MIT-blue?style=for-the-badge)](LICENSE)
[![Shell Script](https://img.shields.io/badge/Shell-Bash-green?style=for-the-badge&logo=gnu-bash)](setup-vemfazer.sh)
[![Tools](https://img.shields.io/badge/Ferramentas-81+-purple?style=for-the-badge)]()

Instale **+80 ferramentas open source** no seu servidor VPS com **um único comando**.

Desenvolvido por **Raphael Batista** — Canal [Vem Fazer](https://www.youtube.com/@VemFazer)

---

</div>

## ⚡ Instalação Rápida

```bash
sudo bash setup-vemfazer.sh
```

Ou execute diretamente da web:

```bash
bash <(curl -sSL https://raw.githubusercontent.com/SEU_USUARIO/setup-vemfazer/main/setup-vemfazer.sh)
```

---

## 📋 Requisitos Mínimos

| Requisito | Mínimo | Recomendado |
|-----------|--------|-------------|
| **SO** | Ubuntu 20.04 / Debian 11 | Ubuntu 22.04 LTS |
| **RAM** | 4 GB | 8 GB+ |
| **CPU** | 2 vCPUs | 4 vCPUs+ |
| **Disco** | 40 GB SSD | 80 GB+ SSD |
| **Rede** | IP público fixo | — |
| **Domínio** | Sim (com DNS apontando para o servidor) | Wildcard DNS (`*.seudominio.com`) |

> **Dica:** Configure um registro DNS wildcard (`*.seudominio.com → IP do servidor`) para que todos os subdomínios funcionem automaticamente.

---

## 🛠️ O que o instalador faz

1. **Verifica** os requisitos do sistema (RAM, CPU, SO)
2. **Instala** Docker e Docker Compose automaticamente
3. **Configura** o Traefik como proxy reverso com SSL (Let's Encrypt)
4. **Exibe** um menu interativo para você escolher as ferramentas
5. **Gera** senhas seguras automaticamente para cada serviço
6. **Cria** docker-compose individual em `/opt/vemfazer/<ferramenta>/`
7. **Sobe** os containers e exibe os links de acesso

---

## 📦 Ferramentas Disponíveis (81)

### 🔀 Infraestrutura (7)

| # | Ferramenta | Descrição |
|---|-----------|-----------|
| 1 | **Traefik** | Proxy reverso e load balancer com SSL automático |
| 2 | **Portainer** | Interface web para gerenciar containers Docker |
| 3 | **MinIO** | Armazenamento de objetos compatível com S3 |
| 4 | **Ntfy** | Serviço de notificações push |
| 5 | **Gotenberg** | API para conversão de documentos em PDF |
| 6 | **RabbitMQ** | Message broker para filas de mensagens |
| 7 | **Browserless** | Chrome headless como serviço |

### 💬 Chat & WhatsApp (6)

| # | Ferramenta | Descrição |
|---|-----------|-----------|
| 8 | **Chatwoot** | Plataforma de atendimento omnichannel |
| 9 | **Evolution API** | API para WhatsApp multi-dispositivo |
| 10 | **WppConnect** | Biblioteca para WhatsApp Web |
| 11 | **Quepasa API** | API alternativa para WhatsApp |
| 12 | **Uno API** | API unificada de mensagens |
| 13 | **Wuzapi** | API REST para WhatsApp |

### ⚡ Automação (3)

| # | Ferramenta | Descrição |
|---|-----------|-----------|
| 14 | **N8N** | Automação de workflows com interface visual |
| 15 | **Typebot** | Criador de chatbots com fluxos visuais |
| 16 | **Mautic** | Automação de marketing open source |

### 🧠 Inteligência Artificial (10)

| # | Ferramenta | Descrição |
|---|-----------|-----------|
| 17 | **Flowise** | Construtor de fluxos LLM drag & drop |
| 18 | **Dify AI** | Plataforma de desenvolvimento de apps IA |
| 19 | **Ollama** | Execute LLMs localmente |
| 20 | **LangFlow** | Framework visual para LangChain |
| 21 | **Langfuse** | Observabilidade para apps LLM |
| 22 | **Anything LLM** | Chat com documentos usando IA |
| 23 | **Qdrant** | Banco de dados vetorial |
| 24 | **ZEP** | Memória de longo prazo para IA |
| 25 | **Evo AI** | Plataforma de IA evolutiva |
| 26 | **Bolt** | Desenvolvimento assistido por IA |

### 📋 CRM & Projetos (8)

| # | Ferramenta | Descrição |
|---|-----------|-----------|
| 27 | **Woofed CRM** | CRM integrado com WhatsApp |
| 28 | **TwentyCRM** | CRM moderno e open source |
| 29 | **Krayin CRM** | CRM baseado em Laravel |
| 30 | **OpenProject** | Gerenciamento de projetos |
| 31 | **Planka** | Kanban board para equipes |
| 32 | **Focalboard** | Alternativa open source ao Trello/Notion |
| 33 | **GLPI** | Gestão de TI e help desk |
| 34 | **Formbricks** | Plataforma de pesquisas e formulários |

### 🗄️ Database & Admin (10)

| # | Ferramenta | Descrição |
|---|-----------|-----------|
| 35 | **PgAdmin 4** | Interface web para PostgreSQL |
| 36 | **MongoDB** | Banco de dados NoSQL |
| 37 | **Supabase** | Alternativa open source ao Firebase |
| 38 | **PhpMyAdmin** | Interface web para MySQL |
| 39 | **NocoDB** | Alternativa open source ao Airtable |
| 40 | **Baserow** | Database no-code estilo planilha |
| 41 | **Nocobase** | Plataforma no-code para apps internos |
| 42 | **ClickHouse** | Banco analítico de alta performance |
| 43 | **RedisInsight** | Interface visual para Redis |
| 44 | **Metabase** | Business intelligence e dashboards |

### 🌐 CMS & Sites (8)

| # | Ferramenta | Descrição |
|---|-----------|-----------|
| 45 | **WordPress** | CMS mais popular do mundo |
| 46 | **Directus** | Headless CMS open source |
| 47 | **Strapi** | Headless CMS baseado em Node.js |
| 48 | **NextCloud** | Nuvem privada e colaboração |
| 49 | **Wiki.js** | Wiki moderno e poderoso |
| 50 | **HumHub** | Rede social corporativa |
| 51 | **Outline** | Wiki e base de conhecimento para equipes |
| 52 | **Moodle** | Plataforma de ensino a distância |

### 📡 Monitoramento (5)

| # | Ferramenta | Descrição |
|---|-----------|-----------|
| 53 | **Uptime Kuma** | Monitoramento de uptime elegante |
| 54 | **Grafana** | Dashboards e visualização de métricas |
| 55 | **Prometheus** | Sistema de monitoramento e alertas |
| 56 | **cAdvisor** | Monitoramento de containers |
| 57 | **Traccar** | Rastreamento GPS open source |

### 🔧 Produtividade (14)

| # | Ferramenta | Descrição |
|---|-----------|-----------|
| 58 | **Cal.com** | Agendamento de reuniões open source |
| 59 | **Appsmith** | Construtor de apps internos low-code |
| 60 | **LowCoder** | Plataforma low-code para apps |
| 61 | **ToolJet** | Plataforma low-code para ferramentas internas |
| 62 | **Excalidraw** | Quadro branco virtual colaborativo |
| 63 | **Docuseal** | Assinatura digital de documentos |
| 64 | **Documeso** | Gestão de documentos |
| 65 | **Stirling PDF** | Toolkit completo para PDFs |
| 66 | **Easy!Appointments** | Sistema de agendamento online |
| 67 | **WiseMapping** | Mapas mentais colaborativos |
| 68 | **Affine** | Alternativa open source ao Notion |
| 69 | **Mattermost** | Chat corporativo open source |
| 70 | **Odoo** | Suite completa de gestão empresarial |
| 71 | **Frappe** | Framework para apps empresariais |

### 🔐 Segurança (3)

| # | Ferramenta | Descrição |
|---|-----------|-----------|
| 72 | **Keycloak** | Gestão de identidade e acesso |
| 73 | **VaultWarden** | Gerenciador de senhas (Bitwarden) |
| 74 | **Passbolt** | Gerenciador de senhas para equipes |

### 📦 Outros (7)

| # | Ferramenta | Descrição |
|---|-----------|-----------|
| 75 | **Botpress** | Plataforma de criação de chatbots |
| 76 | **Yourls** | Encurtador de URLs self-hosted |
| 77 | **Firecrawl** | Web scraping e crawling |
| 78 | **AzuraCast** | Estação de rádio web |
| 79 | **Shlink** | Encurtador de URLs com analytics |
| 80 | **RustDesk** | Acesso remoto open source |
| 81 | **Hoppscotch** | Alternativa open source ao Postman |

---

## 🎯 Como Usar

### 1. Prepare seu servidor

```bash
# Atualize o sistema
sudo apt update && sudo apt upgrade -y
```

### 2. Configure o DNS

Aponte seu domínio para o IP do servidor. Ideal: registro wildcard.

```
*.seudominio.com  →  A  →  IP_DO_SERVIDOR
seudominio.com    →  A  →  IP_DO_SERVIDOR
```

### 3. Execute o instalador

```bash
sudo bash setup-vemfazer.sh
```

### 4. Siga o assistente

- Informe seu **domínio** e **e-mail** (para SSL)
- O Traefik será instalado primeiro (proxy reverso)
- Escolha as ferramentas pelo número ou digite `0` para instalar tudo

### 5. Acesse suas ferramentas

Cada ferramenta ficará disponível em um subdomínio:

```
https://n8n.seudominio.com
https://chatwoot.seudominio.com
https://portainer.seudominio.com
...
```

---

## 📁 Estrutura de Arquivos

```
/opt/vemfazer/
├── traefik/
│   ├── docker-compose.yml
│   └── letsencrypt/
│       └── acme.json
├── n8n/
│   └── docker-compose.yml
├── chatwoot/
│   └── docker-compose.yml
├── evolution/
│   └── docker-compose.yml
└── ... (uma pasta por ferramenta)
```

---

## 🔄 Gerenciamento

### Parar uma ferramenta

```bash
cd /opt/vemfazer/n8n && docker compose down
```

### Reiniciar uma ferramenta

```bash
cd /opt/vemfazer/n8n && docker compose restart
```

### Ver logs

```bash
cd /opt/vemfazer/n8n && docker compose logs -f
```

### Atualizar uma ferramenta

```bash
cd /opt/vemfazer/n8n && docker compose pull && docker compose up -d
```

### Remover uma ferramenta

```bash
cd /opt/vemfazer/n8n && docker compose down -v
rm -rf /opt/vemfazer/n8n
```

---

## ⚠️ Notas Importantes

- **Senhas** são geradas automaticamente e exibidas durante a instalação. **Anote-as!**
- O **Traefik** é pré-requisito para todas as outras ferramentas (gerencia SSL e roteamento)
- Certifique-se de que as portas **80** e **443** estão abertas no firewall
- Para melhor performance, use **SSD** e não HDD
- Algumas ferramentas (Dify, Supabase) fazem download de seus próprios docker-compose

---

## 🤝 Contribuindo

1. Faça um fork do repositório
2. Crie uma branch (`git checkout -b feature/nova-ferramenta`)
3. Commit suas mudanças (`git commit -m 'Adiciona nova ferramenta'`)
4. Push para a branch (`git push origin feature/nova-ferramenta`)
5. Abra um Pull Request

---

## 📺 Canal Vem Fazer

<div align="center">

[![YouTube](https://img.shields.io/badge/YouTube-Vem%20Fazer-FF0000?style=for-the-badge&logo=youtube&logoColor=white)](https://www.youtube.com/@VemFazer)

Tutoriais, dicas e muito conteúdo sobre ferramentas open source!

**Inscreva-se** no canal e ative o 🔔

</div>

---

## 📄 Licença

Este projeto está sob a licença MIT. Veja o arquivo [LICENSE](LICENSE) para mais detalhes.

---

<div align="center">

Feito com ❤️ por **Raphael Batista** — [Vem Fazer](https://www.youtube.com/@VemFazer)

</div>
