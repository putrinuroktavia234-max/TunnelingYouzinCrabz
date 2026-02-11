#!/bin/bash

#================================================
# Quick Installation Script
# VPN Auto Script - Multi Protocol
# By The Proffessor Squad
#================================================

RED='\033[0;31m'
GREEN='\033[0;32m'
CYAN='\033[0;36m'
NC='\033[0m'

clear
echo -e "${CYAN}╔══════════════════════════════════════════════╗${NC}"
echo -e "${CYAN}║${NC}  ${GREEN}VPN Auto Script - Quick Install${NC}           ${CYAN}║${NC}"
echo -e "${CYAN}║${NC}  ${GREEN}By The Proffessor Squad${NC}                   ${CYAN}║${NC}"
echo -e "${CYAN}╚══════════════════════════════════════════════╝${NC}"
echo ""

# Check if running as root
if [[ $EUID -ne 0 ]]; then
   echo -e "${RED}Error: This script must be run as root${NC}"
   echo "Please run: sudo bash $0"
   exit 1
fi

# Check OS
if [[ -f /etc/os-release ]]; then
    . /etc/os-release
    OS=$ID
    VER=$VERSION_ID
    echo -e "${CYAN}Detected OS:${NC} $PRETTY_NAME"
else
    echo -e "${RED}Cannot detect OS${NC}"
    exit 1
fi

# Validate OS
case $OS in
    ubuntu)
        if [[ ! "$VER" =~ ^(20.04|22.04|24.04)$ ]]; then
            echo -e "${RED}Warning: Ubuntu $VER not fully tested${NC}"
            read -p "Continue anyway? (y/n): " confirm
            [[ ! "$confirm" =~ ^[Yy]$ ]] && exit 1
        fi
        ;;
    debian)
        if [[ ! "$VER" =~ ^(9|10|11|12)$ ]]; then
            echo -e "${RED}Warning: Debian $VER not fully tested${NC}"
            read -p "Continue anyway? (y/n): " confirm
            [[ ! "$confirm" =~ ^[Yy]$ ]] && exit 1
        fi
        ;;
    *)
        echo -e "${RED}Unsupported OS: $OS${NC}"
        echo -e "${CYAN}Supported: Ubuntu 20.04-24.04, Debian 9-12${NC}"
        exit 1
        ;;
esac

echo ""
echo -e "${GREEN}✓${NC} OS Check Passed"
echo ""

# Download main script
echo -e "${CYAN}Downloading main script...${NC}"
wget -q --show-progress https://raw.githubusercontent.com/YOURUSERNAME/tunnel/main/tunnel.sh -O /root/tunnel.sh

if [[ $? -ne 0 ]]; then
    echo -e "${RED}Failed to download script${NC}"
    echo "Please check your internet connection"
    exit 1
fi

# Make executable
chmod +x /root/tunnel.sh

echo ""
echo -e "${GREEN}✓${NC} Download Complete"
echo ""
echo -e "${CYAN}Starting installation...${NC}"
echo ""

# Run main script
/root/tunnel.sh

# If script exits before reboot, keep this installer
if [[ $? -ne 0 ]]; then
    echo ""
    echo -e "${RED}Installation failed${NC}"
    echo "Please check the errors above"
    exit 1
fi
