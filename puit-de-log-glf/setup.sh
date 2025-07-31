#!/bin/bash

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
WHITE='\033[1;37m'
NC='\033[0m' # No Color

# ASCII Header
display_header() {
    clear
    echo -e "${CYAN}"
    echo "██████╗ ██╗   ██╗██╗████████╗    ██████╗ ███████╗    ██╗      ██████╗  ██████╗ "
    echo "██╔══██╗██║   ██║██║╚══██╔══╝    ██╔══██╗██╔════╝    ██║     ██╔═══██╗██╔════╝ "
    echo "██████╔╝██║   ██║██║   ██║       ██║  ██║█████╗      ██║     ██║   ██║██║  ███╗"
    echo "██╔═══╝ ██║   ██║██║   ██║       ██║  ██║██╔══╝      ██║     ██║   ██║██║   ██║"
    echo "██║     ╚██████╔╝██║   ██║       ██████╔╝███████╗    ███████╗╚██████╔╝╚██████╔╝"
    echo "╚═╝      ╚═════╝ ╚═╝   ╚═╝       ╚═════╝ ╚══════╝    ╚══════╝ ╚═════╝  ╚═════╝ "
    echo ""
    echo "      ██████╗ ██████╗  █████╗ ███████╗ █████╗ ███╗   ██╗ █████╗ "
    echo "     ██╔════╝ ██╔══██╗██╔══██╗██╔════╝██╔══██╗████╗  ██║██╔══██╗"
    echo "     ██║  ███╗██████╔╝███████║█████╗  ███████║██╔██╗ ██║███████║"
    echo "     ██║   ██║██╔══██╗██╔══██║██╔══╝  ██╔══██║██║╚██╗██║██╔══██║"
    echo "     ╚██████╔╝██║  ██║██║  ██║██║     ██║  ██║██║ ╚████║██║  ██║"
    echo "      ╚═════╝ ╚═╝  ╚═╝╚═╝  ╚═╝╚═╝     ╚═╝  ╚═╝╚═╝  ╚═══╝╚═╝  ╚═╝"
    echo ""
    echo "██╗      ██████╗ ██╗  ██╗██╗    ███████╗██╗     ██╗   ██╗███████╗███╗   ██╗████████╗██████╗ ██╗████████╗"
    echo "██║     ██╔═══██╗██║ ██╔╝██║    ██╔════╝██║     ██║   ██║██╔════╝████╗  ██║╚══██╔══╝██╔══██╗██║╚══██╔══╝"
    echo "██║     ██║   ██║█████╔╝ ██║    █████╗  ██║     ██║   ██║█████╗  ██╔██╗ ██║   ██║   ██████╔╝██║   ██║   "
    echo "██║     ██║   ██║██╔═██╗ ██║    ██╔══╝  ██║     ██║   ██║██╔══╝  ██║╚██╗██║   ██║   ██╔══██╗██║   ██║   "
    echo "███████╗╚██████╔╝██║  ██╗██║    ██║     ███████╗╚██████╔╝███████╗██║ ╚████║   ██║   ██████╔╝██║   ██║   "
    echo "╚══════╝ ╚═════╝ ╚═╝  ╚═╝╚═╝    ╚═╝     ╚══════╝ ╚═════╝ ╚══════╝╚═╝  ╚═══╝   ╚═╝   ╚═════╝ ╚═╝   ╚═╝   "
    echo ""
    echo -e "${PURPLE}                     ═══════════════════════════════════════════════"
    echo -e "                                    ${WHITE}By: NEOH${PURPLE}"
    echo -e "                     ═══════════════════════════════════════════════${NC}"
    echo ""
}

# Print colored messages
print_success() {
    echo -e "${GREEN}[✓] $1${NC}"
}

print_error() {
    echo -e "${RED}[✗] $1${NC}"
}

print_info() {
    echo -e "${BLUE}[i] $1${NC}"
}

print_warning() {
    echo -e "${YELLOW}[!] $1${NC}"
}

print_step() {
    echo -e "${WHITE}[→] $1${NC}"
}

# Check if running as root
check_root() {
    if [[ $EUID -ne 0 ]]; then
        print_error "Ce script doit être exécuté en tant que root (sudo)"
        exit 1
    fi
    print_success "Vérification des privilèges root"
}

# Check if docker-compose.yml exists
check_directory() {
    print_step "Vérification de la structure du projet..."
    
    if [ ! -f "docker-compose.yml" ]; then
        print_error "Fichier docker-compose.yml non trouvé !"
        print_error "Assurez-vous d'être dans le bon dossier du projet"
        exit 1
    fi
    
    # Check directory structure
    local missing_dirs=()
    
    [ ! -d "DATA" ] && missing_dirs+=("DATA")
    [ ! -d "DATA/grafana" ] && missing_dirs+=("DATA/grafana")
    [ ! -d "DATA/loki" ] && missing_dirs+=("DATA/loki")
    [ ! -d "reverseproxy" ] && missing_dirs+=("reverseproxy")
    [ ! -d "reverseproxy/certs" ] && missing_dirs+=("reverseproxy/certs")
    [ ! -d "reverseproxy/conf.d" ] && missing_dirs+=("reverseproxy/conf.d")
    [ ! -f "DATA/fluent-bit.conf" ] && missing_dirs+=("DATA/fluent-bit.conf")
    
    if [ ${#missing_dirs[@]} -gt 0 ]; then
        print_error "Structure de dossier incomplète. Éléments manquants :"
        for item in "${missing_dirs[@]}"; do
            echo -e "  ${RED}- $item${NC}"
        done
        exit 1
    fi
    
    print_success "Structure du projet validée"
}

# Check if Docker is installed
check_docker() {
    print_step "Vérification de l'installation Docker..."
    
    if command -v docker &> /dev/null && command -v docker-compose &> /dev/null; then
        print_success "Docker et Docker Compose sont installés"
        
        # Check if Docker service is running
        if systemctl is-active --quiet docker; then
            print_success "Service Docker actif"
        else
            print_info "Démarrage du service Docker..."
            systemctl start docker
            systemctl enable docker
            print_success "Service Docker démarré"
        fi
    else
        print_warning "Docker n'est pas installé sur ce système"
        echo ""
        
        read -p "Voulez-vous installer Docker automatiquement ? [Y/n]: " -n 1 -r
        echo ""
        
        if [[ !  $ REPLY =~ ^[Nn] $  ]]; then
            install_docker
        else
            print_error "Docker est requis pour continuer. Installation annulée."
            exit 1
        fi
    fi
}

# Install Docker
install_docker() {
    print_step "Installation de Docker en cours..."
    
    print_info "Mise à jour du système..."
    apt update && apt upgrade -y
    
    print_info "Installation de curl..."
    apt install curl -y
    
    print_info "Téléchargement et exécution du script d'installation Docker..."
    curl https://raw.githubusercontent.com/s4dic/dockerautoinstall/main/dockerautoinstall.sh | bash
    
    # Verify installation
    if command -v docker &> /dev/null && command -v docker-compose &> /dev/null; then
        print_success "Docker installé avec succès !"
    else
        print_error "Erreur lors de l'installation de Docker"
        exit 1
    fi
}

# Set proper permissions
set_permissions() {
    print_step "Application des permissions sur les dossiers..."
    
    # Grafana permissions
    print_info "Configuration des permissions Grafana..."
    chown -R 472:472 DATA/grafana
    chmod -R 755 DATA/grafana
    print_success "Permissions Grafana appliquées (472:472)"
    
    # Loki permissions
    print_info "Configuration des permissions Loki..."
    chown -R 10001:10001 DATA/loki
    chmod -R 755 DATA/loki
    print_success "Permissions Loki appliquées (10001:10001)"
    
    # Nginx permissions
    print_info "Configuration des permissions Nginx..."
    chmod -R 755 reverseproxy/certs
    chmod -R 755 reverseproxy/conf.d
    print_success "Permissions Nginx appliquées"
    
    # Fluent-bit permissions
    print_info "Configuration des permissions Fluent-bit..."
    chmod 644 DATA/fluent-bit.conf
    print_success "Permissions Fluent-bit appliquées"
    
    print_success "Toutes les permissions ont été configurées correctement"
}

# Launch Docker containers
launch_containers() {
    print_step "Lancement des containers Docker..."
    echo ""
    
    if [ -f "docker-compose.yml" ]; then
        print_info "Démarrage des services avec docker-compose..."
        
        # Pull images first
        print_info "Téléchargement des images Docker..."
        docker-compose pull
        
        # Start containers
        print_info "Lancement des containers en arrière-plan..."
        docker-compose up -d
        
        # Check if containers are running
        sleep 5
        print_info "Vérification du statut des containers..."
        
        if docker-compose ps | grep -q "Up"; then
            print_success "Containers lancés avec succès !"
            echo ""
            print_info "Status des services :"
            docker-compose ps
        else
            print_warning "Certains containers pourraient avoir des problèmes"
            print_info "Vérifiez les logs avec : docker-compose logs"
        fi
    else
        print_error "Fichier docker-compose.yml introuvable !"
    fi
    
    echo ""
}

# Final message
display_final_message() {
    echo ""
    echo -e "${GREEN}╔════════════════════════════════════════════════════════════════════════════════╗"
    echo -e "║                              ${WHITE}INSTALLATION TERMINÉE !${GREEN}                              ║"
    echo -e "╠════════════════════════════════════════════════════════════════════════════════╣"
    echo -e "║                                                                                ║"
    echo -e "║  ${YELLOW}Services déployés :${GREEN}                                                            ║"
    echo -e "║  ${WHITE}✓${GREEN} Grafana - Interface de visualisation                                     ║"
    echo -e "║  ${WHITE}✓${GREEN} Loki - Agrégateur de logs                                               ║"
    echo -e "║  ${WHITE}✓${GREEN} Fluent-bit - Collecteur de logs                                         ║"
    echo -e "║  ${WHITE}✓${GREEN} Nginx - Reverse proxy                                                   ║"
    echo -e "║                                                                                ║"
    echo -e "║  ${YELLOW}Prochaines étapes :${GREEN}                                                           ║"
    echo -e "║                                                                                ║"
    echo -e "║  ${WHITE}1.${GREEN} Modifiez le fichier ${CYAN}reverseproxy/conf.d/nginx.conf${GREEN}                        ║"
    echo -e "║     pour l'adapter à votre configuration                                      ║"
    echo -e "║                                                                                ║"
    echo -e "║  ${WHITE}2.${GREEN} Redémarrez si nécessaire : ${CYAN}docker-compose restart${GREEN}                       ║"
    echo -e "║                                                                                ║"
    echo -e "║  ${WHITE}3.${GREEN} Consultez les logs : ${CYAN}docker-compose logs -f${GREEN}                             ║"
    echo -e "║                                                                                ║"
    echo -e "║                              ${PURPLE}Créé par : NEOH${GREEN}                                   ║"
    echo -e "╚════════════════════════════════════════════════════════════════════════════════╝${NC}"
    echo ""
}

# Main execution
main() {
    display_header
    
    print_info "Démarrage de l'installation du Puit de Log GLF (Grafana + Loki + Fluent-bit)"
    echo ""
    
    check_root
    check_directory
    check_docker
    set_permissions
    launch_containers
    
    echo ""
    display_final_message
}

# Run main function
main "$@"
