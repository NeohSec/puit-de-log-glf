#!/bin/bash
clear
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
    echo -e "${WHITE}            💻 Setup automatisé pour puit de logs 💻"
    echo -e "                              ${PURPLE}By NEOH${NC}"
    echo ""
}

# Print functions
print_step() {
    echo -e "${BLUE}[ÉTAPE]${NC} $1"
}

print_info() {
    echo -e "${CYAN}[INFO]${NC} $1"
}

print_success() {
    echo -e "${GREEN}[✓]${NC} $1"
}

print_error() {
    echo -e "${RED}[✗]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[⚠]${NC} $1"
}

# Check if running as root
check_root() {
    print_step "Vérification des privilèges administrateur..."
    
    if [[ $EUID -ne 0 ]]; then
        print_error "Ce script doit être exécuté avec des privilèges root !"
        print_info "Utilisez : sudo ./setup.sh"
        exit 1
    fi
    
    print_success "Privilèges administrateur confirmés !"
    echo ""
}

# Check if we're in the right directory and docker-compose exists
check_directory() {
    print_step "Vérification de l'environnement..."
    
    # Check if docker-compose.yml exists
    if [ ! -f "docker-compose.yml" ]; then
        print_error "Fichier docker-compose.yml non trouvé !"
        print_info "Assurez-vous d'être dans le bon répertoire du projet."
        exit 1
    fi
    
    print_success "Fichier docker-compose.yml trouvé !"
    
    # Display current directory for confirmation
    current_dir=$(basename "$PWD")
    print_info "Répertoire actuel : $current_dir"
    echo ""
}

# Check and install Docker if needed
check_docker() {
    print_step "Vérification de Docker..."
    
    # Check if Docker is installed
    if ! command -v docker &> /dev/null; then
        print_warning "Docker n'est pas installé. Installation en cours..."
        
        # Update package list
        print_info "Mise à jour des paquets..."
        apt-get update
        
        # Install curl if not present
        print_info "Installation de curl..."
        apt-get install -y curl
        
        print_info "Lancement du script d'installation Docker..."
        
        # Execute Docker installation script and wait for completion
        curl -s https://raw.githubusercontent.com/s4dic/dockerautoinstall/main/dockerautoinstall.sh | bash
        
        # Check if installation was successful
        if [ $? -eq 0 ]; then
            print_success "Script d'installation Docker exécuté !"
            
            # Wait a bit for Docker to be ready
            sleep 3
            
            # Verify Docker installation
            if command -v docker &> /dev/null; then
                print_success "Docker installé avec succès !"
                
                # Start Docker service if not running
                systemctl start docker 2>/dev/null || service docker start 2>/dev/null
                systemctl enable docker 2>/dev/null || true
                
            else
                print_error "Erreur : Docker n'a pas pu être installé correctement !"
                print_info "Vérifiez manuellement l'installation de Docker."
                exit 1
            fi
        else
            print_error "Erreur lors de l'exécution du script d'installation Docker !"
            exit 1
        fi
    else
        print_success "Docker est déjà installé !"
    fi                
    
    print_success "Environnement Docker prêt !"
    echo ""
}

# Create necessary directories
create_directories() {
    print_step "Création de la structure des dossiers..."
    echo ""
    
    # List of directories to create
    directories=(
        "reverseproxy/certs"
        "DATA/grafana"
        "DATA/loki"
    )
    
    for dir in "${directories[@]}"; do
        if [ ! -d "$dir" ]; then
            print_info "Création du dossier : $dir"
            mkdir -p "$dir"
            
            if [ $? -eq 0 ]; then
                print_success "Dossier créé : $dir"
            else
                print_error "Erreur lors de la création du dossier : $dir"
                exit 1
            fi
        else
            print_info "Dossier existant : $dir ✓"
        fi
    done
    
    echo ""
    print_success "Structure des dossiers créée avec succès !"
    echo ""
}

# Set correct permissions for Docker volumes
set_permissions() {
    print_step "Configuration des permissions des dossiers..."
    
    # Set permissions for Grafana (ID 472)
    print_info "Configuration des permissions pour Grafana..."
    chown -R 472:472 DATA/grafana/
    chmod -R 755 DATA/grafana/
    
    # Set permissions for Loki (ID 10001)
    print_info "Configuration des permissions pour Loki..."
    chown -R 10001:10001 DATA/loki/
    chmod -R 755 DATA/loki/
    
    # Set permissions for reverse proxy certs
    print_info "Configuration des permissions pour les certificats..."
    chown -R root:root reverseproxy/certs/
    chmod -R 644 reverseproxy/certs/
    
    print_success "Permissions configurées avec succès !"
    echo ""
}

# Launch Docker containers
launch_containers() {
    print_step "Lancement des containers Docker..."
    
    if [ -f "docker-compose.yml" ]; then
        print_info "Arrêt des containers existants..."
        docker-compose down 2>/dev/null
        
        print_info "Démarrage des services..."
        if docker-compose up -d; then
            sleep 2
            
            print_info "Vérification du statut des containers..."
            docker-compose ps
            
            print_success "Tous les services sont démarrés avec succès !"
        else
            print_error "Erreur lors du lancement des containers !"
            print_info "Vérifiez les logs avec : docker-compose logs"
            exit 1
        fi
    else
        print_error "Fichier docker-compose.yml non trouvé !"
        exit 1
    fi
    echo ""
}

# Display final message and next steps
display_final_message() {
    echo -e "${GREEN}╔════════════════════════════════════════════════════════════════════════════════╗"
    echo -e "║                                                                                ║"
    echo -e "║                      ${WHITE}🎉 INSTALLATION TERMINÉE AVEC SUCCÈS ! 🎉${GREEN}                 ║"
    echo -e "║                                                                                ║"
    echo -e "║    Votre puit de log GLF (Grafana + Loki + Fluent-bit) est maintenant          ║"
    echo -e "║    opérationnel et accessible !                                                ║"
    echo -e "║                                                                                ║"
    echo -e "║  ${YELLOW}📋 PROCHAINES ÉTAPES :${GREEN}                                                        ║"
    echo -e "║                                                                                ║"
    echo -e "║  ${WHITE}1.${GREEN} Modifiez le fichier ${CYAN}reverseproxy/nginx.conf${GREEN}                                ║"
    echo -e "║     pour l'adapter à votre configuration                                       ║"
    echo -e "║                                                                                ║"
    echo -e "║  ${WHITE}2.${GREEN} Redémarrez si nécessaire : ${CYAN}docker-compose restart${GREEN}                          ║"
    echo -e "║                                                                                ║"
    echo -e "║  ${WHITE}3.${GREEN} Consultez les logs : ${CYAN}docker-compose logs -f${GREEN}                                ║"
    echo -e "║                                                                                ║"
    echo -e "║  ${YELLOW}🌐 ACCÈS AUX SERVICES :${GREEN}                                                       ║"
    echo -e "║                                                                                ║"
    echo -e "║  • Grafana : ${CYAN}http://localhost:3000${GREEN} (admin/admin)                               ║"
    echo -e "║  • Loki API : ${CYAN}http://localhost:3100${GREEN}                                            ║"
    echo -e "║                                                                                ║"
    echo -e "║  ${YELLOW}🔧 COMMANDES UTILES :${GREEN}                                                         ║"
    echo -e "║                                                                                ║"
    echo -e "║  • Arrêter : ${CYAN}docker-compose down${GREEN}                                               ║"
    echo -e "║  • Redémarrer : ${CYAN}docker-compose restart${GREEN}                                         ║"
    echo -e "║  • Voir les logs : ${CYAN}docker-compose logs -f [service]${GREEN}                            ║"
    echo -e "║                                                                                ║"
    echo -e "║                              ${PURPLE}Créé par : NEOH${GREEN}                                   ║"
    echo -e "╚════════════════════════════════════════════════════════════════════════════════╝${NC}"
    echo ""
}

# Main execution
main() {
    display_header

    sleep 3  

    print_info "Démarrage de l'installation du Puit de Log GLF (Grafana + Loki + Fluent-bit)"
    echo ""
    
    check_root
    check_directory
    check_docker
    create_directories
    set_permissions
    launch_containers
    
    echo ""
    display_final_message
}

# Run main function
main "$@"
