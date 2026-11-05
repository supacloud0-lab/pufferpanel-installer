#!/bin/bash

# Root permissions check
if [ "$EUID" -ne 0 ]; then
  echo -e "\033[1;31m[-] Kripya is script ko root user se chalayein (sudo bash).\033[0m"
  exit 1
fi

clear

while true; do
    # Aapka ASCII Art Header
    echo -e "\033[1;36m"
    echo " __  __    ____   __   __  _____    _                __    __  ______"
    echo "|  \/  | |___ \   \ V /  |  __ \  | |         /\     \ \  / / |___  /"
    echo "| |\/| |   __) |   \ V /   | |__) | | |        /  \     \ \/ /      / / "
    echo "| |  | |  |__ <     > <    |  ___/  | |       / /\ \     \  /      / /  "
    echo "| |  | |  ___) |   / . \   | |      | |____  / ____ \    | |      / /__ "
    echo "|_|  |_| |____/   /_/ \_\  |_|      |______|/_/    \_\   |_|     /_____|"
    echo -e "------------------------------------------------------------"
    echo -e " 1. install pufferpanel"
    echo -e " 2. add admin user"
    echo -e " 3. start panel"
    echo -e " 4. restart panel"
    echo -e " 5. install docker"
    echo -e " 6. Soon!"
    echo -e "_________________________________________________"
    echo -e "\033[0m"

    read -p "Apna option chunein [1-4]: " choice

    case $choice in
        1)
            echo -e "\n\033[1;32m[+] Pufferpanel installation shuru ho rahi hai...\033[0m"
            docker volume create pufferpanel-config

docker volume create pufferpanel-servers

docker create --name pufferpanel \
               -p 8080:8080 -p 5657:5657 \
               -v pufferpanel-config:/etc/pufferpanel \
               -v pufferpanel-servers:/var/lib/pufferpanel:z \
               -v /var/run/docker.sock:/var/run/docker.sock \
               --restart=on-failure \
               pufferpanel/pufferpanel:latest
            echo -e "\n\033[1;32m[+] Pufferpanel successfully install ho gaya hai!\033[0m"
            echo ""
            read -p "Main menu par jaane ke liye [Enter] dabayein..."
            ;;
        2)
            echo -e "\n\033[1;32m[+] Admin User banane ke liye details bharein...\033[0m"
         docker exec -it pufferpanel /pufferpanel/bin/pufferpanel user add
            echo -e "\n\033[1;32m[+] Admin User successfully ban gaya hai!\033[0m"
            echo ""
            read -p "Main menu par jaane ke liye [Enter] dabayein..."
            ;;
        3)
            echo -e "\n\033[1;32m[+] Pufferpanel service start ki ja rahi hai...\033[0m"
            docker start pufferpanel
            echo -e "\n\033[1;32m[+] Panel successfully start ho chuka hai! (Port: 8080)\033[0m"
            echo ""
            read -p "Main menu par jaane ke liye [Enter] dabayein..."
            ;;
                    ;;
        4)
            echo -e "\n\033[1;32m[+] Pufferpanel service restart ki ja rahi hai...\033[0m"
            docker restart pufferpanel
            echo -e "\n\033[1;32m[+] Panel successfully restart ho chuki hai! (Port: 8080)\033[0m"
            echo ""
            read -p "Main menu par jaane ke liye [Enter] dabayein..."
            ;;
      5)
            echo -e "\n\033[1;32m[+]Docker Install horha he ...\033[0m"
           apt update && apt install docker.io -y 
            echo -e "\n\033[1;32m[+]Docker Install hochuka he! \033[0m"
            echo ""
            read -p "Main menu par jaane ke liye [Enter] dabayein..."
            ;;
        6)
            echo -e "\n\033[1;33m[!] Option 4: Naye features jaldi aane wale hain!\033[0m"
            echo ""
            read -p "Main menu par jaane ke liye [Enter] dabayein..."
            ;;
        *)
            echo -e "\n\033[1;31m[-] Galat option! Kripya 1 se 4 ke beech chunein.\033[0m"
            sleep 2
            ;;
    esac
    clear
done
