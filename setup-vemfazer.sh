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
        
        # Typebot precisa de 2 subdomínios
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
    if [[ -n "$traefik_domain" ]]; then
        log_success "Traefik instalado! Dashboard: https://${traefik_domain}"
    else
        log_success "Traefik instalado!"
    fi
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
    log_success "${name} instalado! Acesse: https://${full_domain}"
}

# ======================== FUNÇÕES DE INSTALAÇÃO ESPECÍFICAS ========================

install_portainer() {
    install_service "Portainer" "portainer" "portainer/portainer-ce:latest" "9000" "" \
        "      - /var/run/docker.sock:/var/run/docker.sock\n      - portainer_data:/data"
}

install_minio() {
    local pwd
    pwd=$(generate_password)
    install_service "MinIO" "minio" "minio/minio:latest" "9001" \
        "      MINIO_ROOT_USER: admin\n      MINIO_ROOT_PASSWORD: ${pwd}" \
        "      - minio_data:/data" \
        "    command: server /data --console-address ':9001'"
    echo -e "  ${YELLOW}Senha MinIO: ${pwd}${NC}"
}

install_ntfy() {
    install_service "Ntfy" "ntfy" "binwiederhier/ntfy:latest" "80" "" \
        "      - ntfy_data:/var/cache/ntfy" \
        "    command: serve"
}

install_gotenberg() {
    install_service "Gotenberg" "gotenberg" "gotenberg/gotenberg:8" "3000"
}

install_rabbitmq() {
    local pwd
    pwd=$(generate_password)
    install_service "RabbitMQ" "rabbitmq" "rabbitmq:3-management" "15672" \
        "      RABBITMQ_DEFAULT_USER: admin\n      RABBITMQ_DEFAULT_PASS: ${pwd}"
    echo -e "  ${YELLOW}Senha RabbitMQ: ${pwd}${NC}"
}

install_browserless() {
    local token
    token=$(generate_password 16)
    install_service "Browserless" "browserless" "browserless/chrome:latest" "3000" \
        "      TOKEN: ${token}"
    echo -e "  ${YELLOW}Token Browserless: ${token}${NC}"
}

install_chatwoot() {
    local CHATWOOT_DOMAIN="${TOOL_DOMAINS[chatwoot]:-chatwoot.exemplo.com}"
    local secret
    secret=$(generate_password 32)
    local dir="$DOCKER_COMPOSE_DIR/chatwoot"
    mkdir -p "$dir"
    
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
      SECRET_KEY_BASE: $(generate_password 64)
      FRONTEND_URL: https://${CHATWOOT_DOMAIN}
      DATABASE_URL: postgres://chatwoot:${secret}@chatwoot-db:5432/chatwoot
      REDIS_URL: redis://chatwoot-redis:6379
      RAILS_ENV: production
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

volumes:
  chatwoot_db:

networks:
  proxy:
    external: true
EOF

    cd "$dir" && docker compose up -d
    log_success "Chatwoot instalado! Acesse: https://${CHATWOOT_DOMAIN}"
}

install_evolution_api() {
    local key
    key=$(generate_password 32)
    install_service "Evolution API" "evolution" "atendai/evolution-api:latest" "8080" \
        "      AUTHENTICATION_API_KEY: ${key}"
    echo -e "  ${YELLOW}API Key Evolution: ${key}${NC}"
}

install_n8n() {
    install_service "N8N" "n8n" "docker.n8n.io/n8nio/n8n:latest" "5678" \
        "      N8N_HOST: ${TOOL_DOMAINS[n8n]}\n      N8N_PROTOCOL: https\n      WEBHOOK_URL: https://${TOOL_DOMAINS[n8n]}/" \
        "      - n8n_data:/home/node/.n8n"
}

install_typebot() {
    local TYPEBOT_BUILDER_DOMAIN="${TOOL_DOMAINS[typebot]:-typebot.exemplo.com}"
    local TYPEBOT_VIEWER_DOMAIN="${TOOL_DOMAINS[typebot-viewer]:-bot.exemplo.com}"
    local secret
    secret=$(generate_password 32)
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
      ENCRYPTION_SECRET: $(generate_password 32)
      NEXTAUTH_SECRET: $(generate_password 32)
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
      ENCRYPTION_SECRET: $(generate_password 32)
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
    log_success "Typebot instalado! Builder: https://${TYPEBOT_BUILDER_DOMAIN} | Viewer: https://${TYPEBOT_VIEWER_DOMAIN}"
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
    log_success "Mautic instalado! Acesse: https://${MAUTIC_DOMAIN}"
}

install_flowise() {
    install_service "Flowise" "flowise" "flowiseai/flowise:latest" "3000" \
        "      FLOWISE_USERNAME: admin\n      FLOWISE_PASSWORD: $(generate_password)" \
        "      - flowise_data:/root/.flowise"
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
    log_success "Dify AI instalado!"
}

install_ollama() {
    install_service "Ollama" "ollama" "ollama/ollama:latest" "11434" "" \
        "      - ollama_data:/root/.ollama"
}

install_langflow() {
    install_service "LangFlow" "langflow" "langflowai/langflow:latest" "7860"
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
    log_success "Langfuse instalado! Acesse: https://${LANGFUSE_DOMAIN}"
}

install_anything_llm() {
    install_service "Anything LLM" "anythingllm" "mintplexlabs/anythingllm:latest" "3001" \
        "      STORAGE_DIR: /app/server/storage" \
        "      - anythingllm_data:/app/server/storage"
}

install_qdrant() {
    install_service "Qdrant" "qdrant" "qdrant/qdrant:latest" "6333" "" \
        "      - qdrant_data:/qdrant/storage"
}

install_zep() {
    install_service "ZEP" "zep" "ghcr.io/getzep/zep:latest" "8000"
}

install_evo_ai() {
    install_service "Evo AI" "evoai" "evoai/evoai:latest" "8000"
}

install_bolt() {
    install_service "Bolt" "bolt" "ghcr.io/stackblitz-labs/bolt.diy:latest" "5173"
}

install_woofed_crm() {
    install_service "Woofed CRM" "woofed" "woofedcrm/woofedcrm:latest" "3000"
}

install_twentycrm() {
    install_service "TwentyCRM" "twentycrm" "twentycrm/twenty:latest" "3000"
}

install_krayin_crm() {
    install_service "Krayin CRM" "krayin" "krayincrm/krayin:latest" "80"
}

install_openproject() {
    local pwd
    pwd=$(generate_password)
    install_service "OpenProject" "openproject" "openproject/openproject:14" "8080" \
        "      OPENPROJECT_SECRET_KEY_BASE: $(generate_password 64)\n      OPENPROJECT_HOST__NAME: ${TOOL_DOMAINS[openproject]}\n      OPENPROJECT_HTTPS: true"
}

install_planka() {
    install_service "Planka" "planka" "ghcr.io/plankanban/planka:latest" "1337" \
        "      BASE_URL: https://${TOOL_DOMAINS[planka]}\n      SECRET_KEY: $(generate_password 64)\n      DEFAULT_ADMIN_EMAIL: ${EMAIL}\n      DEFAULT_ADMIN_PASSWORD: $(generate_password)"
}

install_focalboard() {
    install_service "Focalboard" "focalboard" "mattermost/focalboard:latest" "8000"
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
    log_success "GLPI instalado! Acesse: https://${GLPI_DOMAIN}"
}

install_formbricks() {
    install_service "Formbricks" "formbricks" "formbricks/formbricks:latest" "3000" \
        "      WEBAPP_URL: https://${TOOL_DOMAINS[formbricks]}\n      NEXTAUTH_SECRET: $(generate_password 32)\n      ENCRYPTION_KEY: $(generate_password 32)"
}

install_pgadmin() {
    local pwd
    pwd=$(generate_password)
    install_service "PgAdmin 4" "pgadmin" "dpage/pgadmin4:latest" "80" \
        "      PGADMIN_DEFAULT_EMAIL: ${EMAIL}\n      PGADMIN_DEFAULT_PASSWORD: ${pwd}"
    echo -e "  ${YELLOW}Senha PgAdmin: ${pwd}${NC}"
}

install_mongodb() {
    local pwd
    pwd=$(generate_password)
    install_service "MongoDB" "mongodb" "mongo:7" "27017" \
        "      MONGO_INITDB_ROOT_USERNAME: admin\n      MONGO_INITDB_ROOT_PASSWORD: ${pwd}" \
        "      - mongodb_data:/data/db"
    echo -e "  ${YELLOW}Senha MongoDB: ${pwd}${NC}"
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
    log_success "Supabase instalado!"
}

install_phpmyadmin() {
    install_service "PhpMyAdmin" "phpmyadmin" "phpmyadmin/phpmyadmin:latest" "80" \
        "      PMA_ARBITRARY: 1"
}

install_nocodb() {
    install_service "NocoDB" "nocodb" "nocodb/nocodb:latest" "8080" "" \
        "      - nocodb_data:/usr/app/data"
}

install_baserow() {
    install_service "Baserow" "baserow" "baserow/baserow:latest" "80" \
        "      BASEROW_PUBLIC_URL: https://${TOOL_DOMAINS[baserow]}" \
        "      - baserow_data:/baserow/data"
}

install_nocobase() {
    install_service "Nocobase" "nocobase" "nocobase/nocobase:latest" "13000"
}

install_clickhouse() {
    install_service "ClickHouse" "clickhouse" "clickhouse/clickhouse-server:latest" "8123" "" \
        "      - clickhouse_data:/var/lib/clickhouse"
}

install_redisinsight() {
    install_service "RedisInsight" "redisinsight" "redis/redisinsight:latest" "5540"
}

install_metabase() {
    install_service "Metabase" "metabase" "metabase/metabase:latest" "3000"
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
    log_success "WordPress instalado! Acesse: https://${WORDPRESS_DOMAIN}"
}

install_directus() {
    local pwd
    pwd=$(generate_password)
    install_service "Directus" "directus" "directus/directus:latest" "8055" \
        "      KEY: $(generate_password 32)\n      SECRET: $(generate_password 32)\n      ADMIN_EMAIL: ${EMAIL}\n      ADMIN_PASSWORD: ${pwd}"
    echo -e "  ${YELLOW}Senha Directus: ${pwd}${NC}"
}

install_strapi() {
    install_service "Strapi" "strapi" "strapi/strapi:latest" "1337"
}

install_nextcloud() {
    local pwd
    pwd=$(generate_password)
    install_service "NextCloud" "nextcloud" "nextcloud:latest" "80" \
        "      NEXTCLOUD_ADMIN_USER: admin\n      NEXTCLOUD_ADMIN_PASSWORD: ${pwd}\n      NEXTCLOUD_TRUSTED_DOMAINS: ${TOOL_DOMAINS[nextcloud]}" \
        "      - nextcloud_data:/var/www/html"
    echo -e "  ${YELLOW}Senha NextCloud: ${pwd}${NC}"
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
    log_success "Wiki.js instalado! Acesse: https://${WIKIJS_DOMAIN}"
}

install_humhub() {
    install_service "HumHub" "humhub" "mriedmann/humhub:latest" "80"
}

install_outline() {
    install_service "Outline" "outline" "outlinewiki/outline:latest" "3000" \
        "      URL: https://${TOOL_DOMAINS[outline]}\n      SECRET_KEY: $(generate_password 32)\n      UTILS_SECRET: $(generate_password 32)"
}

install_moodle() {
    install_service "Moodle" "moodle" "bitnami/moodle:latest" "8080" \
        "      MOODLE_USERNAME: admin\n      MOODLE_PASSWORD: $(generate_password)\n      MOODLE_EMAIL: ${EMAIL}\n      MOODLE_SITE_NAME: Vem Fazer"
}

install_uptime_kuma() {
    install_service "Uptime Kuma" "uptime" "louislam/uptime-kuma:latest" "3001" "" \
        "      - uptime_data:/app/data"
}

install_grafana() {
    install_service "Grafana" "grafana" "grafana/grafana:latest" "3000" \
        "      GF_SECURITY_ADMIN_PASSWORD: $(generate_password)" \
        "      - grafana_data:/var/lib/grafana"
}

install_prometheus() {
    install_service "Prometheus" "prometheus" "prom/prometheus:latest" "9090" "" \
        "      - prometheus_data:/prometheus"
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
    log_success "cAdvisor instalado! Acesse: https://${CADVISOR_DOMAIN}"
}

install_traccar() {
    install_service "Traccar" "traccar" "traccar/traccar:latest" "8082" "" \
        "      - traccar_data:/opt/traccar"
}

install_calcom() {
    install_service "Cal.com" "calcom" "calcom/cal.com:latest" "3000" \
        "      NEXT_PUBLIC_WEBAPP_URL: https://${TOOL_DOMAINS[calcom]}\n      NEXTAUTH_SECRET: $(generate_password 32)\n      CALENDSO_ENCRYPTION_KEY: $(generate_password 32)"
}

install_appsmith() {
    install_service "Appsmith" "appsmith" "appsmith/appsmith-ce:latest" "80" "" \
        "      - appsmith_data:/appsmith-stacks"
}

install_lowcoder() {
    install_service "LowCoder" "lowcoder" "lowcoderorg/lowcoder-ce:latest" "3000"
}

install_tooljet() {
    install_service "ToolJet" "tooljet" "tooljet/tooljet-ce:latest" "80" \
        "      TOOLJET_HOST: https://${TOOL_DOMAINS[tooljet]}\n      SECRET_KEY_BASE: $(generate_password 64)"
}

install_excalidraw() {
    install_service "Excalidraw" "excalidraw" "excalidraw/excalidraw:latest" "80"
}

install_docuseal() {
    install_service "Docuseal" "docuseal" "docuseal/docuseal:latest" "3000" "" \
        "      - docuseal_data:/data"
}

install_documeso() {
    install_service "Documeso" "documeso" "documenso/documenso:latest" "3000"
}

install_stirling_pdf() {
    install_service "Stirling PDF" "pdf" "frooodle/s-pdf:latest" "8080"
}

install_easy_appointments() {
    install_service "Easy!Appointments" "appointments" "alextselegidis/easyappointments:latest" "80" \
        "      BASE_URL: https://${TOOL_DOMAINS[appointments]}"
}

install_wisemapping() {
    install_service "WiseMapping" "wisemapping" "wisemapping/wisemapping-open-source:latest" "8080"
}

install_affine() {
    install_service "Affine" "affine" "ghcr.io/toeverything/affine-graphql:stable" "3010"
}

install_mattermost() {
    install_service "Mattermost" "mattermost" "mattermost/mattermost-team-edition:latest" "8065" "" \
        "      - mattermost_data:/mattermost"
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
    log_success "Odoo instalado! Acesse: https://${ODOO_DOMAIN}"
}

install_frappe() {
    install_service "Frappe" "frappe" "frappe/bench:latest" "8000"
}

install_keycloak() {
    local pwd
    pwd=$(generate_password)
    install_service "Keycloak" "keycloak" "quay.io/keycloak/keycloak:latest" "8080" \
        "      KEYCLOAK_ADMIN: admin\n      KEYCLOAK_ADMIN_PASSWORD: ${pwd}\n      KC_PROXY: edge\n      KC_HOSTNAME: ${TOOL_DOMAINS[keycloak]}" \
        "" \
        "    command: start"
    echo -e "  ${YELLOW}Senha Keycloak: ${pwd}${NC}"
}

install_vaultwarden() {
    install_service "VaultWarden" "vault" "vaultwarden/server:latest" "80" \
        "      DOMAIN: https://${TOOL_DOMAINS[vault]}" \
        "      - vaultwarden_data:/data"
}

install_passbolt() {
    install_service "Passbolt" "passbolt" "passbolt/passbolt:latest-ce" "443" \
        "      APP_FULL_BASE_URL: https://${TOOL_DOMAINS[passbolt]}\n      DATASOURCES_DEFAULT_HOST: passbolt-db"
}

install_botpress() {
    install_service "Botpress" "botpress" "botpress/server:latest" "3000" \
        "      EXTERNAL_URL: https://${TOOL_DOMAINS[botpress]}"
}

install_yourls() {
    local pwd
    pwd=$(generate_password)
    install_service "Yourls" "yourls" "yourls:latest" "80" \
        "      YOURLS_SITE: https://${TOOL_DOMAINS[yourls]}\n      YOURLS_USER: admin\n      YOURLS_PASS: ${pwd}"
    echo -e "  ${YELLOW}Senha Yourls: ${pwd}${NC}"
}

install_firecrawl() {
    install_service "Firecrawl" "firecrawl" "mendableai/firecrawl:latest" "3002"
}

install_azuracast() {
    install_service "AzuraCast" "radio" "ghcr.io/azuracast/azuracast:latest" "80"
}

install_shlink() {
    install_service "Shlink" "shlink" "shlinkio/shlink:latest" "8080" \
        "      DEFAULT_DOMAIN: ${TOOL_DOMAINS[shlink]}\n      IS_HTTPS_ENABLED: true\n      GEOLITE_LICENSE_KEY: ''"
}

install_rustdesk() {
    install_service "RustDesk" "rustdesk" "rustdesk/rustdesk-server:latest" "21117"
}

install_hoppscotch() {
    install_service "Hoppscotch" "hoppscotch" "hoppscotch/hoppscotch:latest" "3000"
}

install_wppconnect() {
    install_service "WppConnect" "wppconnect" "wppconnect/server:latest" "21465"
}

install_quepasa() {
    install_service "Quepasa API" "quepasa" "quepasa/quepasa:latest" "31000"
}

install_uno_api() {
    install_service "Uno API" "unoapi" "clfrags/unoapi-cloud:latest" "9876"
}

install_wuzapi() {
    install_service "Wuzapi" "wuzapi" "asternic/wuzapi:latest" "8080"
}

# ======================== MENU PRINCIPAL ========================

show_menu() {
    print_banner
    echo ""
    echo -e "${BOLD}╔══════════════════════════════════════════════════════════════════╗${NC}"
    echo -e "${BOLD}║          📦 ESCOLHA AS FERRAMENTAS PARA INSTALAR               ║${NC}"
    echo -e "${BOLD}╠══════════════════════════════════════════════════════════════════╣${NC}"
    echo -e "${BOLD}║                                                                ║${NC}"
    echo -e "${BOLD}║  ${CYAN}🔧 INFRAESTRUTURA${NC}${BOLD}                                             ║${NC}"
    echo -e "${BOLD}║${NC}   1) 🔀 Traefik (Proxy Reverso)                                ${BOLD}║${NC}"
    echo -e "${BOLD}║${NC}   2) 🐳 Portainer (Docker Manager)                             ${BOLD}║${NC}"
    echo -e "${BOLD}║${NC}   3) 📦 MinIO (Storage S3)                                     ${BOLD}║${NC}"
    echo -e "${BOLD}║${NC}   4) 🔔 Ntfy (Notificações)                                    ${BOLD}║${NC}"
    echo -e "${BOLD}║${NC}   5) 📄 Gotenberg (PDF API)                                    ${BOLD}║${NC}"
    echo -e "${BOLD}║${NC}   6) 📨 RabbitMQ (Message Broker)                              ${BOLD}║${NC}"
    echo -e "${BOLD}║${NC}   7) 🌐 Browserless (Chrome Headless)                          ${BOLD}║${NC}"
    echo -e "${BOLD}║                                                                ║${NC}"
    echo -e "${BOLD}╠══════════════════════════════════════════════════════════════════╣${NC}"
    echo -e "${BOLD}║  ${CYAN}💬 CHAT & WHATSAPP${NC}${BOLD}                                            ║${NC}"
    echo -e "${BOLD}║${NC}   8) 💬 Chatwoot (Atendimento)                                 ${BOLD}║${NC}"
    echo -e "${BOLD}║${NC}   9) 📱 Evolution API (WhatsApp)                               ${BOLD}║${NC}"
    echo -e "${BOLD}║${NC}  10) 📲 WppConnect (WhatsApp)                                  ${BOLD}║${NC}"
    echo -e "${BOLD}║${NC}  11) 💭 Quepasa API (WhatsApp)                                 ${BOLD}║${NC}"
    echo -e "${BOLD}║${NC}  12) ✉️  Uno API (Mensagens)                                    ${BOLD}║${NC}"
    echo -e "${BOLD}║${NC}  13) 📡 Wuzapi (WhatsApp REST)                                 ${BOLD}║${NC}"
    echo -e "${BOLD}║                                                                ║${NC}"
    echo -e "${BOLD}╠══════════════════════════════════════════════════════════════════╣${NC}"
    echo -e "${BOLD}║  ${CYAN}⚡ AUTOMAÇÃO${NC}${BOLD}                                                  ║${NC}"
    echo -e "${BOLD}║${NC}  14) 🔄 N8N (Workflows)                                        ${BOLD}║${NC}"
    echo -e "${BOLD}║${NC}  15) 🤖 Typebot (Chatbots)                                     ${BOLD}║${NC}"
    echo -e "${BOLD}║${NC}  16) 📧 Mautic (Marketing)                                     ${BOLD}║${NC}"
    echo -e "${BOLD}║                                                                ║${NC}"
    echo -e "${BOLD}╠══════════════════════════════════════════════════════════════════╣${NC}"
    echo -e "${BOLD}║  ${CYAN}🧠 INTELIGÊNCIA ARTIFICIAL${NC}${BOLD}                                    ║${NC}"
    echo -e "${BOLD}║${NC}  17) 🌊 Flowise (LLM Builder)                                  ${BOLD}║${NC}"
    echo -e "${BOLD}║${NC}  18) 🤖 Dify AI (IA Platform)                                  ${BOLD}║${NC}"
    echo -e "${BOLD}║${NC}  19) 🦙 Ollama (LLMs Locais)                                   ${BOLD}║${NC}"
    echo -e "${BOLD}║${NC}  20) 🔗 LangFlow (LangChain)                                   ${BOLD}║${NC}"
    echo -e "${BOLD}║${NC}  21) 📊 Langfuse (LLM Obs.)                                    ${BOLD}║${NC}"
    echo -e "${BOLD}║${NC}  22) 📚 Anything LLM (Chat Docs)                               ${BOLD}║${NC}"
    echo -e "${BOLD}║${NC}  23) 🔍 Qdrant (Vector DB)                                     ${BOLD}║${NC}"
    echo -e "${BOLD}║${NC}  24) 🧬 ZEP (IA Memory)                                        ${BOLD}║${NC}"
    echo -e "${BOLD}║${NC}  25) 🧪 Evo AI (IA Evolutiva)                                  ${BOLD}║${NC}"
    echo -e "${BOLD}║${NC}  26) ⚡ Bolt (Dev com IA)                                      ${BOLD}║${NC}"
    echo -e "${BOLD}║                                                                ║${NC}"
    echo -e "${BOLD}╠══════════════════════════════════════════════════════════════════╣${NC}"
    echo -e "${BOLD}║  ${CYAN}📋 CRM & PROJETOS${NC}${BOLD}                                             ║${NC}"
    echo -e "${BOLD}║${NC}  27) 🐕 Woofed CRM                                             ${BOLD}║${NC}"
    echo -e "${BOLD}║${NC}  28) 🏢 TwentyCRM                                              ${BOLD}║${NC}"
    echo -e "${BOLD}║${NC}  29) 📈 Krayin CRM                                             ${BOLD}║${NC}"
    echo -e "${BOLD}║${NC}  30) 📁 OpenProject                                            ${BOLD}║${NC}"
    echo -e "${BOLD}║${NC}  31) 📌 Planka (Kanban)                                        ${BOLD}║${NC}"
    echo -e "${BOLD}║${NC}  32) 📋 Focalboard                                             ${BOLD}║${NC}"
    echo -e "${BOLD}║${NC}  33) 🎫 GLPI (Help Desk)                                       ${BOLD}║${NC}"
    echo -e "${BOLD}║${NC}  34) 📝 Formbricks (Forms)                                     ${BOLD}║${NC}"
    echo -e "${BOLD}║                                                                ║${NC}"
    echo -e "${BOLD}╠══════════════════════════════════════════════════════════════════╣${NC}"
    echo -e "${BOLD}║  ${CYAN}🗄️  DATABASE & ADMIN${NC}${BOLD}                                          ║${NC}"
    echo -e "${BOLD}║${NC}  35) 🐘 PgAdmin 4                                              ${BOLD}║${NC}"
    echo -e "${BOLD}║${NC}  36) 🍃 MongoDB                                                ${BOLD}║${NC}"
    echo -e "${BOLD}║${NC}  37) ⚡ Supabase                                               ${BOLD}║${NC}"
    echo -e "${BOLD}║${NC}  38) 🐬 PhpMyAdmin                                             ${BOLD}║${NC}"
    echo -e "${BOLD}║${NC}  39) 📊 NocoDB                                                 ${BOLD}║${NC}"
    echo -e "${BOLD}║${NC}  40) 📊 Baserow                                                ${BOLD}║${NC}"
    echo -e "${BOLD}║${NC}  41) 📊 Nocobase                                               ${BOLD}║${NC}"
    echo -e "${BOLD}║${NC}  42) 🏠 ClickHouse                                             ${BOLD}║${NC}"
    echo -e "${BOLD}║${NC}  43) 🔴 RedisInsight                                           ${BOLD}║${NC}"
    echo -e "${BOLD}║${NC}  44) 📈 Metabase                                               ${BOLD}║${NC}"
    echo -e "${BOLD}║                                                                ║${NC}"
    echo -e "${BOLD}╠══════════════════════════════════════════════════════════════════╣${NC}"
    echo -e "${BOLD}║  ${CYAN}🌐 CMS & SITES${NC}${BOLD}                                                ║${NC}"
    echo -e "${BOLD}║${NC}  45) 📰 WordPress                                              ${BOLD}║${NC}"
    echo -e "${BOLD}║${NC}  46) 🎯 Directus                                               ${BOLD}║${NC}"
    echo -e "${BOLD}║${NC}  47) 🚀 Strapi                                                 ${BOLD}║${NC}"
    echo -e "${BOLD}║${NC}  48) ☁️  NextCloud                                               ${BOLD}║${NC}"
    echo -e "${BOLD}║${NC}  49) 📖 Wiki.js                                                ${BOLD}║${NC}"
    echo -e "${BOLD}║${NC}  50) 👥 HumHub                                                 ${BOLD}║${NC}"
    echo -e "${BOLD}║${NC}  51) 📝 Outline                                                ${BOLD}║${NC}"
    echo -e "${BOLD}║${NC}  52) 🎓 Moodle                                                 ${BOLD}║${NC}"
    echo -e "${BOLD}║                                                                ║${NC}"
    echo -e "${BOLD}╠══════════════════════════════════════════════════════════════════╣${NC}"
    echo -e "${BOLD}║  ${CYAN}📡 MONITORAMENTO${NC}${BOLD}                                              ║${NC}"
    echo -e "${BOLD}║${NC}  53) ⬆️  Uptime Kuma                                            ${BOLD}║${NC}"
    echo -e "${BOLD}║${NC}  54) 📊 Grafana                                                ${BOLD}║${NC}"
    echo -e "${BOLD}║${NC}  55) 🔥 Prometheus                                             ${BOLD}║${NC}"
    echo -e "${BOLD}║${NC}  56) 📦 cAdvisor                                               ${BOLD}║${NC}"
    echo -e "${BOLD}║${NC}  57) 📍 Traccar (GPS)                                          ${BOLD}║${NC}"
    echo -e "${BOLD}║                                                                ║${NC}"
    echo -e "${BOLD}╠══════════════════════════════════════════════════════════════════╣${NC}"
    echo -e "${BOLD}║  ${CYAN}🛠️  PRODUTIVIDADE${NC}${BOLD}                                              ║${NC}"
    echo -e "${BOLD}║${NC}  58) 📅 Cal.com (Agenda)                                       ${BOLD}║${NC}"
    echo -e "${BOLD}║${NC}  59) 🏗️  Appsmith                                               ${BOLD}║${NC}"
    echo -e "${BOLD}║${NC}  60) 🔧 LowCoder                                               ${BOLD}║${NC}"
    echo -e "${BOLD}║${NC}  61) 🔨 ToolJet                                                ${BOLD}║${NC}"
    echo -e "${BOLD}║${NC}  62) ✏️  Excalidraw                                              ${BOLD}║${NC}"
    echo -e "${BOLD}║${NC}  63) 📄 Docuseal                                               ${BOLD}║${NC}"
    echo -e "${BOLD}║${NC}  64) 📄 Documeso                                               ${BOLD}║${NC}"
    echo -e "${BOLD}║${NC}  65) 📑 Stirling PDF                                           ${BOLD}║${NC}"
    echo -e "${BOLD}║${NC}  66) 📅 Easy!Appointments                                      ${BOLD}║${NC}"
    echo -e "${BOLD}║${NC}  67) 🧠 WiseMapping                                            ${BOLD}║${NC}"
    echo -e "${BOLD}║${NC}  68) ✨ Affine                                                 ${BOLD}║${NC}"
    echo -e "${BOLD}║${NC}  69) 💬 Mattermost                                             ${BOLD}║${NC}"
    echo -e "${BOLD}║${NC}  70) 🏭 Odoo                                                   ${BOLD}║${NC}"
    echo -e "${BOLD}║${NC}  71) 🔧 Frappe                                                 ${BOLD}║${NC}"
    echo -e "${BOLD}║                                                                ║${NC}"
    echo -e "${BOLD}╠══════════════════════════════════════════════════════════════════╣${NC}"
    echo -e "${BOLD}║  ${CYAN}🔒 SEGURANÇA${NC}${BOLD}                                                  ║${NC}"
    echo -e "${BOLD}║${NC}  72) 🔑 Keycloak (IAM)                                         ${BOLD}║${NC}"
    echo -e "${BOLD}║${NC}  73) 🔐 VaultWarden (Senhas)                                   ${BOLD}║${NC}"
    echo -e "${BOLD}║${NC}  74) 🗝️  Passbolt (Senhas Equipe)                               ${BOLD}║${NC}"
    echo -e "${BOLD}║                                                                ║${NC}"
    echo -e "${BOLD}╠══════════════════════════════════════════════════════════════════╣${NC}"
    echo -e "${BOLD}║  ${CYAN}📦 OUTROS${NC}${BOLD}                                                     ║${NC}"
    echo -e "${BOLD}║${NC}  75) 🤖 Botpress (Chatbot)                                     ${BOLD}║${NC}"
    echo -e "${BOLD}║${NC}  76) 🔗 Yourls (URL Shortener)                                 ${BOLD}║${NC}"
    echo -e "${BOLD}║${NC}  77) 🕷️  Firecrawl (Scraping)                                   ${BOLD}║${NC}"
    echo -e "${BOLD}║${NC}  78) 📻 AzuraCast (Rádio)                                      ${BOLD}║${NC}"
    echo -e "${BOLD}║${NC}  79) 🔗 Shlink (URLs + Analytics)                              ${BOLD}║${NC}"
    echo -e "${BOLD}║${NC}  80) 🖥️  RustDesk (Acesso Remoto)                               ${BOLD}║${NC}"
    echo -e "${BOLD}║${NC}  81) 🧪 Hoppscotch (API Client)                                ${BOLD}║${NC}"
    echo -e "${BOLD}║                                                                ║${NC}"
    echo -e "${BOLD}╠══════════════════════════════════════════════════════════════════╣${NC}"
    echo -e "${BOLD}║                                                                ║${NC}"
    echo -e "${BOLD}║   ${GREEN}0) ✅ INSTALAR TUDO${NC}              ${RED}99) ❌ Sair${NC}${BOLD}                ║${NC}"
    echo -e "${BOLD}║                                                                ║${NC}"
    echo -e "${BOLD}╚══════════════════════════════════════════════════════════════════╝${NC}"
    echo ""
    echo -e "  Digite os números separados por espaço (ex: ${CYAN}1 8 9 14 15${NC})"
    read -rp "  > " choices
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
