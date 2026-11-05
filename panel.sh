#!/bin/bash

# Colors for Styling
GREEN='\033[0;32m'
CYAN='\033[0;36m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

show_menu() {
    clear
    echo -e "${CYAN}--------------------------------------------------------------${NC}"
    echo -e "${GREEN} __  __    ____   __   __  _____    _                 __    __  ______${NC}"
    echo -e "${GREEN}|  \/  | |___ \   \ \ / / |  __ \  | |         /\      \ \  / /  |___  /${NC}"
    echo -e "${GREEN}| \  / |   __) |   \ V /  | |__) | | |        /  \      \ \/ /      / / ${NC}"
    echo -e "${GREEN}| |\/| |  |__ <     > <   |  ___/  | |       / /\ \      \  /      / /  ${NC}"
    echo -e "${GREEN}| |  | |  ___) |   / . \  | |      | |____  / ____ \     | |      / /__ ${NC}"
    echo -e "${GREEN}|_|  |_| |____/   /_/ \_\ |_|      |______|/_/    \_\    |_|     /_____|${NC}"
    echo -e "${CYAN}--------------------------------------------------------------${NC}"
    echo -e " 1. INSTALL PUFFERPANEL"
    echo -e " 2. START PANEL"
    echo -e " 3. STOP PANEL"
    echo -e " 4. RESTART PANEL"
    echo -e " 5. ADD AN ADMIN"
    echo -e " 6. INSTALL DOCKER"
    echo -e " 7. CREATE A NODE"
    echo -e " 8. SOON!"
    echo -e " 0. EXIT"
    echo -e "${CYAN}--------------------------------------------------------------${NC}"
    read -p "Apna option select karein [0-8]: " choice
}

# 1. Install PufferPanel
install_pufferpanel() {
    echo -e "\n${GREEN}[+] PufferPanel installation shuru ho rahi hai...${NC}"
    if [ "$EUID" -ne 0 ]; then
      echo -e "${RED}[!] Kripya is script ko root user (sudo) ke sath run karein.${NC}"
      read -p "Wapas jane ke liye Enter dabayein..."
      return
    fi
    apt-get update && apt-get install -y curl apt-transport-https gnupg ufw
    curl -s https://packagecloud.io/install/repositories/pufferpanel/pufferpanel/script.deb.sh | bash
    apt-get install -y pufferpanel
    systemctl enable --now pufferpanel
    ufw allow 8080/tcp
    echo -e "\n${GREEN}[✓] PufferPanel successfully install ho gaya hai!${NC}"
    read -p "Wapas menu par jane ke liye Enter dabayein..."
}

# 2. Start Panel
start_panel() {
    echo -e "\n${CYAN}[*] PufferPanel start kiya ja raha hai...${NC}"
    systemctl start pufferpanel
    echo -e "${GREEN}[✓] Panel started!${NC}"
    sleep 2
}

# 3. Stop Panel
stop_panel() {
    echo -e "\n${CYAN}[*] PufferPanel stop kiya ja raha hai...${NC}"
    systemctl stop pufferpanel
    echo -e "${YELLOW}[!] Panel stopped!${NC}"
    sleep 2
}

# 4. Restart Panel
restart_panel() {
    echo -e "\n${CYAN}[*] PufferPanel restart kiya ja raha hai...${NC}"
    systemctl restart pufferpanel
    echo -e "${GREEN}[✓] Panel restarted successfully!${NC}"
    sleep 2
}

# 5. Add an Admin
add_admin() {
    if command -v pufferpanel &> /dev/null; then
        echo -e "\n${CYAN}[*] Admin user banane ki process shuru ho rahi hai...${NC}"
        pufferpanel user add
    else
        echo -e "\n${RED}[!] Pehle PufferPanel install karein (Option 1).${NC}"
    fi
    read -p "Wapas jane ke liye Enter dabayein..."
}

# 6. Install Docker
install_docker() {
    echo -e "\n${GREEN}[+] Docker installation shuru ho rahi hai...${NC}"
    if ! command -v docker &> /dev/null; then
        curl -fsSL https://get.docker.com | sh
        systemctl enable --now docker
        echo -e "\n${GREEN}[✓] Docker successfully install ho gaya hai!${NC}"
    else
        echo -e "\n${GREEN}[✓] Docker pehle se installed hai.${NC}"
    fi
    read -p "Wapas jane ke liye Enter dabayein..."
}

# 7. Create a Node
create_node() {
    echo -e "\n${GREEN}[+] PufferPanel Node creation process...${NC}"
    if command -v pufferpanel &> /dev/null; then
        echo -e "${YELLOW}Node create karne ke liye neeche diye instructions follow karein:${NC}"
        pufferpanel node add
    else
        echo -e "\n${RED}[!] Pehle PufferPanel install karein.${NC}"
    fi
    read -p "Wapas jane ke liye Enter dabayein..."
}

# Main Loop
while true; do
    show_menu
    case $choice in
        1) install_pufferpanel ;;
        2) start_panel ;;
        3) stop_panel ;;
        4) restart_panel ;;
        5) add_admin ;;
        6) install_docker ;;
        7) create_node ;;
        8) 
            echo -e "\n${CYAN}Ye feature jald hi aayega!${NC}"
            sleep 2 
            ;;
        0) 
            echo -e "\n${GREEN}Alvida! Script band ki ja rahi hai.${NC}"
            exit 0 
            ;;
        *) 
            echo -e "\n${RED}[!] Galat option select kiya, kripya 0 se 8 ke beech chunein.${NC}"
            sleep 2 
            ;;
    esac
done
