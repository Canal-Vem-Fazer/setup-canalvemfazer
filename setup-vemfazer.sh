#!/bin/bash

################################################################################
#                                                                              #
#   ███████╗███████╗████████╗██╗   ██╗██████╗                                  #
#   ██╔════╝██╔════╝╚══██╔══╝██║   ██║██╔══██╗                                #
#   ███████╗█████╗     ██║   ██║   ██║██████╔╝                                #
#   ╚════██║██╔══╝     ██║   ██║   ██║██╔═══╝                                 #
#   ███████║███████╗   ██║   ╚██████╔╝██║                                     #
#   ╚══════╝╚══════╝   ╚═╝    ╚═════╝ ╚═╝                                    #
#                                                                              #
#   ██╗   ██╗███████╗███╗   ███╗    ███████╗ █████╗ ███████╗███████╗██████╗   #
#   ██║   ██║██╔════╝████╗ ████║    ██╔════╝██╔══██╗╚══███╔╝██╔════╝██╔══██╗ #
#   ██║   ██║█████╗  ██╔████╔██║    █████╗  ███████║  ███╔╝ █████╗  ██████╔╝ #
#   ╚██╗ ██╔╝██╔══╝  ██║╚██╔╝██║    ██╔══╝  ██╔══██║ ███╔╝  ██╔══╝  ██╔══██╗#
#    ╚████╔╝ ███████╗██║ ╚═╝ ██║    ██║     ██║  ██║███████╗███████╗██║  ██║ #
#     ╚═══╝  ╚══════╝╚═╝     ╚═╝    ╚═╝     ╚═╝  ╚═╝╚══════╝╚══════╝╚═╝  ╚═╝#
#                                                                              #
#   Instalador Unificado de Ferramentas Open Source                            #
#   Canal: Vem Fazer | Raphael Batista                                         #
#   YouTube: https://www.youtube.com/@VemFazer                                 #
#                                                                              #
################################################################################

set -euo pipefail

# ======================== CORES ========================
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
MAGENTA='\033[0;35m'
WHITE='\033[1;37m'
NC='\033[0m'
BOLD='\033[1m'

# ======================== VARIÁVEIS GLOBAIS ========================
DOCKER_COMPOSE_DIR="/opt/vemfazer"
VERSION="1.0.0"
EMAIL=""
TRAEFIK_INSTALLED=false
ACCEPTED_TERMS=false
declare -A TOOL_DOMAINS
CREDENTIALS_FILE="/root/vemfazer-credenciais.txt"
LAST_INSTALL_DIR=""
LAST_INSTALL_DOMAIN=""

# ======================== FUNÇÕES UTILITÁRIAS ========================

print_ascii_verificando() {
    echo -e "${CYAN}"
    echo "==================================================================================================="
    echo "=                                                                                                 ="
    echo "=        ██╗   ██╗███████╗██████╗ ██╗███████╗██╗ ██████╗ █████╗ ███╗   ██╗██████╗  ██████╗       ="
    echo "=        ██║   ██║██╔════╝██╔══██╗██║██╔════╝██║██╔════╝██╔══██╗████╗  ██║██╔══██╗██╔═══██╗      ="
    echo "=        ██║   ██║█████╗  ██████╔╝██║█████╗  ██║██║     ███████║██╔██╗ ██║██║  ██║██║   ██║      ="
    echo "=        ╚██╗ ██╔╝██╔══╝  ██╔══██╗██║██╔══╝  ██║██║     ██╔══██║██║╚██╗██║██║  ██║██║   ██║      ="
    echo "=         ╚████╔╝ ███████╗██║  ██║██║██║     ██║╚██████╗██║  ██║██║ ╚████║██████╔╝╚██████╔╝      ="
    echo "=          ╚═══╝  ╚══════╝╚═╝  ╚═╝╚═╝╚═╝     ╚═╝ ╚═════╝╚═╝  ╚═╝╚═╝  ╚═══╝╚═════╝  ╚═════╝   ="
    echo "=                                                                                                 ="
    echo "==================================================================================================="
    echo -e "${NC}"
}

print_ascii_aviso() {
    echo -e "${YELLOW}"
    echo "==================================================================================================="
    echo "=                                                                                                 ="
    echo "=                       █████╗     ██╗   ██╗    ██╗    ███████╗     ██████╗                        ="
    echo "=                      ██╔══██╗    ██║   ██║    ██║    ██╔════╝    ██╔═══██╗                       ="
    echo "=                      ███████║    ██║   ██║    ██║    ███████╗    ██║   ██║                       ="
    echo "=                      ██╔══██║    ╚██╗ ██╔╝    ██║    ╚════██║    ██║   ██║                       ="
    echo "=                      ██║  ██║     ╚████╔╝     ██║    ███████║    ╚██████╔╝                       ="
    echo "=                      ╚═╝  ╚═╝      ╚═══╝      ╚═╝    ╚══════╝     ╚═════╝                      ="
    echo "=                                                                                                 ="
    echo "==================================================================================================="
    echo -e "${NC}"
}

print_ascii_iniciando() {
    echo -e "${GREEN}"
    echo "==================================================================================================="
    echo "=                                                                                                 ="
    echo "=                   ██╗███╗   ██╗██╗ ██████╗██╗ █████╗ ███╗   ██╗██████╗  ██████╗                 ="
    echo "=                   ██║████╗  ██║██║██╔════╝██║██╔══██╗████╗  ██║██╔══██╗██╔═══██╗                ="
    echo "=                   ██║██╔██╗ ██║██║██║     ██║███████║██╔██╗ ██║██║  ██║██║   ██║                ="
    echo "=                   ██║██║╚██╗██║██║██║     ██║██╔══██║██║╚██╗██║██║  ██║██║   ██║                ="
    echo "=                   ██║██║ ╚████║██║╚██████╗██║██║  ██║██║ ╚████║██████╔╝╚██████╔╝                ="
    echo "=                   ╚═╝╚═╝  ╚═══╝╚═╝ ╚═════╝╚═╝╚═╝  ╚═╝╚═╝  ╚═══╝╚═════╝  ╚═════╝             ="
    echo "=                                              v. ${VERSION}                                      ="
    echo "=                                                                                                 ="
    echo "==================================================================================================="
    echo -e "${NC}"
}

print_ascii_setup() {
    echo -e "${BLUE}"
    echo "       ███████╗███████╗████████╗██╗   ██╗██████╗     ██╗   ██╗███████╗███╗   ███╗"
    echo "       ██╔════╝██╔════╝╚══██╔══╝██║   ██║██╔══██╗    ██║   ██║██╔════╝████╗ ████║"
    echo "       ███████╗█████╗     ██║   ██║   ██║██████╔╝    ██║   ██║█████╗  ██╔████╔██║"
    echo "       ╚════██║██╔══╝     ██║   ██║   ██║██╔═══╝     ╚██╗ ██╔╝██╔══╝  ██║╚██╔╝██║"
    echo "       ███████║███████╗   ██║   ╚██████╔╝██║          ╚████╔╝ ███████╗██║ ╚═╝ ██║"
    echo "       ╚══════╝╚══════╝   ╚═╝    ╚═════╝ ╚═╝           ╚═══╝  ╚══════╝╚═╝     ╚═╝"
    echo ""
    echo "       ███████╗ █████╗ ███████╗███████╗██████╗"
    echo "       ██╔════╝██╔══██╗╚══███╔╝██╔════╝██╔══██╗"
    echo "       █████╗  ███████║  ███╔╝ █████╗  ██████╔╝"
    echo "       ██╔══╝  ██╔══██║ ███╔╝  ██╔══╝  ██╔══██╗"
    echo "       ██║     ██║  ██║███████╗███████╗██║  ██║"
    echo "       ╚═╝     ╚═╝  ╚═╝╚══════╝╚══════╝╚═╝  ╚═╝"
    echo -e "${NC}"
}

print_banner() {
    clear
    print_ascii_setup
    echo ""
    echo -e "${YELLOW}==================================================================================================${NC}"
    echo -e "${YELLOW}=                                                                                                =${NC}"
    echo -e "${YELLOW}=   ${WHITE}Este auto instalador foi desenvolvido para auxiliar na instalação das principais aplicações${YELLOW}  =${NC}"
    echo -e "${YELLOW}=    ${WHITE}disponíveis no mercado open source. Já deixo todos os créditos aos desenvolvedores de cada${YELLOW}  =${NC}"
    echo -e "${YELLOW}=   ${WHITE}aplicação disponíveis aqui. Este Setup é licenciado sob a Licença MIT (MIT). Você pode usar,${YELLOW} =${NC}"
    echo -e "${YELLOW}=    ${WHITE}copiar, modificar, integrar, publicar, distribuir e/ou vender cópias dos produtos finais,${YELLOW}  =${NC}"
    echo -e "${YELLOW}=   ${WHITE}mas deve sempre declarar que Canal Vem Fazer (contato@vemfazer.com) é o autor original${YELLOW}      =${NC}"
    echo -e "${YELLOW}=   ${WHITE}destes códigos e atribuir um link para https://canalvemfazer.com.br${YELLOW}                            =${NC}"
    echo -e "${YELLOW}=                                                                                                =${NC}"
    echo -e "${YELLOW}=   ${CYAN}📺 YouTube: https://www.youtube.com/@VemFazer${YELLOW}                                              =${NC}"
    echo -e "${YELLOW}=   ${CYAN}💬 WhatsApp: https://chat.whatsapp.com/I6LVQeb13Cp7l39fA2cY0l${YELLOW}                              =${NC}"
    echo -e "${YELLOW}=   ${CYAN}🌐 Site: https://canalvemfazer.com.br${YELLOW}                                                         =${NC}"
    echo -e "${YELLOW}=                                                                                                =${NC}"
    echo -e "${YELLOW}==================================================================================================${NC}"
    echo ""
}

pre_install_checks() {
    clear
    print_ascii_verificando
    echo ""
    echo -e "${WHITE}Aguarde enquanto verificamos algumas informações.${NC}"
    echo ""

    print_ascii_aviso
    echo ""
    echo -e "${WHITE}                            Este script recomenda o uso do Ubuntu 22.04+${NC}"
    echo ""

    local step=1
    local total=15

    echo -e "${step}/${total} - Verificando Docker..."
    if command -v docker &>/dev/null; then
        echo -e "${GREEN}${step}/${total} - [ OK ] - Docker já está instalado${NC}"
    else
        echo -e "${YELLOW}${step}/${total} - [ OFF ] - Docker não está instalado${NC}"
    fi
    step=$((step + 1))

    echo -e "${GREEN}${step}/${total} - [ OK ] - Fazendo Upgrade${NC}"
    apt-get upgrade -y -qq 2>/dev/null || true
    step=$((step + 1))

    for pkg in sudo apt-utils dialog; do
        echo -e "${GREEN}${step}/${total} - [ OK ] - Verificando/Instalando ${pkg}${NC}"
        apt-get install -y -qq "$pkg" 2>/dev/null || true
        step=$((step + 1))
    done

    echo -e "${GREEN}${step}/${total} - [ OK ] - Verificando/Instalando jq 1/2${NC}"
    step=$((step + 1))
    echo -e "${GREEN}${step}/${total} - [ OK ] - Verificando/Instalando jq 2/2${NC}"
    apt-get install -y -qq jq 2>/dev/null || true
    step=$((step + 1))

    echo -e "${GREEN}${step}/${total} - [ OK ] - Verificando/Instalando apache2-utils 1/2${NC}"
    step=$((step + 1))
    echo -e "${GREEN}${step}/${total} - [ OK ] - Verificando/Instalando apache2-utils 2/2${NC}"
    apt-get install -y -qq apache2-utils 2>/dev/null || true
    step=$((step + 1))

    echo -e "${GREEN}${step}/${total} - [ OK ] - Verificando/Instalando Git${NC}"
    apt-get install -y -qq git 2>/dev/null || true
    step=$((step + 1))

    echo -e "${GREEN}${step}/${total} - [ OK ] - Verificando/Instalando python3${NC}"
    apt-get install -y -qq python3 2>/dev/null || true
    step=$((step + 1))

    echo -e "${GREEN}${step}/${total} - [ OK ] - Fazendo Update${NC}"
    apt-get update -qq 2>/dev/null || true
    step=$((step + 1))

    echo -e "${GREEN}${step}/${total} - [ OK ] - Fazendo Upgrade${NC}"
    apt-get upgrade -y -qq 2>/dev/null || true
    step=$((step + 1))

    echo -e "${GREEN}${step}/${total} - [ OK ] - Verificando/Instalando neofetch${NC}"
    apt-get install -y -qq neofetch 2>/dev/null || true
    step=$((step + 1))

    echo -e "${GREEN}${step}/${total} - [ OK ] - Baixando o script${NC}"
    step=$((step + 1))

    echo ""
    print_ascii_setup
    print_ascii_iniciando
    echo ""
}

accept_terms() {
    print_banner
    echo ""
    read -rp "$(echo -e ${YELLOW}'Ao digitar Y você aceita e concorda com as orientações passadas acima (Y/N): '${NC})" accept
    if [[ "${accept,,}" != "y" ]]; then
        echo -e "${RED}Você não aceitou os termos. Saindo...${NC}"
        exit 0
    fi
    ACCEPTED_TERMS=true
    echo ""
}

log_info() { echo -e "${BLUE}[INFO]${NC} $1"; }
log_success() { echo -e "${GREEN}[✔]${NC} $1"; }
log_warn() { echo -e "${YELLOW}[⚠]${NC} $1"; }
log_error() { echo -e "${RED}[✘]${NC} $1"; }

check_root() {
    if [[ $EUID -ne 0 ]]; then
        log_error "Este script deve ser executado como root!"
        echo -e "Execute: ${CYAN}sudo bash $0${NC}"
        exit 1
    fi
}

check_os() {
    if ! grep -qiE "ubuntu|debian" /etc/os-release 2>/dev/null; then
        log_warn "Sistema operacional não é Ubuntu/Debian. Podem ocorrer problemas."
    fi
}

check_requirements() {
    log_info "Verificando requisitos do sistema..."
    
    local mem_total
    mem_total=$(free -m | awk '/^Mem:/{print $2}')
    local cpu_count
    cpu_count=$(nproc)
    
    echo -e "  RAM: ${CYAN}${mem_total}MB${NC} (mínimo recomendado: 4096MB)"
    echo -e "  CPUs: ${CYAN}${cpu_count}${NC} (mínimo recomendado: 2)"
    
    if [[ $mem_total -lt 2048 ]]; then
        log_warn "Memória RAM abaixo do mínimo recomendado!"
    fi
    if [[ $cpu_count -lt 2 ]]; then
        log_warn "Número de CPUs abaixo do mínimo recomendado!"
    fi
}

# ======================== INSTALAÇÃO DO DOCKER ========================

install_docker() {
    if command -v docker &>/dev/null; then
        log_success "Docker já está instalado: $(docker --version)"
        return
    fi
    
    log_info "Instalando Docker..."
    curl -fsSL https://get.docker.com | bash
    systemctl enable docker
    systemctl start docker
    log_success "Docker instalado com sucesso!"
}

install_docker_compose() {
    if command -v docker compose &>/dev/null; then
        log_success "Docker Compose já está disponível"
        return
    fi
    
    log_info "Instalando Docker Compose plugin..."
    apt-get update -qq
    apt-get install -y -qq docker-compose-plugin
    log_success "Docker Compose instalado com sucesso!"
}

# ======================== CONFIGURAÇÃO INICIAL ========================

setup_initial() {
    echo ""
    echo -e "${BOLD}Configuração Inicial${NC}"
    echo "─────────────────────────────────────"
    
    read -rp "$(echo -e ${CYAN}'Digite seu e-mail (para SSL Let'\''s Encrypt): '${NC})" EMAIL
    
    if [[ -z "$EMAIL" ]]; then
        log_error "E-mail é obrigatório!"
        exit 1
    fi
    
    mkdir -p "$DOCKER_COMPOSE_DIR"
    log_success "Configuração inicial concluída!"
}

# ======================== MAPA DE SUBDOMÍNIOS PADRÃO ========================

declare -A TOOL_DEFAULT_SUBDOMAIN=(
    [1]="traefik" [2]="portainer" [3]="minio" [4]="ntfy" [5]="gotenberg"
    [6]="rabbitmq" [7]="browserless" [8]="chatwoot" [9]="evolution"
    [10]="wppconnect" [11]="quepasa" [12]="unoapi" [13]="wuzapi"
    [14]="n8n" [15]="typebot" [16]="mautic" [17]="flowise" [18]="dify"
    [19]="ollama" [20]="langflow" [21]="langfuse" [22]="anythingllm"
    [23]="qdrant" [24]="zep" [25]="evoai" [26]="bolt" [27]="woofed"
    [28]="twentycrm" [29]="krayin" [30]="openproject" [31]="planka"
    [32]="focalboard" [33]="glpi" [34]="formbricks" [35]="pgadmin"
    [36]="mongodb" [37]="supabase" [38]="phpmyadmin" [39]="nocodb"
    [40]="baserow" [41]="nocobase" [42]="clickhouse" [43]="redisinsight"
    [44]="metabase" [45]="wordpress" [46]="directus" [47]="strapi"
    [48]="nextcloud" [49]="wiki" [50]="humhub" [51]="outline"
    [52]="moodle" [53]="uptime" [54]="grafana" [55]="prometheus"
    [56]="cadvisor" [57]="traccar" [58]="calcom" [59]="appsmith"
    [60]="lowcoder" [61]="tooljet" [62]="excalidraw" [63]="docuseal"
    [64]="documeso" [65]="pdf" [66]="appointments" [67]="wisemapping"
    [68]="affine" [69]="mattermost" [70]="odoo" [71]="frappe"
    [72]="keycloak" [73]="vault" [74]="passbolt" [75]="botpress"
    [76]="yourls" [77]="firecrawl" [78]="radio" [79]="shlink"
    [80]="rustdesk" [81]="hoppscotch"
)

# ======================== DEPENDÊNCIAS ENTRE FERRAMENTAS ========================

declare -A TOOL_DEPS=(
    [2]="1"    # Portainer → Traefik
    [3]="1"    # MinIO → Traefik
    [4]="1"    # Ntfy → Traefik
    [5]="1"    # Gotenberg → Traefik
    [6]="1"    # RabbitMQ → Traefik
    [7]="1"    # Browserless → Traefik
    [8]="1"    # Chatwoot → Traefik
    [9]="1"    # Evolution API → Traefik
    [10]="1"   # WppConnect → Traefik
    [11]="1"   # Quepasa → Traefik
    [12]="1"   # Uno API → Traefik
    [13]="1"   # Wuzapi → Traefik
    [14]="1"   # N8N → Traefik
    [15]="1 3" # Typebot → Traefik + MinIO
    [16]="1"   # Mautic → Traefik
    [17]="1"   # Flowise → Traefik
    [18]="1"   # Dify → Traefik
    [19]="1"   # Ollama → Traefik
    [20]="1"   # LangFlow → Traefik
    [21]="1"   # Langfuse → Traefik
    [22]="1"   # Anything LLM → Traefik
    [23]="1"   # Qdrant → Traefik
    [24]="1"   # ZEP → Traefik
    [25]="1"   # Evo AI → Traefik
    [26]="1"   # Bolt → Traefik
    [27]="1"   # Woofed → Traefik
    [28]="1"   # TwentyCRM → Traefik
    [29]="1"   # Krayin → Traefik
    [30]="1"   # OpenProject → Traefik
    [31]="1"   # Planka → Traefik
    [32]="1"   # Focalboard → Traefik
    [33]="1"   # GLPI → Traefik
    [34]="1"   # Formbricks → Traefik
    [35]="1"   # PgAdmin → Traefik
    [36]="1"   # MongoDB → Traefik
    [37]="1"   # Supabase → Traefik
    [38]="1"   # PhpMyAdmin → Traefik
    [39]="1"   # NocoDB → Traefik
    [40]="1"   # Baserow → Traefik
    [41]="1"   # Nocobase → Traefik
    [42]="1"   # ClickHouse → Traefik
    [43]="1"   # RedisInsight → Traefik
    [44]="1"   # Metabase → Traefik
    [45]="1"   # WordPress → Traefik
    [46]="1"   # Directus → Traefik
    [47]="1"   # Strapi → Traefik
    [48]="1"   # NextCloud → Traefik
    [49]="1"   # Wiki.js → Traefik
    [50]="1"   # HumHub → Traefik
    [51]="1"   # Outline → Traefik
    [52]="1"   # Moodle → Traefik
    [53]="1"   # Uptime Kuma → Traefik
    [54]="1"   # Grafana → Traefik
    [55]="1"   # Prometheus → Traefik
    [56]="1"   # cAdvisor → Traefik
    [57]="1"   # Traccar → Traefik
    [58]="1"   # Cal.com → Traefik
    [59]="1"   # Appsmith → Traefik
    [60]="1"   # LowCoder → Traefik
    [61]="1"   # ToolJet → Traefik
    [62]="1"   # Excalidraw → Traefik
    [63]="1"   # Docuseal → Traefik
    [64]="1"   # Documeso → Traefik
    [65]="1"   # Stirling PDF → Traefik
    [66]="1"   # Easy!Appointments → Traefik
    [67]="1"   # WiseMapping → Traefik
    [68]="1"   # Affine → Traefik
    [69]="1"   # Mattermost → Traefik
    [70]="1"   # Odoo → Traefik
    [71]="1"   # Frappe → Traefik
    [72]="1"   # Keycloak → Traefik
    [73]="1"   # VaultWarden → Traefik
    [74]="1"   # Passbolt → Traefik
    [75]="1"   # Botpress → Traefik
    [76]="1"   # Yourls → Traefik
    [77]="1"   # Firecrawl → Traefik
    [78]="1"   # AzuraCast → Traefik
    [79]="1"   # Shlink → Traefik
    [80]="1"   # RustDesk → Traefik
    [81]="1"   # Hoppscotch → Traefik
)

declare -A TOOL_DEP_REASON=(
    [1]="Proxy reverso + SSL"
    [3]="Upload de mídia/arquivos (S3)"
)

resolve_dependencies() {
    local selected="$1"
    local resolved="$selected"
    local added_any=false
    
    for num in $selected; do
        local deps="${TOOL_DEPS[$num]:-}"
        if [[ -n "$deps" ]]; then
            for dep in $deps; do
                if ! echo " $resolved " | grep -q " $dep "; then
                    local dep_name="${TOOL_NAME_MAP[$dep]:-Ferramenta $dep}"
                    local tool_name="${TOOL_NAME_MAP[$num]:-Ferramenta $num}"
                    local reason="${TOOL_DEP_REASON[$dep]:-dependência necessária}"
                    echo -e "  ${YELLOW}⚠️  ${tool_name} requer ${dep_name} (${reason}). Adicionando automaticamente.${NC}"
                    resolved="$dep $resolved"
                    added_any=true
                fi
            done
        fi
    done
    
    if [[ "$added_any" == true ]]; then
        echo ""
        read -rp "$(echo -e ${CYAN}'Pressione ENTER para continuar...'${NC})" _
    fi
    
    # Remover duplicatas e ordenar
    echo "$resolved" | tr ' ' '\n' | sort -un | tr '\n' ' ' | xargs
}

ask_subdomains() {
    local selected_tools="$1"
    
    echo ""
    echo -e "${BOLD}╔══════════════════════════════════════════════════════════════════╗${NC}"
    echo -e "${BOLD}║  📋 Configuração de Subdomínios                                ║${NC}"
    echo -e "${BOLD}╠══════════════════════════════════════════════════════════════════╣${NC}"
    echo -e "${BOLD}║  Digite o domínio completo para cada ferramenta selecionada.    ║${NC}"
    echo -e "${BOLD}║  Ex: n8n.meudominio.com                                        ║${NC}"
    echo -e "${BOLD}╚══════════════════════════════════════════════════════════════════╝${NC}"
    echo ""
    
    for num in $selected_tools; do
        local name="${TOOL_NAME_MAP[$num]}"
        local default_sub="${TOOL_DEFAULT_SUBDOMAIN[$num]}"
        
        [[ -z "$name" ]] && continue
        
        # Typebot precisa de 2 subdomínios (Builder + Viewer)
        if [[ "$num" == "15" ]]; then
            echo -e "  ${CYAN}📦 ${name} (Builder)${NC}"
            read -rp "     Subdomínio (ex: typebot.meudominio.com): " typebot_builder_domain
            TOOL_DOMAINS["typebot"]="$typebot_builder_domain"
            echo ""
            echo -e "  ${CYAN}📦 ${name} (Viewer)${NC}"
            read -rp "     Subdomínio (ex: bot.meudominio.com): " typebot_viewer_domain
            TOOL_DOMAINS["typebot-viewer"]="$typebot_viewer_domain"
            echo ""
            continue
        fi
        
        # MinIO precisa de 2 subdomínios (Console + API S3)
        if [[ "$num" == "3" ]]; then
            echo -e "  ${CYAN}📦 ${name} (Console / Web UI)${NC}"
            read -rp "     Subdomínio (ex: minio.meudominio.com): " minio_console_domain
            TOOL_DOMAINS["minio"]="$minio_console_domain"
            echo ""
            echo -e "  ${CYAN}📦 ${name} (API S3)${NC}"
            read -rp "     Subdomínio (ex: s3.meudominio.com): " minio_api_domain
            TOOL_DOMAINS["minio-api"]="$minio_api_domain"
            echo ""
            continue
        fi
        
        echo -e "  ${CYAN}📦 ${name}${NC}"
        read -rp "     Subdomínio (ex: ${default_sub}.meudominio.com): " tool_domain
        TOOL_DOMAINS["$default_sub"]="$tool_domain"
        echo ""
    done
    
    # Resumo
    echo -e "${BOLD}╔══════════════════════════════════════════════════════════════════╗${NC}"
    echo -e "${BOLD}║  ✅ Resumo dos Subdomínios Configurados                        ║${NC}"
    echo -e "${BOLD}╠══════════════════════════════════════════════════════════════════╣${NC}"
    for key in "${!TOOL_DOMAINS[@]}"; do
        printf "${BOLD}║${NC}  %-18s → ${GREEN}%s${NC}\n" "$key" "${TOOL_DOMAINS[$key]}"
    done
    echo -e "${BOLD}╚══════════════════════════════════════════════════════════════════╝${NC}"
    echo ""
    read -rp "$(echo -e ${YELLOW}'Confirmar e prosseguir com a instalação? [S/n]: '${NC})" confirm_domains
    if [[ "${confirm_domains,,}" == "n" ]]; then
        log_info "Instalação cancelada."
        return 1
    fi
    return 0
}

# ======================== GERAÇÃO DE SENHAS ========================

generate_password() {
    openssl rand -base64 32 | tr -dc 'a-zA-Z0-9' | head -c "${1:-24}"
}

# ======================== STATUS E CREDENCIAIS ========================

check_service_status() {
    local dir="$1"
    local containers=()
    local statuses=()
    
    if [[ ! -f "$dir/docker-compose.yml" ]]; then
        return
    fi
    
    # Aguardar containers estabilizarem
    sleep 3
    
    local ps_output
    ps_output=$(cd "$dir" && docker compose ps --format "{{.Name}}|{{.State}}" 2>/dev/null || true)
    
    if [[ -z "$ps_output" ]]; then
        echo -e "  ${YELLOW}⚠️  Não foi possível verificar os containers${NC}"
        return
    fi
    
    while IFS='|' read -r name state; do
        [[ -z "$name" ]] && continue
        local icon
        case "$state" in
            running) icon="${GREEN}✅ running${NC}" ;;
            restarting) icon="${YELLOW}🔄 restarting${NC}" ;;
            exited|dead) icon="${RED}❌ exited${NC}" ;;
            *) icon="${YELLOW}⚠️  ${state}${NC}" ;;
        esac
        echo -e "  ║     %-25s %b" "$name" "$icon"
        printf "  ║     %-25s %b\n" "$name" "$icon"
    done <<< "$ps_output"
}

show_install_result() {
    local name="$1"
    local url="$2"
    local user="$3"
    local password="$4"
    local extra_info="$5"
    local compose_dir="$6"
    
    local width=64
    local line
    line=$(printf '═%.0s' $(seq 1 $width))
    
    echo ""
    echo -e "${GREEN}╔${line}╗${NC}"
    printf "${GREEN}║${NC}  ✅ %-$(($width - 5))s${GREEN}║${NC}\n" "${name} — Instalação concluída"
    echo -e "${GREEN}╠${line}╣${NC}"
    
    if [[ -n "$url" ]]; then
        printf "${GREEN}║${NC}  🌐 URL:      %-$(($width - 16))s${GREEN}║${NC}\n" "$url"
    fi
    
    if [[ -n "$user" ]]; then
        printf "${GREEN}║${NC}  👤 Usuário:  %-$(($width - 16))s${GREEN}║${NC}\n" "$user"
    fi
    
    if [[ -n "$password" ]]; then
        printf "${GREEN}║${NC}  🔑 Senha:    %-$(($width - 16))s${GREEN}║${NC}\n" "$password"
    fi
    
    if [[ -n "$extra_info" ]]; then
        echo -e "${GREEN}║${NC}  ${extra_info}"
    fi
    
    # Status dos containers
    if [[ -n "$compose_dir" ]] && [[ -f "$compose_dir/docker-compose.yml" ]]; then
        printf "${GREEN}║${NC}  %-$(($width - 3))s${GREEN}║${NC}\n" ""
        printf "${GREEN}║${NC}  📦 %-$(($width - 6))s${GREEN}║${NC}\n" "Containers:"
        
        sleep 3
        
        local ps_output
        ps_output=$(cd "$compose_dir" && docker compose ps --format "{{.Name}}|{{.State}}" 2>/dev/null || true)
        
        if [[ -n "$ps_output" ]]; then
            while IFS='|' read -r cname cstate; do
                [[ -z "$cname" ]] && continue
                local icon
                case "$cstate" in
                    running) icon="✅ running" ;;
                    restarting) icon="🔄 restarting" ;;
                    exited|dead) icon="❌ exited" ;;
                    *) icon="⚠️  ${cstate}" ;;
                esac
                printf "${GREEN}║${NC}     %-20s %-$(($width - 26))s${GREEN}║${NC}\n" "$cname" "$icon"
            done <<< "$ps_output"
        fi
    fi
    
    echo -e "${GREEN}╚${line}╝${NC}"
    echo ""
    
    # Salvar credenciais em arquivo
    {
        echo "════════════════════════════════════════════════════════════════"
        echo "  ${name} — $(date '+%Y-%m-%d %H:%M:%S')"
        echo "════════════════════════════════════════════════════════════════"
        [[ -n "$url" ]] && echo "  URL:     $url"
        [[ -n "$user" ]] && echo "  Usuário: $user"
        [[ -n "$password" ]] && echo "  Senha:   $password"
        [[ -n "$extra_info" ]] && echo "  Extra:   $(echo -e "$extra_info" | sed 's/\x1B\[[0-9;]*m//g')"
        echo ""
    } >> "$CREDENTIALS_FILE"
}

# ======================== INSTALAÇÃO DO TRAEFIK ========================

install_traefik() {
    log_info "Instalando Traefik (proxy reverso)..."
    
    local traefik_domain="${TOOL_DOMAINS[traefik]:-}"
    local dir="$DOCKER_COMPOSE_DIR/traefik"
    mkdir -p "$dir" "$dir/letsencrypt"
    touch "$dir/letsencrypt/acme.json"
    chmod 600 "$dir/letsencrypt/acme.json"
    
    docker network create proxy 2>/dev/null || true
    
    local dashboard_labels=""
    if [[ -n "$traefik_domain" ]]; then
        dashboard_labels="    labels:
      - \"traefik.enable=true\"
      - \"traefik.http.routers.traefik.rule=Host(\`${traefik_domain}\`)\"
      - \"traefik.http.routers.traefik.entrypoints=websecure\"
      - \"traefik.http.routers.traefik.tls.certresolver=letsencrypt\"
      - \"traefik.http.services.traefik.loadbalancer.server.port=8080\"
      - \"traefik.http.routers.traefik.service=api@internal\""
    fi
    
    cat > "$dir/docker-compose.yml" << EOF
version: '3.8'

services:
  traefik:
    image: traefik:v3.1
    container_name: traefik
    restart: unless-stopped
    command:
      - "--api.dashboard=true"
      - "--providers.docker=true"
      - "--providers.docker.exposedbydefault=false"
      - "--entrypoints.web.address=:80"
      - "--entrypoints.websecure.address=:443"
      - "--entrypoints.web.http.redirections.entrypoint.to=websecure"
      - "--certificatesresolvers.letsencrypt.acme.httpchallenge=true"
      - "--certificatesresolvers.letsencrypt.acme.httpchallenge.entrypoint=web"
      - "--certificatesresolvers.letsencrypt.acme.email=${EMAIL}"
      - "--certificatesresolvers.letsencrypt.acme.storage=/letsencrypt/acme.json"
    ports:
      - "80:80"
      - "443:443"
    volumes:
      - /var/run/docker.sock:/var/run/docker.sock:ro
      - ./letsencrypt:/letsencrypt
    networks:
      - proxy
${dashboard_labels}

networks:
  proxy:
    external: true
EOF

    cd "$dir" && docker compose up -d
    TRAEFIK_INSTALLED=true
    local traefik_url=""
    if [[ -n "$traefik_domain" ]]; then
        traefik_url="https://${traefik_domain}"
    fi
    show_install_result "Traefik" "$traefik_url" "" "" "" "$dir"
}

# ======================== FUNÇÃO GENÉRICA DE INSTALAÇÃO ========================

install_service() {
    local name="$1"
    local subdomain="$2"
    local image="$3"
    local port="$4"
    local extra_env="${5:-}"
    local extra_volumes="${6:-}"
    local extra_config="${7:-}"
    
    local full_domain="${TOOL_DOMAINS[$subdomain]:-$subdomain.exemplo.com}"
    
    log_info "Instalando ${name}..."
    
    local dir="$DOCKER_COMPOSE_DIR/${subdomain}"
    mkdir -p "$dir"
    
    local volumes_section=""
    if [[ -n "$extra_volumes" ]]; then
        volumes_section="    volumes:
${extra_volumes}"
    fi
    
    local env_section=""
    if [[ -n "$extra_env" ]]; then
        env_section="    environment:
${extra_env}"
    fi
    
    cat > "$dir/docker-compose.yml" << EOF
version: '3.8'

services:
  ${subdomain}:
    image: ${image}
    container_name: ${subdomain}
    restart: unless-stopped
${env_section}
${volumes_section}
${extra_config}
    networks:
      - proxy
    labels:
      - "traefik.enable=true"
      - "traefik.http.routers.${subdomain}.rule=Host(\`${full_domain}\`)"
      - "traefik.http.routers.${subdomain}.entrypoints=websecure"
      - "traefik.http.routers.${subdomain}.tls.certresolver=letsencrypt"
      - "traefik.http.services.${subdomain}.loadbalancer.server.port=${port}"

networks:
  proxy:
    external: true
EOF

    cd "$dir" && docker compose up -d
    # Retornar diretório e domínio para funções que chamam install_service
    LAST_INSTALL_DIR="$dir"
    LAST_INSTALL_DOMAIN="$full_domain"
    log_success "${name} instalado! Acesse: https://${full_domain}"
}

# ======================== FUNÇÕES DE INSTALAÇÃO ESPECÍFICAS ========================

install_portainer() {
    install_service "Portainer" "portainer" "portainer/portainer-ce:latest" "9000" "" \
        "      - /var/run/docker.sock:/var/run/docker.sock\n      - portainer_data:/data"
    show_install_result "Portainer" "https://${LAST_INSTALL_DOMAIN}" "(criar no primeiro acesso)" "" "" "$LAST_INSTALL_DIR"
}

install_minio() {
    local MINIO_CONSOLE_DOMAIN="${TOOL_DOMAINS[minio]:-minio.exemplo.com}"
    local MINIO_API_DOMAIN="${TOOL_DOMAINS[minio-api]:-s3.exemplo.com}"
    local pwd
    pwd=$(generate_password)
    local dir="$DOCKER_COMPOSE_DIR/minio"
    mkdir -p "$dir"

    cat > "$dir/docker-compose.yml" << EOF
version: '3.8'

services:
  minio:
    image: minio/minio:latest
    container_name: minio
    restart: unless-stopped
    command: server /data --console-address ':9001'
    environment:
      MINIO_ROOT_USER: admin
      MINIO_ROOT_PASSWORD: ${pwd}
    volumes:
      - minio_data:/data
    networks:
      - proxy
    labels:
      - "traefik.enable=true"
      - "traefik.http.routers.minio-console.rule=Host(\`${MINIO_CONSOLE_DOMAIN}\`)"
      - "traefik.http.routers.minio-console.entrypoints=websecure"
      - "traefik.http.routers.minio-console.tls.certresolver=letsencrypt"
      - "traefik.http.routers.minio-console.service=minio-console"
      - "traefik.http.services.minio-console.loadbalancer.server.port=9001"
      - "traefik.http.routers.minio-api.rule=Host(\`${MINIO_API_DOMAIN}\`)"
      - "traefik.http.routers.minio-api.entrypoints=websecure"
      - "traefik.http.routers.minio-api.tls.certresolver=letsencrypt"
      - "traefik.http.routers.minio-api.service=minio-api"
      - "traefik.http.services.minio-api.loadbalancer.server.port=9000"

volumes:
  minio_data:

networks:
  proxy:
    external: true
EOF

    cd "$dir" && docker compose up -d
    show_install_result "MinIO" "https://${MINIO_CONSOLE_DOMAIN}" "admin" "$pwd" "📡 API S3: https://${MINIO_API_DOMAIN}" "$dir"
}

install_ntfy() {
    install_service "Ntfy" "ntfy" "binwiederhier/ntfy:latest" "80" "" \
        "      - ntfy_data:/var/cache/ntfy" \
        "    command: serve"
    show_install_result "Ntfy" "https://${LAST_INSTALL_DOMAIN}" "" "" "" "$LAST_INSTALL_DIR"
}

install_gotenberg() {
    install_service "Gotenberg" "gotenberg" "gotenberg/gotenberg:8" "3000"
    show_install_result "Gotenberg" "https://${LAST_INSTALL_DOMAIN}" "" "" "" "$LAST_INSTALL_DIR"
}

install_rabbitmq() {
    local pwd
    pwd=$(generate_password)
    install_service "RabbitMQ" "rabbitmq" "rabbitmq:3-management" "15672" \
        "      RABBITMQ_DEFAULT_USER: admin\n      RABBITMQ_DEFAULT_PASS: ${pwd}"
    show_install_result "RabbitMQ" "https://${LAST_INSTALL_DOMAIN}" "admin" "$pwd" "" "$LAST_INSTALL_DIR"
}

install_browserless() {
    local token
    token=$(generate_password 16)
    install_service "Browserless" "browserless" "browserless/chrome:latest" "3000" \
        "      TOKEN: ${token}"
    show_install_result "Browserless" "https://${LAST_INSTALL_DOMAIN}" "" "" "🔑 Token: ${token}" "$LAST_INSTALL_DIR"
}

install_chatwoot() {
    local CHATWOOT_DOMAIN="${TOOL_DOMAINS[chatwoot]:-chatwoot.exemplo.com}"
    local secret
    secret=$(generate_password 32)
    local secret_key
    secret_key=$(generate_password 64)
    local dir="$DOCKER_COMPOSE_DIR/chatwoot"
    mkdir -p "$dir"
    
    # Detectar se MinIO está disponível para storage S3
    local s3_env=""
    local MINIO_API_DOMAIN="${TOOL_DOMAINS[minio-api]:-}"
    if [[ -n "$MINIO_API_DOMAIN" ]]; then
        s3_env="
      ACTIVE_STORAGE_SERVICE: amazon
      S3_BUCKET_NAME: chatwoot
      AWS_ACCESS_KEY_ID: admin
      AWS_SECRET_ACCESS_KEY: \${MINIO_PASSWORD:-changeme}
      AWS_REGION: us-east-1
      S3_ENDPOINT: https://${MINIO_API_DOMAIN}"
    fi
    
    cat > "$dir/docker-compose.yml" << EOF
version: '3.8'

services:
  chatwoot-db:
    image: postgres:15
    container_name: chatwoot-db
    restart: unless-stopped
    environment:
      POSTGRES_DB: chatwoot
      POSTGRES_USER: chatwoot
      POSTGRES_PASSWORD: ${secret}
    volumes:
      - chatwoot_db:/var/lib/postgresql/data
    networks:
      - proxy

  chatwoot-redis:
    image: redis:7-alpine
    container_name: chatwoot-redis
    restart: unless-stopped
    networks:
      - proxy

  chatwoot:
    image: chatwoot/chatwoot:latest
    container_name: chatwoot
    restart: unless-stopped
    depends_on:
      - chatwoot-db
      - chatwoot-redis
    environment:
      SECRET_KEY_BASE: ${secret_key}
      FRONTEND_URL: https://${CHATWOOT_DOMAIN}
      DATABASE_URL: postgres://chatwoot:${secret}@chatwoot-db:5432/chatwoot
      REDIS_URL: redis://chatwoot-redis:6379
      RAILS_ENV: production
      NODE_ENV: production${s3_env}
    entrypoint: docker/entrypoints/rails.sh
    command: ['bundle', 'exec', 'rails', 's', '-p', '3000', '-b', '0.0.0.0']
    networks:
      - proxy
    labels:
      - "traefik.enable=true"
      - "traefik.http.routers.chatwoot.rule=Host(\`${CHATWOOT_DOMAIN}\`)"
      - "traefik.http.routers.chatwoot.entrypoints=websecure"
      - "traefik.http.routers.chatwoot.tls.certresolver=letsencrypt"
      - "traefik.http.services.chatwoot.loadbalancer.server.port=3000"

  chatwoot-sidekiq:
    image: chatwoot/chatwoot:latest
    container_name: chatwoot-sidekiq
    restart: unless-stopped
    depends_on:
      - chatwoot-db
      - chatwoot-redis
    environment:
      SECRET_KEY_BASE: ${secret_key}
      FRONTEND_URL: https://${CHATWOOT_DOMAIN}
      DATABASE_URL: postgres://chatwoot:${secret}@chatwoot-db:5432/chatwoot
      REDIS_URL: redis://chatwoot-redis:6379
      RAILS_ENV: production
      NODE_ENV: production${s3_env}
    command: ['bundle', 'exec', 'sidekiq', '-C', 'config/sidekiq.yml']
    networks:
      - proxy

volumes:
  chatwoot_db:

networks:
  proxy:
    external: true
EOF

    cd "$dir" && docker compose up -d
    show_install_result "Chatwoot" "https://${CHATWOOT_DOMAIN}" "(criar no primeiro acesso)" "" "🔑 Senha DB: ${secret}\n${GREEN}║${NC}  ✔ Sidekiq (worker) incluído" "$dir"
}

install_evolution_api() {
    local key
    key=$(generate_password 32)
    install_service "Evolution API" "evolution" "atendai/evolution-api:latest" "8080" \
        "      AUTHENTICATION_API_KEY: ${key}"
    show_install_result "Evolution API" "https://${LAST_INSTALL_DOMAIN}" "" "" "🔑 API Key: ${key}" "$LAST_INSTALL_DIR"
}

install_n8n() {
    install_service "N8N" "n8n" "docker.n8n.io/n8nio/n8n:latest" "5678" \
        "      N8N_HOST: ${TOOL_DOMAINS[n8n]}\n      N8N_PROTOCOL: https\n      WEBHOOK_URL: https://${TOOL_DOMAINS[n8n]}/" \
        "      - n8n_data:/home/node/.n8n"
    show_install_result "N8N" "https://${LAST_INSTALL_DOMAIN}" "(criar no primeiro acesso)" "" "" "$LAST_INSTALL_DIR"
}

install_typebot() {
    local TYPEBOT_BUILDER_DOMAIN="${TOOL_DOMAINS[typebot]:-typebot.exemplo.com}"
    local TYPEBOT_VIEWER_DOMAIN="${TOOL_DOMAINS[typebot-viewer]:-bot.exemplo.com}"
    local MINIO_API_DOMAIN="${TOOL_DOMAINS[minio-api]:-s3.exemplo.com}"
    local secret
    secret=$(generate_password 32)
    local encryption_secret
    encryption_secret=$(generate_password 32)
    local nextauth_secret
    nextauth_secret=$(generate_password 32)
    local dir="$DOCKER_COMPOSE_DIR/typebot"
    mkdir -p "$dir"

    cat > "$dir/docker-compose.yml" << EOF
version: '3.8'

services:
  typebot-db:
    image: postgres:15
    container_name: typebot-db
    restart: unless-stopped
    environment:
      POSTGRES_DB: typebot
      POSTGRES_USER: typebot
      POSTGRES_PASSWORD: ${secret}
    volumes:
      - typebot_db:/var/lib/postgresql/data
    networks:
      - proxy

  typebot-builder:
    image: baptistearno/typebot-builder:latest
    container_name: typebot-builder
    restart: unless-stopped
    depends_on:
      - typebot-db
    environment:
      DATABASE_URL: postgres://typebot:${secret}@typebot-db:5432/typebot
      NEXTAUTH_URL: https://${TYPEBOT_BUILDER_DOMAIN}
      NEXT_PUBLIC_VIEWER_URL: https://${TYPEBOT_VIEWER_DOMAIN}
      ENCRYPTION_SECRET: ${encryption_secret}
      NEXTAUTH_SECRET: ${nextauth_secret}
      S3_ACCESS_KEY: admin
      S3_SECRET_KEY: \${MINIO_PASSWORD:-changeme}
      S3_BUCKET: typebot
      S3_ENDPOINT: https://${MINIO_API_DOMAIN}
    networks:
      - proxy
    labels:
      - "traefik.enable=true"
      - "traefik.http.routers.typebot.rule=Host(\`${TYPEBOT_BUILDER_DOMAIN}\`)"
      - "traefik.http.routers.typebot.entrypoints=websecure"
      - "traefik.http.routers.typebot.tls.certresolver=letsencrypt"
      - "traefik.http.services.typebot.loadbalancer.server.port=3000"

  typebot-viewer:
    image: baptistearno/typebot-viewer:latest
    container_name: typebot-viewer
    restart: unless-stopped
    depends_on:
      - typebot-db
    environment:
      DATABASE_URL: postgres://typebot:${secret}@typebot-db:5432/typebot
      NEXTAUTH_URL: https://${TYPEBOT_BUILDER_DOMAIN}
      NEXT_PUBLIC_VIEWER_URL: https://${TYPEBOT_VIEWER_DOMAIN}
      ENCRYPTION_SECRET: ${encryption_secret}
      S3_ACCESS_KEY: admin
      S3_SECRET_KEY: \${MINIO_PASSWORD:-changeme}
      S3_BUCKET: typebot
      S3_ENDPOINT: https://${MINIO_API_DOMAIN}
    networks:
      - proxy
    labels:
      - "traefik.enable=true"
      - "traefik.http.routers.typebot-viewer.rule=Host(\`${TYPEBOT_VIEWER_DOMAIN}\`)"
      - "traefik.http.routers.typebot-viewer.entrypoints=websecure"
      - "traefik.http.routers.typebot-viewer.tls.certresolver=letsencrypt"
      - "traefik.http.services.typebot-viewer.loadbalancer.server.port=3000"

volumes:
  typebot_db:

networks:
  proxy:
    external: true
EOF

    cd "$dir" && docker compose up -d
    show_install_result "Typebot" "https://${TYPEBOT_BUILDER_DOMAIN}" "(criar no primeiro acesso)" "" "🔑 Senha DB: ${secret}\n${GREEN}║${NC}  🌐 Viewer: https://${TYPEBOT_VIEWER_DOMAIN}" "$dir"
}

install_mautic() {
    local MAUTIC_DOMAIN="${TOOL_DOMAINS[mautic]:-mautic.exemplo.com}"
    local pwd
    pwd=$(generate_password)
    local dir="$DOCKER_COMPOSE_DIR/mautic"
    mkdir -p "$dir"

    cat > "$dir/docker-compose.yml" << EOF
version: '3.8'

services:
  mautic-db:
    image: mariadb:10.11
    container_name: mautic-db
    restart: unless-stopped
    environment:
      MYSQL_ROOT_PASSWORD: ${pwd}
      MYSQL_DATABASE: mautic
      MYSQL_USER: mautic
      MYSQL_PASSWORD: ${pwd}
    volumes:
      - mautic_db:/var/lib/mysql
    networks:
      - proxy

  mautic:
    image: mautic/mautic:latest
    container_name: mautic
    restart: unless-stopped
    depends_on:
      - mautic-db
    environment:
      MAUTIC_DB_HOST: mautic-db
      MAUTIC_DB_NAME: mautic
      MAUTIC_DB_USER: mautic
      MAUTIC_DB_PASSWORD: ${pwd}
    volumes:
      - mautic_data:/var/www/html
    networks:
      - proxy
    labels:
      - "traefik.enable=true"
      - "traefik.http.routers.mautic.rule=Host(\`${MAUTIC_DOMAIN}\`)"
      - "traefik.http.routers.mautic.entrypoints=websecure"
      - "traefik.http.routers.mautic.tls.certresolver=letsencrypt"
      - "traefik.http.services.mautic.loadbalancer.server.port=80"

volumes:
  mautic_db:
  mautic_data:

networks:
  proxy:
    external: true
EOF

    cd "$dir" && docker compose up -d
    show_install_result "Mautic" "https://${MAUTIC_DOMAIN}" "(criar no primeiro acesso)" "" "🔑 Senha DB: ${pwd}" "$dir"
}

install_flowise() {
    local pwd
    pwd=$(generate_password)
    install_service "Flowise" "flowise" "flowiseai/flowise:latest" "3000" \
        "      FLOWISE_USERNAME: admin\n      FLOWISE_PASSWORD: ${pwd}" \
        "      - flowise_data:/root/.flowise"
    show_install_result "Flowise" "https://${LAST_INSTALL_DOMAIN}" "admin" "$pwd" "" "$LAST_INSTALL_DIR"
}

install_dify() {
    log_info "Instalando Dify AI..."
    local dir="$DOCKER_COMPOSE_DIR/dify"
    mkdir -p "$dir"
    cd "$dir"
    
    if [[ ! -f docker-compose.yml ]]; then
        curl -sSL https://raw.githubusercontent.com/langgenius/dify/main/docker/docker-compose.yaml -o docker-compose.yml
    fi
    docker compose up -d
    show_install_result "Dify AI" "https://${TOOL_DOMAINS[dify]:-dify.exemplo.com}" "(criar no primeiro acesso)" "" "" "$dir"
}

install_ollama() {
    install_service "Ollama" "ollama" "ollama/ollama:latest" "11434" "" \
        "      - ollama_data:/root/.ollama"
    show_install_result "Ollama" "https://${LAST_INSTALL_DOMAIN}" "" "" "ℹ️  API local para modelos LLM" "$LAST_INSTALL_DIR"
}

install_langflow() {
    install_service "LangFlow" "langflow" "langflowai/langflow:latest" "7860"
    show_install_result "LangFlow" "https://${LAST_INSTALL_DOMAIN}" "(criar no primeiro acesso)" "" "" "$LAST_INSTALL_DIR"
}

install_langfuse() {
    local LANGFUSE_DOMAIN="${TOOL_DOMAINS[langfuse]:-langfuse.exemplo.com}"
    local pwd
    pwd=$(generate_password)
    local dir="$DOCKER_COMPOSE_DIR/langfuse"
    mkdir -p "$dir"

    cat > "$dir/docker-compose.yml" << EOF
version: '3.8'

services:
  langfuse-db:
    image: postgres:15
    container_name: langfuse-db
    restart: unless-stopped
    environment:
      POSTGRES_DB: langfuse
      POSTGRES_USER: langfuse
      POSTGRES_PASSWORD: ${pwd}
    volumes:
      - langfuse_db:/var/lib/postgresql/data
    networks:
      - proxy

  langfuse:
    image: langfuse/langfuse:latest
    container_name: langfuse
    restart: unless-stopped
    depends_on:
      - langfuse-db
    environment:
      DATABASE_URL: postgres://langfuse:${pwd}@langfuse-db:5432/langfuse
      NEXTAUTH_SECRET: $(generate_password 32)
      NEXTAUTH_URL: https://${LANGFUSE_DOMAIN}
      SALT: $(generate_password 16)
    networks:
      - proxy
    labels:
      - "traefik.enable=true"
      - "traefik.http.routers.langfuse.rule=Host(\`${LANGFUSE_DOMAIN}\`)"
      - "traefik.http.routers.langfuse.entrypoints=websecure"
      - "traefik.http.routers.langfuse.tls.certresolver=letsencrypt"
      - "traefik.http.services.langfuse.loadbalancer.server.port=3000"

volumes:
  langfuse_db:

networks:
  proxy:
    external: true
EOF

    cd "$dir" && docker compose up -d
    show_install_result "Langfuse" "https://${LANGFUSE_DOMAIN}" "(criar no primeiro acesso)" "" "🔑 Senha DB: ${pwd}" "$dir"
}

install_anything_llm() {
    install_service "Anything LLM" "anythingllm" "mintplexlabs/anythingllm:latest" "3001" \
        "      STORAGE_DIR: /app/server/storage" \
        "      - anythingllm_data:/app/server/storage"
    show_install_result "Anything LLM" "https://${LAST_INSTALL_DOMAIN}" "(criar no primeiro acesso)" "" "" "$LAST_INSTALL_DIR"
}

install_qdrant() {
    install_service "Qdrant" "qdrant" "qdrant/qdrant:latest" "6333" "" \
        "      - qdrant_data:/qdrant/storage"
    show_install_result "Qdrant" "https://${LAST_INSTALL_DOMAIN}" "" "" "ℹ️  Vector DB para embeddings" "$LAST_INSTALL_DIR"
}

install_zep() {
    install_service "ZEP" "zep" "ghcr.io/getzep/zep:latest" "8000"
    show_install_result "ZEP" "https://${LAST_INSTALL_DOMAIN}" "" "" "" "$LAST_INSTALL_DIR"
}

install_evo_ai() {
    install_service "Evo AI" "evoai" "evoai/evoai:latest" "8000"
    show_install_result "Evo AI" "https://${LAST_INSTALL_DOMAIN}" "" "" "" "$LAST_INSTALL_DIR"
}

install_bolt() {
    install_service "Bolt" "bolt" "ghcr.io/stackblitz-labs/bolt.diy:latest" "5173"
    show_install_result "Bolt" "https://${LAST_INSTALL_DOMAIN}" "" "" "" "$LAST_INSTALL_DIR"
}

install_woofed_crm() {
    install_service "Woofed CRM" "woofed" "woofedcrm/woofedcrm:latest" "3000"
    show_install_result "Woofed CRM" "https://${LAST_INSTALL_DOMAIN}" "(criar no primeiro acesso)" "" "" "$LAST_INSTALL_DIR"
}

install_twentycrm() {
    install_service "TwentyCRM" "twentycrm" "twentycrm/twenty:latest" "3000"
    show_install_result "TwentyCRM" "https://${LAST_INSTALL_DOMAIN}" "(criar no primeiro acesso)" "" "" "$LAST_INSTALL_DIR"
}

install_krayin_crm() {
    install_service "Krayin CRM" "krayin" "krayincrm/krayin:latest" "80"
    show_install_result "Krayin CRM" "https://${LAST_INSTALL_DOMAIN}" "(criar no primeiro acesso)" "" "" "$LAST_INSTALL_DIR"
}

install_openproject() {
    local pwd
    pwd=$(generate_password)
    local secret_key
    secret_key=$(generate_password 64)
    install_service "OpenProject" "openproject" "openproject/openproject:14" "8080" \
        "      OPENPROJECT_SECRET_KEY_BASE: ${secret_key}\n      OPENPROJECT_HOST__NAME: ${TOOL_DOMAINS[openproject]}\n      OPENPROJECT_HTTPS: true"
    show_install_result "OpenProject" "https://${LAST_INSTALL_DOMAIN}" "admin" "admin (alterar no primeiro acesso)" "" "$LAST_INSTALL_DIR"
}

install_planka() {
    local pwd
    pwd=$(generate_password)
    install_service "Planka" "planka" "ghcr.io/plankanban/planka:latest" "1337" \
        "      BASE_URL: https://${TOOL_DOMAINS[planka]}\n      SECRET_KEY: $(generate_password 64)\n      DEFAULT_ADMIN_EMAIL: ${EMAIL}\n      DEFAULT_ADMIN_PASSWORD: ${pwd}"
    show_install_result "Planka" "https://${LAST_INSTALL_DOMAIN}" "$EMAIL" "$pwd" "" "$LAST_INSTALL_DIR"
}

install_focalboard() {
    install_service "Focalboard" "focalboard" "mattermost/focalboard:latest" "8000"
    show_install_result "Focalboard" "https://${LAST_INSTALL_DOMAIN}" "(criar no primeiro acesso)" "" "" "$LAST_INSTALL_DIR"
}

install_glpi() {
    local GLPI_DOMAIN="${TOOL_DOMAINS[glpi]:-glpi.exemplo.com}"
    local dir="$DOCKER_COMPOSE_DIR/glpi"
    mkdir -p "$dir"
    local pwd
    pwd=$(generate_password)

    cat > "$dir/docker-compose.yml" << EOF
version: '3.8'

services:
  glpi-db:
    image: mariadb:10.11
    container_name: glpi-db
    restart: unless-stopped
    environment:
      MYSQL_ROOT_PASSWORD: ${pwd}
      MYSQL_DATABASE: glpi
      MYSQL_USER: glpi
      MYSQL_PASSWORD: ${pwd}
    volumes:
      - glpi_db:/var/lib/mysql
    networks:
      - proxy

  glpi:
    image: diouxx/glpi:latest
    container_name: glpi
    restart: unless-stopped
    depends_on:
      - glpi-db
    environment:
      TIMEZONE: America/Sao_Paulo
    volumes:
      - glpi_data:/var/www/html/glpi
    networks:
      - proxy
    labels:
      - "traefik.enable=true"
      - "traefik.http.routers.glpi.rule=Host(\`${GLPI_DOMAIN}\`)"
      - "traefik.http.routers.glpi.entrypoints=websecure"
      - "traefik.http.routers.glpi.tls.certresolver=letsencrypt"
      - "traefik.http.services.glpi.loadbalancer.server.port=80"

volumes:
  glpi_db:
  glpi_data:

networks:
  proxy:
    external: true
EOF

    cd "$dir" && docker compose up -d
    show_install_result "GLPI" "https://${GLPI_DOMAIN}" "glpi" "glpi (alterar no primeiro acesso)" "🔑 Senha DB: ${pwd}\n${GREEN}║${NC}  ℹ️  Outros logins padrão: tech/tech, normal/normal, post-only/postonly" "$dir"
}

install_formbricks() {
    install_service "Formbricks" "formbricks" "formbricks/formbricks:latest" "3000" \
        "      WEBAPP_URL: https://${TOOL_DOMAINS[formbricks]}\n      NEXTAUTH_SECRET: $(generate_password 32)\n      ENCRYPTION_KEY: $(generate_password 32)"
    show_install_result "Formbricks" "https://${LAST_INSTALL_DOMAIN}" "(criar no primeiro acesso)" "" "" "$LAST_INSTALL_DIR"
}

install_pgadmin() {
    local pwd
    pwd=$(generate_password)
    install_service "PgAdmin 4" "pgadmin" "dpage/pgadmin4:latest" "80" \
        "      PGADMIN_DEFAULT_EMAIL: ${EMAIL}\n      PGADMIN_DEFAULT_PASSWORD: ${pwd}"
    show_install_result "PgAdmin 4" "https://${LAST_INSTALL_DOMAIN}" "$EMAIL" "$pwd" "" "$LAST_INSTALL_DIR"
}

install_mongodb() {
    local pwd
    pwd=$(generate_password)
    install_service "MongoDB" "mongodb" "mongo:7" "27017" \
        "      MONGO_INITDB_ROOT_USERNAME: admin\n      MONGO_INITDB_ROOT_PASSWORD: ${pwd}" \
        "      - mongodb_data:/data/db"
    show_install_result "MongoDB" "https://${LAST_INSTALL_DOMAIN}" "admin" "$pwd" "" "$LAST_INSTALL_DIR"
}

install_supabase() {
    log_info "Instalando Supabase..."
    local dir="$DOCKER_COMPOSE_DIR/supabase"
    mkdir -p "$dir"
    cd "$dir"
    
    if [[ ! -d docker ]]; then
        git clone --depth 1 https://github.com/supabase/supabase "$dir/repo"
        cp -r "$dir/repo/docker" "$dir/docker"
        rm -rf "$dir/repo"
    fi
    cd "$dir/docker" && docker compose up -d
    show_install_result "Supabase" "https://${TOOL_DOMAINS[supabase]:-supabase.exemplo.com}" "(criar no primeiro acesso)" "" "" "$dir/docker"
}

install_phpmyadmin() {
    install_service "PhpMyAdmin" "phpmyadmin" "phpmyadmin/phpmyadmin:latest" "80" \
        "      PMA_ARBITRARY: 1"
    show_install_result "PhpMyAdmin" "https://${LAST_INSTALL_DOMAIN}" "" "" "" "$LAST_INSTALL_DIR"
}

install_nocodb() {
    install_service "NocoDB" "nocodb" "nocodb/nocodb:latest" "8080" "" \
        "      - nocodb_data:/usr/app/data"
    show_install_result "NocoDB" "https://${LAST_INSTALL_DOMAIN}" "(criar no primeiro acesso)" "" "" "$LAST_INSTALL_DIR"
}

install_baserow() {
    install_service "Baserow" "baserow" "baserow/baserow:latest" "80" \
        "      BASEROW_PUBLIC_URL: https://${TOOL_DOMAINS[baserow]}" \
        "      - baserow_data:/baserow/data"
    show_install_result "Baserow" "https://${LAST_INSTALL_DOMAIN}" "(criar no primeiro acesso)" "" "" "$LAST_INSTALL_DIR"
}

install_nocobase() {
    install_service "Nocobase" "nocobase" "nocobase/nocobase:latest" "13000"
    show_install_result "Nocobase" "https://${LAST_INSTALL_DOMAIN}" "(criar no primeiro acesso)" "" "" "$LAST_INSTALL_DIR"
}

install_clickhouse() {
    install_service "ClickHouse" "clickhouse" "clickhouse/clickhouse-server:latest" "8123" "" \
        "      - clickhouse_data:/var/lib/clickhouse"
    show_install_result "ClickHouse" "https://${LAST_INSTALL_DOMAIN}" "default" "" "" "$LAST_INSTALL_DIR"
}

install_redisinsight() {
    install_service "RedisInsight" "redisinsight" "redis/redisinsight:latest" "5540"
    show_install_result "RedisInsight" "https://${LAST_INSTALL_DOMAIN}" "" "" "" "$LAST_INSTALL_DIR"
}

install_metabase() {
    install_service "Metabase" "metabase" "metabase/metabase:latest" "3000"
    show_install_result "Metabase" "https://${LAST_INSTALL_DOMAIN}" "(criar no primeiro acesso)" "" "" "$LAST_INSTALL_DIR"
}

install_wordpress() {
    local WORDPRESS_DOMAIN="${TOOL_DOMAINS[wordpress]:-wordpress.exemplo.com}"
    local pwd
    pwd=$(generate_password)
    local dir="$DOCKER_COMPOSE_DIR/wordpress"
    mkdir -p "$dir"

    cat > "$dir/docker-compose.yml" << EOF
version: '3.8'

services:
  wordpress-db:
    image: mariadb:10.11
    container_name: wordpress-db
    restart: unless-stopped
    environment:
      MYSQL_ROOT_PASSWORD: ${pwd}
      MYSQL_DATABASE: wordpress
      MYSQL_USER: wordpress
      MYSQL_PASSWORD: ${pwd}
    volumes:
      - wp_db:/var/lib/mysql
    networks:
      - proxy

  wordpress:
    image: wordpress:latest
    container_name: wordpress
    restart: unless-stopped
    depends_on:
      - wordpress-db
    environment:
      WORDPRESS_DB_HOST: wordpress-db
      WORDPRESS_DB_NAME: wordpress
      WORDPRESS_DB_USER: wordpress
      WORDPRESS_DB_PASSWORD: ${pwd}
    volumes:
      - wp_data:/var/www/html
    networks:
      - proxy
    labels:
      - "traefik.enable=true"
      - "traefik.http.routers.wordpress.rule=Host(\`${WORDPRESS_DOMAIN}\`)"
      - "traefik.http.routers.wordpress.entrypoints=websecure"
      - "traefik.http.routers.wordpress.tls.certresolver=letsencrypt"
      - "traefik.http.services.wordpress.loadbalancer.server.port=80"

volumes:
  wp_db:
  wp_data:

networks:
  proxy:
    external: true
EOF

    cd "$dir" && docker compose up -d
    show_install_result "WordPress" "https://${WORDPRESS_DOMAIN}" "(criar no primeiro acesso)" "" "🔑 Senha DB: ${pwd}" "$dir"
}

install_directus() {
    local pwd
    pwd=$(generate_password)
    install_service "Directus" "directus" "directus/directus:latest" "8055" \
        "      KEY: $(generate_password 32)\n      SECRET: $(generate_password 32)\n      ADMIN_EMAIL: ${EMAIL}\n      ADMIN_PASSWORD: ${pwd}"
    show_install_result "Directus" "https://${LAST_INSTALL_DOMAIN}" "$EMAIL" "$pwd" "" "$LAST_INSTALL_DIR"
}

install_strapi() {
    install_service "Strapi" "strapi" "strapi/strapi:latest" "1337"
    show_install_result "Strapi" "https://${LAST_INSTALL_DOMAIN}" "(criar no primeiro acesso)" "" "" "$LAST_INSTALL_DIR"
}

install_nextcloud() {
    local pwd
    pwd=$(generate_password)
    install_service "NextCloud" "nextcloud" "nextcloud:latest" "80" \
        "      NEXTCLOUD_ADMIN_USER: admin\n      NEXTCLOUD_ADMIN_PASSWORD: ${pwd}\n      NEXTCLOUD_TRUSTED_DOMAINS: ${TOOL_DOMAINS[nextcloud]}" \
        "      - nextcloud_data:/var/www/html"
    show_install_result "NextCloud" "https://${LAST_INSTALL_DOMAIN}" "admin" "$pwd" "" "$LAST_INSTALL_DIR"
}

install_wikijs() {
    local WIKIJS_DOMAIN="${TOOL_DOMAINS[wiki]:-wiki.exemplo.com}"
    local pwd
    pwd=$(generate_password)
    local dir="$DOCKER_COMPOSE_DIR/wikijs"
    mkdir -p "$dir"

    cat > "$dir/docker-compose.yml" << EOF
version: '3.8'

services:
  wikijs-db:
    image: postgres:15
    container_name: wikijs-db
    restart: unless-stopped
    environment:
      POSTGRES_DB: wikijs
      POSTGRES_USER: wikijs
      POSTGRES_PASSWORD: ${pwd}
    volumes:
      - wikijs_db:/var/lib/postgresql/data
    networks:
      - proxy

  wikijs:
    image: ghcr.io/requarks/wiki:2
    container_name: wikijs
    restart: unless-stopped
    depends_on:
      - wikijs-db
    environment:
      DB_TYPE: postgres
      DB_HOST: wikijs-db
      DB_PORT: 5432
      DB_USER: wikijs
      DB_PASS: ${pwd}
      DB_NAME: wikijs
    networks:
      - proxy
    labels:
      - "traefik.enable=true"
      - "traefik.http.routers.wikijs.rule=Host(\`${WIKIJS_DOMAIN}\`)"
      - "traefik.http.routers.wikijs.entrypoints=websecure"
      - "traefik.http.routers.wikijs.tls.certresolver=letsencrypt"
      - "traefik.http.services.wikijs.loadbalancer.server.port=3000"

volumes:
  wikijs_db:

networks:
  proxy:
    external: true
EOF

    cd "$dir" && docker compose up -d
    show_install_result "Wiki.js" "https://${WIKIJS_DOMAIN}" "(criar no primeiro acesso)" "" "🔑 Senha DB: ${pwd}" "$dir"
}

install_humhub() {
    install_service "HumHub" "humhub" "mriedmann/humhub:latest" "80"
    show_install_result "HumHub" "https://${LAST_INSTALL_DOMAIN}" "(criar no primeiro acesso)" "" "" "$LAST_INSTALL_DIR"
}

install_outline() {
    install_service "Outline" "outline" "outlinewiki/outline:latest" "3000" \
        "      URL: https://${TOOL_DOMAINS[outline]}\n      SECRET_KEY: $(generate_password 32)\n      UTILS_SECRET: $(generate_password 32)"
    show_install_result "Outline" "https://${LAST_INSTALL_DOMAIN}" "(criar no primeiro acesso)" "" "" "$LAST_INSTALL_DIR"
}

install_moodle() {
    local pwd
    pwd=$(generate_password)
    install_service "Moodle" "moodle" "bitnami/moodle:latest" "8080" \
        "      MOODLE_USERNAME: admin\n      MOODLE_PASSWORD: ${pwd}\n      MOODLE_EMAIL: ${EMAIL}\n      MOODLE_SITE_NAME: Vem Fazer"
    show_install_result "Moodle" "https://${LAST_INSTALL_DOMAIN}" "admin" "$pwd" "" "$LAST_INSTALL_DIR"
}

install_uptime_kuma() {
    install_service "Uptime Kuma" "uptime" "louislam/uptime-kuma:latest" "3001" "" \
        "      - uptime_data:/app/data"
    show_install_result "Uptime Kuma" "https://${LAST_INSTALL_DOMAIN}" "(criar no primeiro acesso)" "" "" "$LAST_INSTALL_DIR"
}

install_grafana() {
    local pwd
    pwd=$(generate_password)
    install_service "Grafana" "grafana" "grafana/grafana:latest" "3000" \
        "      GF_SECURITY_ADMIN_PASSWORD: ${pwd}" \
        "      - grafana_data:/var/lib/grafana"
    show_install_result "Grafana" "https://${LAST_INSTALL_DOMAIN}" "admin" "$pwd" "" "$LAST_INSTALL_DIR"
}

install_prometheus() {
    install_service "Prometheus" "prometheus" "prom/prometheus:latest" "9090" "" \
        "      - prometheus_data:/prometheus"
    show_install_result "Prometheus" "https://${LAST_INSTALL_DOMAIN}" "" "" "" "$LAST_INSTALL_DIR"
}

install_cadvisor() {
    local CADVISOR_DOMAIN="${TOOL_DOMAINS[cadvisor]:-cadvisor.exemplo.com}"
    local dir="$DOCKER_COMPOSE_DIR/cadvisor"
    mkdir -p "$dir"

    cat > "$dir/docker-compose.yml" << EOF
version: '3.8'

services:
  cadvisor:
    image: gcr.io/cadvisor/cadvisor:latest
    container_name: cadvisor
    restart: unless-stopped
    volumes:
      - /:/rootfs:ro
      - /var/run:/var/run:ro
      - /sys:/sys:ro
      - /var/lib/docker/:/var/lib/docker:ro
    networks:
      - proxy
    labels:
      - "traefik.enable=true"
      - "traefik.http.routers.cadvisor.rule=Host(\`${CADVISOR_DOMAIN}\`)"
      - "traefik.http.routers.cadvisor.entrypoints=websecure"
      - "traefik.http.routers.cadvisor.tls.certresolver=letsencrypt"
      - "traefik.http.services.cadvisor.loadbalancer.server.port=8080"

networks:
  proxy:
    external: true
EOF

    cd "$dir" && docker compose up -d
    show_install_result "cAdvisor" "https://${CADVISOR_DOMAIN}" "" "" "" "$dir"
}

install_traccar() {
    install_service "Traccar" "traccar" "traccar/traccar:latest" "8082" "" \
        "      - traccar_data:/opt/traccar"
    show_install_result "Traccar" "https://${LAST_INSTALL_DOMAIN}" "(criar no primeiro acesso)" "" "" "$LAST_INSTALL_DIR"
}

install_calcom() {
    install_service "Cal.com" "calcom" "calcom/cal.com:latest" "3000" \
        "      NEXT_PUBLIC_WEBAPP_URL: https://${TOOL_DOMAINS[calcom]}\n      NEXTAUTH_SECRET: $(generate_password 32)\n      CALENDSO_ENCRYPTION_KEY: $(generate_password 32)"
    show_install_result "Cal.com" "https://${LAST_INSTALL_DOMAIN}" "(criar no primeiro acesso)" "" "" "$LAST_INSTALL_DIR"
}

install_appsmith() {
    install_service "Appsmith" "appsmith" "appsmith/appsmith-ce:latest" "80" "" \
        "      - appsmith_data:/appsmith-stacks"
    show_install_result "Appsmith" "https://${LAST_INSTALL_DOMAIN}" "(criar no primeiro acesso)" "" "" "$LAST_INSTALL_DIR"
}

install_lowcoder() {
    install_service "LowCoder" "lowcoder" "lowcoderorg/lowcoder-ce:latest" "3000"
    show_install_result "LowCoder" "https://${LAST_INSTALL_DOMAIN}" "(criar no primeiro acesso)" "" "" "$LAST_INSTALL_DIR"
}

install_tooljet() {
    install_service "ToolJet" "tooljet" "tooljet/tooljet-ce:latest" "80" \
        "      TOOLJET_HOST: https://${TOOL_DOMAINS[tooljet]}\n      SECRET_KEY_BASE: $(generate_password 64)"
    show_install_result "ToolJet" "https://${LAST_INSTALL_DOMAIN}" "(criar no primeiro acesso)" "" "" "$LAST_INSTALL_DIR"
}

install_excalidraw() {
    install_service "Excalidraw" "excalidraw" "excalidraw/excalidraw:latest" "80"
    show_install_result "Excalidraw" "https://${LAST_INSTALL_DOMAIN}" "" "" "" "$LAST_INSTALL_DIR"
}

install_docuseal() {
    install_service "Docuseal" "docuseal" "docuseal/docuseal:latest" "3000" "" \
        "      - docuseal_data:/data"
    show_install_result "Docuseal" "https://${LAST_INSTALL_DOMAIN}" "(criar no primeiro acesso)" "" "" "$LAST_INSTALL_DIR"
}

install_documeso() {
    install_service "Documeso" "documeso" "documenso/documenso:latest" "3000"
    show_install_result "Documeso" "https://${LAST_INSTALL_DOMAIN}" "(criar no primeiro acesso)" "" "" "$LAST_INSTALL_DIR"
}

install_stirling_pdf() {
    install_service "Stirling PDF" "pdf" "frooodle/s-pdf:latest" "8080"
    show_install_result "Stirling PDF" "https://${LAST_INSTALL_DOMAIN}" "" "" "" "$LAST_INSTALL_DIR"
}

install_easy_appointments() {
    install_service "Easy!Appointments" "appointments" "alextselegidis/easyappointments:latest" "80" \
        "      BASE_URL: https://${TOOL_DOMAINS[appointments]}"
    show_install_result "Easy!Appointments" "https://${LAST_INSTALL_DOMAIN}" "(criar no primeiro acesso)" "" "" "$LAST_INSTALL_DIR"
}

install_wisemapping() {
    install_service "WiseMapping" "wisemapping" "wisemapping/wisemapping-open-source:latest" "8080"
    show_install_result "WiseMapping" "https://${LAST_INSTALL_DOMAIN}" "(criar no primeiro acesso)" "" "" "$LAST_INSTALL_DIR"
}

install_affine() {
    install_service "Affine" "affine" "ghcr.io/toeverything/affine-graphql:stable" "3010"
    show_install_result "Affine" "https://${LAST_INSTALL_DOMAIN}" "(criar no primeiro acesso)" "" "" "$LAST_INSTALL_DIR"
}

install_mattermost() {
    install_service "Mattermost" "mattermost" "mattermost/mattermost-team-edition:latest" "8065" "" \
        "      - mattermost_data:/mattermost"
    show_install_result "Mattermost" "https://${LAST_INSTALL_DOMAIN}" "(criar no primeiro acesso)" "" "" "$LAST_INSTALL_DIR"
}

install_odoo() {
    local ODOO_DOMAIN="${TOOL_DOMAINS[odoo]:-odoo.exemplo.com}"
    local pwd
    pwd=$(generate_password)
    local dir="$DOCKER_COMPOSE_DIR/odoo"
    mkdir -p "$dir"

    cat > "$dir/docker-compose.yml" << EOF
version: '3.8'

services:
  odoo-db:
    image: postgres:15
    container_name: odoo-db
    restart: unless-stopped
    environment:
      POSTGRES_DB: odoo
      POSTGRES_USER: odoo
      POSTGRES_PASSWORD: ${pwd}
    volumes:
      - odoo_db:/var/lib/postgresql/data
    networks:
      - proxy

  odoo:
    image: odoo:17
    container_name: odoo
    restart: unless-stopped
    depends_on:
      - odoo-db
    environment:
      HOST: odoo-db
      USER: odoo
      PASSWORD: ${pwd}
    volumes:
      - odoo_data:/var/lib/odoo
      - odoo_addons:/mnt/extra-addons
    networks:
      - proxy
    labels:
      - "traefik.enable=true"
      - "traefik.http.routers.odoo.rule=Host(\`${ODOO_DOMAIN}\`)"
      - "traefik.http.routers.odoo.entrypoints=websecure"
      - "traefik.http.routers.odoo.tls.certresolver=letsencrypt"
      - "traefik.http.services.odoo.loadbalancer.server.port=8069"

volumes:
  odoo_db:
  odoo_data:
  odoo_addons:

networks:
  proxy:
    external: true
EOF

    cd "$dir" && docker compose up -d
    show_install_result "Odoo" "https://${ODOO_DOMAIN}" "admin (definir no primeiro acesso)" "" "🔑 Senha DB: ${pwd}" "$dir"
}

install_frappe() {
    install_service "Frappe" "frappe" "frappe/bench:latest" "8000"
    show_install_result "Frappe" "https://${LAST_INSTALL_DOMAIN}" "(criar no primeiro acesso)" "" "" "$LAST_INSTALL_DIR"
}

install_keycloak() {
    local pwd
    pwd=$(generate_password)
    install_service "Keycloak" "keycloak" "quay.io/keycloak/keycloak:latest" "8080" \
        "      KEYCLOAK_ADMIN: admin\n      KEYCLOAK_ADMIN_PASSWORD: ${pwd}\n      KC_PROXY: edge\n      KC_HOSTNAME: ${TOOL_DOMAINS[keycloak]}" \
        "" \
        "    command: start"
    show_install_result "Keycloak" "https://${LAST_INSTALL_DOMAIN}" "admin" "$pwd" "" "$LAST_INSTALL_DIR"
}

install_vaultwarden() {
    install_service "VaultWarden" "vault" "vaultwarden/server:latest" "80" \
        "      DOMAIN: https://${TOOL_DOMAINS[vault]}" \
        "      - vaultwarden_data:/data"
    show_install_result "VaultWarden" "https://${LAST_INSTALL_DOMAIN}" "(criar no primeiro acesso)" "" "" "$LAST_INSTALL_DIR"
}

install_passbolt() {
    install_service "Passbolt" "passbolt" "passbolt/passbolt:latest-ce" "443" \
        "      APP_FULL_BASE_URL: https://${TOOL_DOMAINS[passbolt]}\n      DATASOURCES_DEFAULT_HOST: passbolt-db"
    show_install_result "Passbolt" "https://${LAST_INSTALL_DOMAIN}" "(criar no primeiro acesso)" "" "" "$LAST_INSTALL_DIR"
}

install_botpress() {
    install_service "Botpress" "botpress" "botpress/server:latest" "3000" \
        "      EXTERNAL_URL: https://${TOOL_DOMAINS[botpress]}"
    show_install_result "Botpress" "https://${LAST_INSTALL_DOMAIN}" "(criar no primeiro acesso)" "" "" "$LAST_INSTALL_DIR"
}

install_yourls() {
    local pwd
    pwd=$(generate_password)
    install_service "Yourls" "yourls" "yourls:latest" "80" \
        "      YOURLS_SITE: https://${TOOL_DOMAINS[yourls]}\n      YOURLS_USER: admin\n      YOURLS_PASS: ${pwd}"
    show_install_result "Yourls" "https://${LAST_INSTALL_DOMAIN}" "admin" "$pwd" "" "$LAST_INSTALL_DIR"
}

install_firecrawl() {
    install_service "Firecrawl" "firecrawl" "mendableai/firecrawl:latest" "3002"
    show_install_result "Firecrawl" "https://${LAST_INSTALL_DOMAIN}" "" "" "" "$LAST_INSTALL_DIR"
}

install_azuracast() {
    install_service "AzuraCast" "radio" "ghcr.io/azuracast/azuracast:latest" "80"
    show_install_result "AzuraCast" "https://${LAST_INSTALL_DOMAIN}" "(criar no primeiro acesso)" "" "" "$LAST_INSTALL_DIR"
}

install_shlink() {
    install_service "Shlink" "shlink" "shlinkio/shlink:latest" "8080" \
        "      DEFAULT_DOMAIN: ${TOOL_DOMAINS[shlink]}\n      IS_HTTPS_ENABLED: true\n      GEOLITE_LICENSE_KEY: ''"
    show_install_result "Shlink" "https://${LAST_INSTALL_DOMAIN}" "" "" "" "$LAST_INSTALL_DIR"
}

install_rustdesk() {
    install_service "RustDesk" "rustdesk" "rustdesk/rustdesk-server:latest" "21117"
    show_install_result "RustDesk" "https://${LAST_INSTALL_DOMAIN}" "" "" "" "$LAST_INSTALL_DIR"
}

install_hoppscotch() {
    install_service "Hoppscotch" "hoppscotch" "hoppscotch/hoppscotch:latest" "3000"
    show_install_result "Hoppscotch" "https://${LAST_INSTALL_DOMAIN}" "(criar no primeiro acesso)" "" "" "$LAST_INSTALL_DIR"
}

install_wppconnect() {
    install_service "WppConnect" "wppconnect" "wppconnect/server:latest" "21465"
    show_install_result "WppConnect" "https://${LAST_INSTALL_DOMAIN}" "" "" "" "$LAST_INSTALL_DIR"
}

install_quepasa() {
    install_service "Quepasa API" "quepasa" "quepasa/quepasa:latest" "31000"
    show_install_result "Quepasa API" "https://${LAST_INSTALL_DOMAIN}" "" "" "" "$LAST_INSTALL_DIR"
}

install_uno_api() {
    install_service "Uno API" "unoapi" "clfrags/unoapi-cloud:latest" "9876"
    show_install_result "Uno API" "https://${LAST_INSTALL_DOMAIN}" "" "" "" "$LAST_INSTALL_DIR"
}

install_wuzapi() {
    install_service "Wuzapi" "wuzapi" "asternic/wuzapi:latest" "8080"
    show_install_result "Wuzapi" "https://${LAST_INSTALL_DOMAIN}" "" "" "" "$LAST_INSTALL_DIR"
}

# ======================== MENU PRINCIPAL ========================

SELECTED_TOOLS=""

print_menu_item() {
    local num="$1"
    local icon="$2"
    local name="$3"
    local mark=" "
    if echo " $SELECTED_TOOLS " | grep -q " $num "; then
        mark="${GREEN}✔${NC}"
    fi
    printf "  %s %2s) %s %-28s" "$mark" "$num" "$icon" "$name"
}

print_menu_row() {
    local col1="$1"
    local col2="$2"
    if [[ -n "$col2" ]]; then
        echo -e "${BOLD}║${NC}${col1}${col2}${BOLD}║${NC}"
    else
        echo -e "${BOLD}║${NC}${col1}$(printf '%36s' '')${BOLD}║${NC}"
    fi
}

print_category_header() {
    local icon="$1"
    local name="$2"
    echo -e "${BOLD}╠════════════════════════════════════════════════════════════════════════╣${NC}"
    echo -e "${BOLD}║  ${CYAN}${icon} ${name}${NC}$(printf '%*s' $((64 - ${#name})) '')${BOLD}║${NC}"
    echo -e "${BOLD}╠════════════════════════════════════════════════════════════════════════╣${NC}"
}

print_items_two_col() {
    local -a items=("$@")
    local count=${#items[@]}
    local i=0
    while (( i < count )); do
        local col1="${items[$i]}"
        local col2=""
        if (( i + 1 < count )); then
            col2="${items[$((i+1))]}"
        fi
        print_menu_row "$col1" "$col2"
        i=$((i + 2))
    done
}

show_menu_page() {
    local page="$1"
    local total_pages=4
    
    print_banner
    echo ""
    echo -e "${BOLD}╔════════════════════════════════════════════════════════════════════════╗${NC}"
    echo -e "${BOLD}║         📦 ESCOLHA AS FERRAMENTAS PARA INSTALAR  ${CYAN}[Página ${page}/${total_pages}]${NC}${BOLD}       ║${NC}"
    echo -e "${BOLD}╠════════════════════════════════════════════════════════════════════════╣${NC}"
    
    if [[ -n "$SELECTED_TOOLS" ]]; then
        echo -e "${BOLD}║  ${GREEN}Selecionados: ${SELECTED_TOOLS}${NC}$(printf '%*s' $((52 - ${#SELECTED_TOOLS})) '')${BOLD}║${NC}"
    fi
    
    local -a items=()
    
    case $page in
        1)
            print_category_header "🔧" "INFRAESTRUTURA"
            items=()
            items+=("$(print_menu_item 1 '🔀' 'Traefik (Proxy Reverso)')")
            items+=("$(print_menu_item 2 '🐳' 'Portainer (Docker)')")
            items+=("$(print_menu_item 3 '📦' 'MinIO (Storage S3)')")
            items+=("$(print_menu_item 4 '🔔' 'Ntfy (Notificações)')")
            items+=("$(print_menu_item 5 '📄' 'Gotenberg (PDF API)')")
            items+=("$(print_menu_item 6 '📨' 'RabbitMQ (Broker)')")
            items+=("$(print_menu_item 7 '🌐' 'Browserless (Headless)')")
            print_items_two_col "${items[@]}"
            
            print_category_header "💬" "CHAT & WHATSAPP"
            items=()
            items+=("$(print_menu_item 8 '💬' 'Chatwoot (Atendimento)')")
            items+=("$(print_menu_item 9 '📱' 'Evolution API (WhatsApp)')")
            items+=("$(print_menu_item 10 '📲' 'WppConnect (WhatsApp)')")
            items+=("$(print_menu_item 11 '💭' 'Quepasa API (WhatsApp)')")
            items+=("$(print_menu_item 12 '✉️' 'Uno API (Mensagens)')")
            items+=("$(print_menu_item 13 '📡' 'Wuzapi (WhatsApp REST)')")
            print_items_two_col "${items[@]}"
            
            print_category_header "⚡" "AUTOMAÇÃO"
            items=()
            items+=("$(print_menu_item 14 '🔄' 'N8N (Workflows)')")
            items+=("$(print_menu_item 15 '🤖' 'Typebot (Chatbots)')")
            items+=("$(print_menu_item 16 '📧' 'Mautic (Marketing)')")
            print_items_two_col "${items[@]}"
            ;;
        2)
            print_category_header "🧠" "INTELIGÊNCIA ARTIFICIAL"
            items=()
            items+=("$(print_menu_item 17 '🌊' 'Flowise (LLM Builder)')")
            items+=("$(print_menu_item 18 '🤖' 'Dify AI (IA Platform)')")
            items+=("$(print_menu_item 19 '🦙' 'Ollama (LLMs Locais)')")
            items+=("$(print_menu_item 20 '🔗' 'LangFlow (LangChain)')")
            items+=("$(print_menu_item 21 '📊' 'Langfuse (LLM Obs.)')")
            items+=("$(print_menu_item 22 '📚' 'Anything LLM (Docs)')")
            items+=("$(print_menu_item 23 '🔍' 'Qdrant (Vector DB)')")
            items+=("$(print_menu_item 24 '🧬' 'ZEP (IA Memory)')")
            items+=("$(print_menu_item 25 '🧪' 'Evo AI (IA Evolutiva)')")
            items+=("$(print_menu_item 26 '⚡' 'Bolt (Dev com IA)')")
            print_items_two_col "${items[@]}"
            
            print_category_header "📋" "CRM & PROJETOS"
            items=()
            items+=("$(print_menu_item 27 '🐕' 'Woofed CRM')")
            items+=("$(print_menu_item 28 '🏢' 'TwentyCRM')")
            items+=("$(print_menu_item 29 '📈' 'Krayin CRM')")
            items+=("$(print_menu_item 30 '📁' 'OpenProject')")
            items+=("$(print_menu_item 31 '📌' 'Planka (Kanban)')")
            items+=("$(print_menu_item 32 '📋' 'Focalboard')")
            items+=("$(print_menu_item 33 '🎫' 'GLPI (Help Desk)')")
            items+=("$(print_menu_item 34 '📝' 'Formbricks (Forms)')")
            print_items_two_col "${items[@]}"
            ;;
        3)
            print_category_header "🗄️" "DATABASE & ADMIN"
            items=()
            items+=("$(print_menu_item 35 '🐘' 'PgAdmin 4')")
            items+=("$(print_menu_item 36 '🍃' 'MongoDB')")
            items+=("$(print_menu_item 37 '⚡' 'Supabase')")
            items+=("$(print_menu_item 38 '🐬' 'PhpMyAdmin')")
            items+=("$(print_menu_item 39 '📊' 'NocoDB')")
            items+=("$(print_menu_item 40 '📊' 'Baserow')")
            items+=("$(print_menu_item 41 '📊' 'Nocobase')")
            items+=("$(print_menu_item 42 '🏠' 'ClickHouse')")
            items+=("$(print_menu_item 43 '🔴' 'RedisInsight')")
            items+=("$(print_menu_item 44 '📈' 'Metabase')")
            print_items_two_col "${items[@]}"
            
            print_category_header "🌐" "CMS & SITES"
            items=()
            items+=("$(print_menu_item 45 '📰' 'WordPress')")
            items+=("$(print_menu_item 46 '🎯' 'Directus')")
            items+=("$(print_menu_item 47 '🚀' 'Strapi')")
            items+=("$(print_menu_item 48 '☁️' 'NextCloud')")
            items+=("$(print_menu_item 49 '📖' 'Wiki.js')")
            items+=("$(print_menu_item 50 '👥' 'HumHub')")
            items+=("$(print_menu_item 51 '📝' 'Outline')")
            items+=("$(print_menu_item 52 '🎓' 'Moodle')")
            print_items_two_col "${items[@]}"
            ;;
        4)
            print_category_header "📡" "MONITORAMENTO"
            items=()
            items+=("$(print_menu_item 53 '⬆️' 'Uptime Kuma')")
            items+=("$(print_menu_item 54 '📊' 'Grafana')")
            items+=("$(print_menu_item 55 '🔥' 'Prometheus')")
            items+=("$(print_menu_item 56 '📦' 'cAdvisor')")
            items+=("$(print_menu_item 57 '📍' 'Traccar (GPS)')")
            print_items_two_col "${items[@]}"
            
            print_category_header "🛠️" "PRODUTIVIDADE"
            items=()
            items+=("$(print_menu_item 58 '📅' 'Cal.com (Agenda)')")
            items+=("$(print_menu_item 59 '🏗️' 'Appsmith')")
            items+=("$(print_menu_item 60 '🔧' 'LowCoder')")
            items+=("$(print_menu_item 61 '🔨' 'ToolJet')")
            items+=("$(print_menu_item 62 '✏️' 'Excalidraw')")
            items+=("$(print_menu_item 63 '📄' 'Docuseal')")
            items+=("$(print_menu_item 64 '📄' 'Documeso')")
            items+=("$(print_menu_item 65 '📑' 'Stirling PDF')")
            items+=("$(print_menu_item 66 '📅' 'Easy!Appointments')")
            items+=("$(print_menu_item 67 '🧠' 'WiseMapping')")
            items+=("$(print_menu_item 68 '✨' 'Affine')")
            items+=("$(print_menu_item 69 '💬' 'Mattermost')")
            items+=("$(print_menu_item 70 '🏭' 'Odoo')")
            items+=("$(print_menu_item 71 '🔧' 'Frappe')")
            print_items_two_col "${items[@]}"
            
            print_category_header "🔒" "SEGURANÇA"
            items=()
            items+=("$(print_menu_item 72 '🔑' 'Keycloak (IAM)')")
            items+=("$(print_menu_item 73 '🔐' 'VaultWarden (Senhas)')")
            items+=("$(print_menu_item 74 '🗝️' 'Passbolt (Equipe)')")
            print_items_two_col "${items[@]}"
            
            print_category_header "📦" "OUTROS"
            items=()
            items+=("$(print_menu_item 75 '🤖' 'Botpress (Chatbot)')")
            items+=("$(print_menu_item 76 '🔗' 'Yourls (URL Shortener)')")
            items+=("$(print_menu_item 77 '🕷️' 'Firecrawl (Scraping)')")
            items+=("$(print_menu_item 78 '📻' 'AzuraCast (Rádio)')")
            items+=("$(print_menu_item 79 '🔗' 'Shlink (URLs)')")
            items+=("$(print_menu_item 80 '🖥️' 'RustDesk (Remoto)')")
            items+=("$(print_menu_item 81 '🧪' 'Hoppscotch (API)')")
            print_items_two_col "${items[@]}"
            ;;
    esac
    
    echo -e "${BOLD}╠════════════════════════════════════════════════════════════════════════╣${NC}"
    echo -e "${BOLD}║                                                                      ║${NC}"
    local nav=""
    if (( page > 1 )); then
        nav="${nav}${YELLOW}[P] ◀ Anterior${NC}   "
    fi
    if (( page < total_pages )); then
        nav="${nav}${YELLOW}[N] Próxima ▶${NC}   "
    fi
    nav="${nav}${GREEN}[0] ✅ Instalar tudo${NC}   ${RED}[99] ❌ Sair${NC}"
    echo -e "${BOLD}║${NC}  ${nav}${BOLD}  ║${NC}"
    echo -e "${BOLD}║  ${CYAN}[C] ✅ Confirmar e instalar selecionados${NC}${BOLD}                              ║${NC}"
    echo -e "${BOLD}║                                                                      ║${NC}"
    echo -e "${BOLD}╚════════════════════════════════════════════════════════════════════════╝${NC}"
    echo ""
}

show_menu() {
    local current_page=1
    SELECTED_TOOLS=""
    
    while true; do
        show_menu_page "$current_page"
        
        echo -e "  Digite os números separados por espaço, ou ${CYAN}N/P/C/0/99${NC}"
        read -rp "  > " input
        
        case "${input^^}" in
            N)
                if (( current_page < 4 )); then
                    current_page=$((current_page + 1))
                fi
                ;;
            P)
                if (( current_page > 1 )); then
                    current_page=$((current_page - 1))
                fi
                ;;
            99)
                choices="99"
                return
                ;;
            0)
                choices="0"
                return
                ;;
            C)
                if [[ -n "$SELECTED_TOOLS" ]]; then
                    choices="$SELECTED_TOOLS"
                    return
                else
                    echo -e "  ${RED}Nenhuma ferramenta selecionada!${NC}"
                    sleep 1
                fi
                ;;
            *)
                for num in $input; do
                    if [[ "$num" =~ ^[0-9]+$ ]] && (( num >= 1 && num <= 81 )); then
                        if echo " $SELECTED_TOOLS " | grep -q " $num "; then
                            SELECTED_TOOLS=$(echo "$SELECTED_TOOLS" | sed "s/\b$num\b//g" | xargs)
                        else
                            SELECTED_TOOLS="$SELECTED_TOOLS $num"
                            SELECTED_TOOLS=$(echo "$SELECTED_TOOLS" | xargs)
                        fi
                    fi
                done
                ;;
        esac
    done
}

# ======================== MAPEAMENTO DE INSTALAÇÃO ========================

run_install() {
    local num="$1"
    case $num in
        1) install_traefik ;;
        2) install_portainer ;;
        3) install_minio ;;
        4) install_ntfy ;;
        5) install_gotenberg ;;
        6) install_rabbitmq ;;
        7) install_browserless ;;
        8) install_chatwoot ;;
        9) install_evolution_api ;;
        10) install_wppconnect ;;
        11) install_quepasa ;;
        12) install_uno_api ;;
        13) install_wuzapi ;;
        14) install_n8n ;;
        15) install_typebot ;;
        16) install_mautic ;;
        17) install_flowise ;;
        18) install_dify ;;
        19) install_ollama ;;
        20) install_langflow ;;
        21) install_langfuse ;;
        22) install_anything_llm ;;
        23) install_qdrant ;;
        24) install_zep ;;
        25) install_evo_ai ;;
        26) install_bolt ;;
        27) install_woofed_crm ;;
        28) install_twentycrm ;;
        29) install_krayin_crm ;;
        30) install_openproject ;;
        31) install_planka ;;
        32) install_focalboard ;;
        33) install_glpi ;;
        34) install_formbricks ;;
        35) install_pgadmin ;;
        36) install_mongodb ;;
        37) install_supabase ;;
        38) install_phpmyadmin ;;
        39) install_nocodb ;;
        40) install_baserow ;;
        41) install_nocobase ;;
        42) install_clickhouse ;;
        43) install_redisinsight ;;
        44) install_metabase ;;
        45) install_wordpress ;;
        46) install_directus ;;
        47) install_strapi ;;
        48) install_nextcloud ;;
        49) install_wikijs ;;
        50) install_humhub ;;
        51) install_outline ;;
        52) install_moodle ;;
        53) install_uptime_kuma ;;
        54) install_grafana ;;
        55) install_prometheus ;;
        56) install_cadvisor ;;
        57) install_traccar ;;
        58) install_calcom ;;
        59) install_appsmith ;;
        60) install_lowcoder ;;
        61) install_tooljet ;;
        62) install_excalidraw ;;
        63) install_docuseal ;;
        64) install_documeso ;;
        65) install_stirling_pdf ;;
        66) install_easy_appointments ;;
        67) install_wisemapping ;;
        68) install_affine ;;
        69) install_mattermost ;;
        70) install_odoo ;;
        71) install_frappe ;;
        72) install_keycloak ;;
        73) install_vaultwarden ;;
        74) install_passbolt ;;
        75) install_botpress ;;
        76) install_yourls ;;
        77) install_firecrawl ;;
        78) install_azuracast ;;
        79) install_shlink ;;
        80) install_rustdesk ;;
        81) install_hoppscotch ;;
        *) log_warn "Opção $num inválida, pulando..." ;;
    esac
}

# ======================== DESINSTALAÇÃO ========================

TOOL_SUBDOMAIN_MAP=(
    [1]="traefik" [2]="portainer" [3]="minio" [4]="ntfy" [5]="gotenberg"
    [6]="rabbitmq" [7]="browserless" [8]="chatwoot" [9]="evolution"
    [10]="wppconnect" [11]="quepasa" [12]="unoapi" [13]="wuzapi"
    [14]="n8n" [15]="typebot" [16]="mautic" [17]="flowise" [18]="dify"
    [19]="ollama" [20]="langflow" [21]="langfuse" [22]="anythingllm"
    [23]="qdrant" [24]="zep" [25]="evoai" [26]="bolt" [27]="woofed"
    [28]="twentycrm" [29]="krayin" [30]="openproject" [31]="planka"
    [32]="focalboard" [33]="glpi" [34]="formbricks" [35]="pgadmin"
    [36]="mongodb" [37]="supabase" [38]="phpmyadmin" [39]="nocodb"
    [40]="baserow" [41]="nocobase" [42]="clickhouse" [43]="redisinsight"
    [44]="metabase" [45]="wordpress" [46]="directus" [47]="strapi"
    [48]="nextcloud" [49]="wikijs" [50]="humhub" [51]="outline"
    [52]="moodle" [53]="uptime" [54]="grafana" [55]="prometheus"
    [56]="cadvisor" [57]="traccar" [58]="calcom" [59]="appsmith"
    [60]="lowcoder" [61]="tooljet" [62]="excalidraw" [63]="docuseal"
    [64]="documeso" [65]="pdf" [66]="appointments" [67]="wisemapping"
    [68]="affine" [69]="mattermost" [70]="odoo" [71]="frappe"
    [72]="keycloak" [73]="vault" [74]="passbolt" [75]="botpress"
    [76]="yourls" [77]="firecrawl" [78]="radio" [79]="shlink"
    [80]="rustdesk" [81]="hoppscotch"
)

TOOL_NAME_MAP=(
    [1]="Traefik" [2]="Portainer" [3]="MinIO" [4]="Ntfy" [5]="Gotenberg"
    [6]="RabbitMQ" [7]="Browserless" [8]="Chatwoot" [9]="Evolution API"
    [10]="WppConnect" [11]="Quepasa" [12]="Uno API" [13]="Wuzapi"
    [14]="N8N" [15]="Typebot" [16]="Mautic" [17]="Flowise" [18]="Dify AI"
    [19]="Ollama" [20]="LangFlow" [21]="Langfuse" [22]="Anything LLM"
    [23]="Qdrant" [24]="ZEP" [25]="Evo AI" [26]="Bolt" [27]="Woofed CRM"
    [28]="TwentyCRM" [29]="Krayin CRM" [30]="OpenProject" [31]="Planka"
    [32]="Focalboard" [33]="GLPI" [34]="Formbricks" [35]="PgAdmin 4"
    [36]="MongoDB" [37]="Supabase" [38]="PhpMyAdmin" [39]="NocoDB"
    [40]="Baserow" [41]="Nocobase" [42]="ClickHouse" [43]="RedisInsight"
    [44]="Metabase" [45]="WordPress" [46]="Directus" [47]="Strapi"
    [48]="NextCloud" [49]="Wiki.js" [50]="HumHub" [51]="Outline"
    [52]="Moodle" [53]="Uptime Kuma" [54]="Grafana" [55]="Prometheus"
    [56]="cAdvisor" [57]="Traccar" [58]="Cal.com" [59]="Appsmith"
    [60]="LowCoder" [61]="ToolJet" [62]="Excalidraw" [63]="Docuseal"
    [64]="Documeso" [65]="Stirling PDF" [66]="Easy!Appointments"
    [67]="WiseMapping" [68]="Affine" [69]="Mattermost" [70]="Odoo"
    [71]="Frappe" [72]="Keycloak" [73]="VaultWarden" [74]="Passbolt"
    [75]="Botpress" [76]="Yourls" [77]="Firecrawl" [78]="AzuraCast"
    [79]="Shlink" [80]="RustDesk" [81]="Hoppscotch"
)

BACKUP_DIR="/opt/vemfazer-backups"

backup_volumes() {
    local subdomain="$1"
    local name="$2"
    local dir="$DOCKER_COMPOSE_DIR/${subdomain}"
    
    local timestamp
    timestamp=$(date +%Y%m%d_%H%M%S)
    local backup_path="${BACKUP_DIR}/${subdomain}_${timestamp}"
    mkdir -p "$backup_path"
    
    log_info "Fazendo backup dos volumes de ${name}..."
    
    # Backup dos arquivos de configuração
    cp -r "$dir" "${backup_path}/compose-config" 2>/dev/null || true
    
    # Listar volumes Docker associados ao serviço
    local volumes
    volumes=$(cd "$dir" && docker compose config --volumes 2>/dev/null)
    
    if [[ -n "$volumes" ]]; then
        while IFS= read -r vol; do
            local full_vol
            # Docker Compose nomeia volumes como: <project>_<volume>
            full_vol=$(docker volume ls --format '{{.Name}}' | grep -E "(${subdomain}|$(basename "$dir")).*${vol}" | head -1)
            
            if [[ -n "$full_vol" ]]; then
                log_info "  Salvando volume: ${full_vol}..."
                docker run --rm \
                    -v "${full_vol}:/source:ro" \
                    -v "${backup_path}:/backup" \
                    alpine tar czf "/backup/vol_${vol}.tar.gz" -C /source . 2>/dev/null
                
                if [[ $? -eq 0 ]]; then
                    log_success "  Volume ${vol} salvo!"
                else
                    log_warn "  Não foi possível salvar volume ${vol}"
                fi
            fi
        done <<< "$volumes"
    fi
    
    # Backup de bind mounts (dados locais na pasta do serviço)
    local data_dirs=("data" "storage" "db" "config")
    for ddir in "${data_dirs[@]}"; do
        if [[ -d "$dir/$ddir" ]]; then
            log_info "  Salvando diretório: ${ddir}..."
            tar czf "${backup_path}/dir_${ddir}.tar.gz" -C "$dir" "$ddir" 2>/dev/null || true
        fi
    done
    
    # Calcular tamanho total do backup
    local size
    size=$(du -sh "$backup_path" 2>/dev/null | awk '{print $1}')
    
    log_success "Backup de ${name} concluído! (${size})"
    echo -e "  📁 Local: ${CYAN}${backup_path}${NC}"
}

restore_backup() {
    echo ""
    echo -e "${BOLD}Backups disponíveis:${NC}"
    echo "─────────────────────────────────────────────────────"
    
    if [[ ! -d "$BACKUP_DIR" ]] || [[ -z "$(ls -A "$BACKUP_DIR" 2>/dev/null)" ]]; then
        log_warn "Nenhum backup encontrado em ${BACKUP_DIR}"
        return
    fi
    
    local i=1
    declare -A backup_list
    for bkp in "$BACKUP_DIR"/*/; do
        local bname
        bname=$(basename "$bkp")
        local bsize
        bsize=$(du -sh "$bkp" 2>/dev/null | awk '{print $1}')
        local bdate
        bdate=$(echo "$bname" | grep -oP '\d{8}_\d{6}' | sed 's/\(.\{4\}\)\(.\{2\}\)\(.\{2\}\)_\(.\{2\}\)\(.\{2\}\)\(.\{2\}\)/\1-\2-\3 \4:\5:\6/')
        echo -e "  ${CYAN}${i})${NC} ${bname} — ${bsize} — ${bdate}"
        backup_list[$i]="$bkp"
        ((i++))
    done
    
    echo ""
    echo -e "  ${GREEN}99)${NC} Voltar"
    echo ""
    read -rp "Selecione o backup para restaurar: " bkp_choice
    
    if [[ "$bkp_choice" == "99" ]]; then
        return
    fi
    
    local selected="${backup_list[$bkp_choice]}"
    if [[ -z "$selected" ]]; then
        log_warn "Opção inválida"
        return
    fi
    
    local tool_name
    tool_name=$(basename "$selected" | sed 's/_[0-9]\{8\}_[0-9]\{6\}$//')
    local target_dir="$DOCKER_COMPOSE_DIR/${tool_name}"
    
    echo ""
    echo -e "${YELLOW}Restaurar backup para ${target_dir}?${NC}"
    read -rp "$(echo -e ${YELLOW}'Confirmar? [s/N]: '${NC})" confirm
    
    if [[ "${confirm,,}" != "s" ]]; then
        log_info "Restauração cancelada."
        return
    fi
    
    mkdir -p "$target_dir"
    
    # Restaurar configuração
    if [[ -d "${selected}/compose-config" ]]; then
        cp -r "${selected}/compose-config/"* "$target_dir/" 2>/dev/null || true
        log_success "Configuração restaurada!"
    fi
    
    # Restaurar volumes
    for vol_file in "${selected}"/vol_*.tar.gz; do
        [[ -f "$vol_file" ]] || continue
        local vol_name
        vol_name=$(basename "$vol_file" | sed 's/^vol_//;s/\.tar\.gz$//')
        log_info "Restaurando volume: ${vol_name}..."
        
        local full_vol="${tool_name}_${vol_name}"
        docker volume create "$full_vol" 2>/dev/null || true
        docker run --rm \
            -v "${full_vol}:/target" \
            -v "$(dirname "$vol_file"):/backup:ro" \
            alpine sh -c "cd /target && tar xzf /backup/$(basename "$vol_file")" 2>/dev/null
        log_success "Volume ${vol_name} restaurado!"
    done
    
    # Subir o serviço
    if [[ -f "$target_dir/docker-compose.yml" ]]; then
        cd "$target_dir" && docker compose up -d
        log_success "Serviço ${tool_name} restaurado e iniciado!"
    fi
}

uninstall_service() {
    local num="$1"
    local subdomain="${TOOL_SUBDOMAIN_MAP[$num]}"
    local name="${TOOL_NAME_MAP[$num]}"
    local dir="$DOCKER_COMPOSE_DIR/${subdomain}"
    
    if [[ -z "$subdomain" ]]; then
        log_warn "Opção $num inválida, pulando..."
        return
    fi
    
    if [[ ! -d "$dir" ]]; then
        log_warn "${name} não está instalado (pasta $dir não encontrada)"
        return
    fi
    
    # Backup automático antes de desinstalar
    backup_volumes "$subdomain" "$name"
    
    log_info "Desinstalando ${name}..."
    cd "$dir" && docker compose down -v 2>/dev/null || true
    rm -rf "$dir"
    log_success "${name} desinstalado com sucesso!"
}

list_installed() {
    echo ""
    echo -e "${BOLD}Ferramentas instaladas:${NC}"
    echo "─────────────────────────────────────────────────────"
    
    local count=0
    for num in $(seq 1 81); do
        local subdomain="${TOOL_SUBDOMAIN_MAP[$num]}"
        local name="${TOOL_NAME_MAP[$num]}"
        local dir="$DOCKER_COMPOSE_DIR/${subdomain}"
        
        if [[ -d "$dir" ]]; then
            local status
            if cd "$dir" && docker compose ps --status running 2>/dev/null | grep -q "$subdomain"; then
                status="${GREEN}● rodando${NC}"
            else
                status="${RED}● parado${NC}"
            fi
            echo -e "  ${CYAN}${num})${NC} ${name} [${status}] — ${dir}"
            ((count++))
        fi
    done
    
    if [[ $count -eq 0 ]]; then
        echo -e "  ${YELLOW}Nenhuma ferramenta instalada.${NC}"
    else
        echo ""
        echo -e "  Total: ${CYAN}${count}${NC} ferramenta(s)"
    fi
    echo "─────────────────────────────────────────────────────"
}

show_uninstall_menu() {
    print_banner
    list_installed
    echo ""
    echo -e "${BOLD}Opções de desinstalação:${NC}"
    echo ""
    echo -e "  Digite os números das ferramentas para remover (ex: ${CYAN}8 14 15${NC})"
    echo -e "  ${RED}0) DESINSTALAR TUDO${NC}"
    echo -e "  ${GREEN}99) Voltar ao menu principal${NC}"
    echo ""
    read -rp "> " uninstall_choices
    
    if [[ "$uninstall_choices" == "99" ]]; then
        return
    fi
    
    if [[ "$uninstall_choices" == "0" ]]; then
        echo ""
        echo -e "${RED}⚠️  ATENÇÃO: Isso vai remover TODAS as ferramentas e seus dados!${NC}"
        read -rp "$(echo -e ${RED}'Tem certeza? Digite SIM para confirmar: '${NC})" confirm
        if [[ "$confirm" != "SIM" ]]; then
            log_info "Desinstalação cancelada."
            return
        fi
        uninstall_choices=$(seq 1 81 | tr '\n' ' ')
    else
        echo ""
        echo -e "${YELLOW}⚠️  Os dados das ferramentas selecionadas serão perdidos!${NC}"
        read -rp "$(echo -e ${YELLOW}'Confirmar desinstalação? [s/N]: '${NC})" confirm
        if [[ "${confirm,,}" != "s" ]]; then
            log_info "Desinstalação cancelada."
            return
        fi
    fi
    
    echo ""
    for choice in $uninstall_choices; do
        uninstall_service "$choice"
    done
    
    echo ""
    log_success "Desinstalação concluída!"
    echo ""
    read -rp "$(echo -e ${CYAN}'Pressione ENTER para continuar...'${NC})" _
}

restart_service() {
    local num="$1"
    local subdomain="${TOOL_SUBDOMAIN_MAP[$num]}"
    local name="${TOOL_NAME_MAP[$num]}"
    local dir="$DOCKER_COMPOSE_DIR/${subdomain}"
    
    if [[ ! -d "$dir" ]]; then
        log_warn "${name} não está instalado"
        return
    fi
    
    log_info "Reiniciando ${name}..."
    cd "$dir" && docker compose restart
    log_success "${name} reiniciado!"
}

show_manage_menu() {
    print_banner
    list_installed
    echo ""
    echo -e "${BOLD}Gerenciamento:${NC}"
    echo ""
    echo "  Digite o número da ferramenta seguido da ação:"
    echo -e "  ${CYAN}start <num>${NC}   — Iniciar"
    echo -e "  ${CYAN}stop <num>${NC}    — Parar"
    echo -e "  ${CYAN}restart <num>${NC} — Reiniciar"
    echo -e "  ${CYAN}logs <num>${NC}    — Ver logs"
    echo -e "  ${CYAN}update <num>${NC}  — Atualizar imagem"
    echo -e "  ${GREEN}99${NC}            — Voltar"
    echo ""
    read -rp "> " action target_num
    
    if [[ "$action" == "99" ]]; then
        return
    fi
    
    local subdomain="${TOOL_SUBDOMAIN_MAP[$target_num]}"
    local name="${TOOL_NAME_MAP[$target_num]}"
    local dir="$DOCKER_COMPOSE_DIR/${subdomain}"
    
    if [[ -z "$subdomain" || ! -d "$dir" ]]; then
        log_warn "Ferramenta não encontrada ou não instalada"
        read -rp "$(echo -e ${CYAN}'Pressione ENTER...'${NC})" _
        show_manage_menu
        return
    fi
    
    case "$action" in
        start)
            log_info "Iniciando ${name}..."
            cd "$dir" && docker compose up -d
            log_success "${name} iniciado!"
            ;;
        stop)
            log_info "Parando ${name}..."
            cd "$dir" && docker compose down
            log_success "${name} parado!"
            ;;
        restart)
            restart_service "$target_num"
            ;;
        logs)
            log_info "Logs de ${name} (Ctrl+C para sair):"
            cd "$dir" && docker compose logs -f --tail 50
            ;;
        update)
            log_info "Atualizando ${name}..."
            cd "$dir" && docker compose pull && docker compose up -d
            log_success "${name} atualizado!"
            ;;
        *)
            log_warn "Ação inválida: $action"
            ;;
    esac
    
    echo ""
    read -rp "$(echo -e ${CYAN}'Pressione ENTER para continuar...'${NC})" _
    show_manage_menu
}

# ======================== EXECUÇÃO PRINCIPAL ========================

show_main_menu() {
    print_banner
    echo -e "${BOLD}O que deseja fazer?${NC}"
    echo ""
    echo -e "  ${GREEN}1)${NC} 📦 Instalar ferramentas"
    echo -e "  ${CYAN}2)${NC} 📋 Listar ferramentas instaladas"
    echo -e "  ${YELLOW}3)${NC} 🔧 Gerenciar ferramentas (start/stop/restart/logs/update)"
    echo -e "  ${RED}4)${NC} 🗑️  Desinstalar ferramentas"
    echo -e "  ${BLUE}5)${NC} 💾 Restaurar backup"
    echo -e "  ${WHITE}6)${NC} 🔑 Ver credenciais salvas"
    echo -e "  ${MAGENTA}99)${NC} Sair"
    echo ""
    read -rp "> " main_choice
}

main() {
    check_root
    check_os
    pre_install_checks
    accept_terms
    
    while true; do
        show_main_menu
        
        case "$main_choice" in
            1)
                print_banner
                check_requirements
                echo ""
                install_docker
                install_docker_compose
                
                if [[ -z "$EMAIL" ]]; then
                    setup_initial
                fi
                
                show_menu
                
                if [[ "$choices" == "99" ]]; then
                    continue
                fi
                
                if [[ "$choices" == "0" ]]; then
                    choices=$(seq 1 81 | tr '\n' ' ')
                fi
                
                # Resolver dependências automaticamente
                echo ""
                choices=$(resolve_dependencies "$choices")
                echo ""
                
                # Perguntar subdomínio individual de cada ferramenta
                if ! ask_subdomains "$choices"; then
                    continue
                fi
                
                # Instalar Traefik primeiro se selecionado ou necessário
                if [[ "$TRAEFIK_INSTALLED" == false ]] && [[ ! -d "$DOCKER_COMPOSE_DIR/traefik" ]]; then
                    echo ""
                    echo -e "${YELLOW}Traefik (proxy reverso) é necessário para as demais ferramentas.${NC}"
                    read -rp "$(echo -e ${CYAN}'Instalar Traefik agora? [S/n]: '${NC})" install_traefik_choice
                    if [[ "${install_traefik_choice,,}" != "n" ]]; then
                        install_traefik
                    fi
                fi
                
                echo ""
                log_info "Iniciando instalação das ferramentas selecionadas..."
                echo ""
                
                for choice in $choices; do
                    [[ "$choice" == "1" ]] && continue  # Traefik já tratado acima
                    run_install "$choice"
                    echo ""
                done
                
                echo ""
                echo -e "${GREEN}╔══════════════════════════════════════════════════════════════╗${NC}"
                echo -e "${GREEN}║                                                            ║${NC}"
                echo -e "${GREEN}║   ✅ INSTALAÇÃO CONCLUÍDA COM SUCESSO!                     ║${NC}"
                echo -e "${GREEN}║                                                            ║${NC}"
                echo -e "${GREEN}║   📺 Canal: youtube.com/@VemFazer                          ║${NC}"
                echo -e "${GREEN}║   🚀 Setup Vem Fazer - Raphael Batista                     ║${NC}"
                echo -e "${GREEN}║                                                            ║${NC}"
                echo -e "${GREEN}╚══════════════════════════════════════════════════════════════╝${NC}"
                echo ""
                
                # Exibir resumo final com credenciais salvas
                if [[ -f "$CREDENTIALS_FILE" ]]; then
                    echo -e "${BOLD}╔══════════════════════════════════════════════════════════════════╗${NC}"
                    echo -e "${BOLD}║  📋 RESUMO GERAL — TODAS AS CREDENCIAIS                       ║${NC}"
                    echo -e "${BOLD}╠══════════════════════════════════════════════════════════════════╣${NC}"
                    echo -e "${BOLD}║  📁 Salvas em: ${CYAN}/root/vemfazer-credenciais.txt${NC}${BOLD}                 ║${NC}"
                    echo -e "${BOLD}╚══════════════════════════════════════════════════════════════════╝${NC}"
                    echo ""
                    cat "$CREDENTIALS_FILE"
                    echo ""
                    echo -e "${YELLOW}⚠️  IMPORTANTE: Guarde essas credenciais em local seguro!${NC}"
                    echo -e "${YELLOW}   Arquivo salvo em: ${CYAN}/root/vemfazer-credenciais.txt${NC}"
                fi
                echo ""
                read -rp "$(echo -e ${CYAN}'Pressione ENTER para continuar...'${NC})" _
                ;;
            2)
                list_installed
                echo ""
                read -rp "$(echo -e ${CYAN}'Pressione ENTER para continuar...'${NC})" _
                ;;
            3)
                show_manage_menu
                ;;
            4)
                show_uninstall_menu
                ;;
            5)
                restore_backup
                echo ""
                read -rp "$(echo -e ${CYAN}'Pressione ENTER para continuar...'${NC})" _
                ;;
            6)
                echo ""
                if [[ -f "$CREDENTIALS_FILE" ]]; then
                    echo -e "${BOLD}╔══════════════════════════════════════════════════════════════════╗${NC}"
                    echo -e "${BOLD}║  🔑 CREDENCIAIS SALVAS                                        ║${NC}"
                    echo -e "${BOLD}╠══════════════════════════════════════════════════════════════════╣${NC}"
                    echo -e "${BOLD}║  📁 Arquivo: ${CYAN}/root/vemfazer-credenciais.txt${NC}${BOLD}                    ║${NC}"
                    echo -e "${BOLD}╚══════════════════════════════════════════════════════════════════╝${NC}"
                    echo ""
                    cat "$CREDENTIALS_FILE"
                else
                    echo -e "${YELLOW}⚠️  Nenhuma credencial salva ainda. Instale ferramentas primeiro.${NC}"
                fi
                echo ""
                read -rp "$(echo -e ${CYAN}'Pressione ENTER para continuar...'${NC})" _
                ;;
            99)
                echo -e "${GREEN}Até logo! 🚀${NC}"
                exit 0
                ;;
            *)
                log_warn "Opção inválida!"
                sleep 1
                ;;
        esac
    done
}

main "$@"
