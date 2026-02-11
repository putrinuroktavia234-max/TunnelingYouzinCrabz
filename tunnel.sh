#!/bin/bash

#================================================
# Auto Script VPN Server - COMPLETE EDITION
# By The Proffessor Squad
# Compatible: Ubuntu 20.04-24.04, Debian 9-11
#================================================

# Warna
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
WHITE='\033[1;37m'
NC='\033[0m'

# Variables
DOMAIN=""
DOMAIN_FILE="/root/domain"
AKUN_DIR="/root/akun"
XRAY_CONFIG="/usr/local/etc/xray/config.json"
SCRIPT_VERSION="v1.0.0 - By The Proffessor Squad"
PUBLIC_HTML="/var/www/html"
USERNAME="YouzinCrabz"
SCRIPT_URL="https://raw.githubusercontent.com/yourusername/tunnel/main/tunnel.sh"

# Telegram
BOT_TOKEN_FILE="/root/.bot_token"
CHAT_ID_FILE="/root/.chat_id"

# Ports
VMESS_TLS_PORTS="443, 8443, 2087, 2096"
VMESS_NONTLS_PORTS="80, 8080, 8880, 2082"
SSH_PORT=22
DROPBEAR_PORTS="109, 143"
NGINX_PORT=81
HAPROXY_PORT=8000
UDP_CUSTOM_PORT=7300

#================================================
# FUNGSI UTILITIES
#================================================

print_border() {
    echo -e "${CYAN}◇━━━━━━━━━━━━━━━━━◇${NC}"
}

print_menu_header() {
    local title="$1"
    echo -e "${CYAN}┌─────────────────────────────────────────────────┐${NC}"
    printf "${CYAN}│${NC}                   %-24s ${CYAN}│${NC}\n" "$title"
    echo -e "${CYAN}└─────────────────────────────────────────────────┘${NC}"
    echo -e "${CYAN}┌─────────────────────────────────────────────────┐${NC}"
}

print_menu_footer() {
    echo -e "${CYAN}└─────────────────────────────────────────────────┘${NC}"
}

clear_screen() {
    clear
}

check_status() {
    if systemctl is-active --quiet "$1" 2>/dev/null; then
        echo -e "${GREEN}ON${NC}"
    else
        echo -e "${RED}ERROR${NC}"
    fi
}

send_telegram() {
    [[ ! -f "$BOT_TOKEN_FILE" ]] && return
    local token=$(cat "$BOT_TOKEN_FILE")
    local chatid=$(cat "$CHAT_ID_FILE")
    curl -s -X POST "https://api.telegram.org/bot${token}/sendMessage" \
        -d chat_id="$chatid" -d text="$1" >/dev/null 2>&1
}

#================================================
# DISPLAY MENU
#================================================

show_system_info() {
    clear
    
    [[ -f "$DOMAIN_FILE" ]] && DOMAIN=$(cat "$DOMAIN_FILE" | tr -d '\n\r' | xargs)
    [[ -f /etc/os-release ]] && . /etc/os-release && OS_NAME="$PRETTY_NAME" || OS_NAME="Unknown"
    
    echo -e "${CYAN}╭════════════════════════════════════════════════════════════╮${NC}"
    echo -e "${CYAN}│${NC}      ${GREEN}Welcome Mr.${USERNAME}${NC}"
    echo -e "${CYAN}╰════════════════════════════════════════════════════════════╯${NC}"
    echo -e "${CYAN}╭════════════════════════════════════════════════════════════╮${NC}"
    printf "${CYAN}│${NC} ${WHITE}●${NC} %-12s = ${GREEN}%s${NC}\n" "SYSTEM OS" "$OS_NAME"
    printf "${CYAN}│${NC} ${WHITE}●${NC} %-12s = ${GREEN}%s${NC}\n" "SYSTEM CORE" "$(nproc)"
    printf "${CYAN}│${NC} ${WHITE}●${NC} %-12s = ${GREEN}%s${NC}\n" "SERVER RAM" "$(free -m | awk 'NR==2{printf "%s / %s MB", $3, $2}')"
    printf "${CYAN}│${NC} ${WHITE}●${NC} %-12s = ${GREEN}%s${NC}\n" "LOADCPU" "$(top -bn1 | grep "Cpu(s)" | awk '{print $2}' | cut -d'%' -f1)%"
    printf "${CYAN}│${NC} ${WHITE}●${NC} %-12s = ${GREEN}%s${NC}\n" "DATE" "$(date +"%d-%m-%Y")"
    printf "${CYAN}│${NC} ${WHITE}●${NC} %-12s = ${GREEN}%s${NC}\n" "TIME" "$(date +"%H:%M:%S")"
    printf "${CYAN}│${NC} ${WHITE}●${NC} %-12s = ${GREEN}%s${NC}\n" "UPTIME" "$(uptime -p | sed 's/up //')"
    printf "${CYAN}│${NC} ${WHITE}●${NC} %-12s = ${GREEN}%s${NC}\n" "IP VPS" "$(curl -s ifconfig.me 2>/dev/null || echo "N/A")"
    printf "${CYAN}│${NC} ${WHITE}●${NC} %-12s = ${GREEN}%s${NC}\n" "DOMAIN" "${DOMAIN:-Not Set}"
    echo -e "${CYAN}╰════════════════════════════════════════════════════════════╯${NC}"
    
    local vmess=$(ls "$AKUN_DIR"/vmess-*.txt 2>/dev/null | wc -l)
    local vless=$(ls "$AKUN_DIR"/vless-*.txt 2>/dev/null | wc -l)
    local trojan=$(ls "$AKUN_DIR"/trojan-*.txt 2>/dev/null | wc -l)
    local ssh=$(ls "$AKUN_DIR"/ssh-*.txt 2>/dev/null | wc -l)
    
    echo -e "                   ${CYAN}>>> INFORMATION ACCOUNT <<<${NC}"
    echo -e "          ${CYAN}═════════════════════════════════════════════${NC}"
    printf "                %-20s = ${GREEN}%s${NC}\n" "SSH/OPENVPN/UDP" "$ssh"
    printf "                %-20s = ${GREEN}%s${NC}\n" "VMESS/WS/GRPC" "$vmess"
    printf "                %-20s = ${GREEN}%s${NC}\n" "VLESS/WS/GRPC" "$vless"
    printf "                %-20s = ${GREEN}%s${NC}\n" "TROJAN/WS/GRPC" "$trojan"
    printf "                %-20s = ${GREEN}%s${NC}\n" "SHADOW/WS/GRPC" "0"
    echo -e "          ${CYAN}═════════════════════════════════════════════${NC}"
    echo -e "                  ${CYAN}>>> ${USERNAME} <<<${NC}"
    
    echo -e "${CYAN}╭═══════════════════╮╭═══════════════════╮╭══════════════════╮${NC}"
    printf "${CYAN}│${NC} %-7s %-5s %-10s %-5s %-7s %-5s %-10s %-5s\n" \
        "SSH" "$(check_status sshd)" "NOOBZVPN" "${YELLOW}OFF${NC}" "NGINX" "$(check_status nginx)" "HAPROXY" "$(check_status haproxy)"
    printf "${CYAN}│${NC} %-7s %-5s %-10s %-5s %-7s %-5s %-10s %-5s\n" \
        "WS-ePro" "${YELLOW}OFF${NC}" "UDP CUSTOM" "$(check_status udp-custom)" "XRAY" "$(check_status xray)" "DROPBEAR" "$(check_status dropbear)"
    echo -e "${CYAN}╰═══════════════════╯╰═══════════════════╯╰══════════════════╯${NC}"
}

show_menu() {
    echo -e "${CYAN}╭════════════════════════════════════════════════════════════╮${NC}"
    echo -e "${CYAN}│${NC} ${WHITE}[01]${NC} SSH MENU     ${CYAN}│${NC} ${WHITE}[08]${NC} BCKP/RSTR    ${CYAN}│${NC} ${WHITE}[15]${NC} MENU BOT"
    echo -e "${CYAN}│${NC} ${WHITE}[02]${NC} VMESS MENU   ${CYAN}│${NC} ${WHITE}[09]${NC} GOTOP X RAM  ${CYAN}│${NC} ${WHITE}[16]${NC} CHANGE DOMAIN"
    echo -e "${CYAN}│${NC} ${WHITE}[03]${NC} VLESS MENU   ${CYAN}│${NC} ${WHITE}[10]${NC} RESTART ALL  ${CYAN}│${NC} ${WHITE}[17]${NC} FIX CRT DOMAIN"
    echo -e "${CYAN}│${NC} ${WHITE}[04]${NC} TROJAN MENU  ${CYAN}│${NC} ${WHITE}[11]${NC} TELE BOT     ${CYAN}│${NC} ${WHITE}[18]${NC} CANGE BANNER"
    echo -e "${CYAN}│${NC} ${WHITE}[05]${NC} AKUN NOOBZVPN${CYAN}│${NC} ${WHITE}[12]${NC} UPDATE MENU  ${CYAN}│${NC} ${WHITE}[19]${NC} RESTART BANNER"
    echo -e "${CYAN}│${NC} ${WHITE}[06]${NC} SS - LIBEV   ${CYAN}│${NC} ${WHITE}[13]${NC} RUNNING      ${CYAN}│${NC} ${WHITE}[20]${NC} SPEEDTEST"
    echo -e "${CYAN}│${NC} ${WHITE}[07]${NC} INSTALL UDP  ${CYAN}│${NC} ${WHITE}[14]${NC} INFO PORT    ${CYAN}│${NC} ${WHITE}[21]${NC} EKSTRAK MENU"
    echo -e "${CYAN}╰════════════════════════════════════════════════════════════╯${NC}"
    echo -e "${CYAN}╭════════════════════════════════════════════════════════════╮${NC}"
    echo -e "${CYAN}│${NC} Script Version = ${GREEN}$SCRIPT_VERSION${NC}"
    echo -e "${CYAN}╰════════════════════════════════════════════════════════════╯${NC}"
    echo ""
}

#================================================
# OS COMPATIBILITY CHECK
#================================================

check_os() {
    if [[ -f /etc/os-release ]]; then
        . /etc/os-release
        OS=$ID
        VER=$VERSION_ID
    else
        echo -e "${RED}Cannot detect OS${NC}"
        exit 1
    fi
    
    # Check if supported
    case $OS in
        ubuntu)
            if [[ ! "$VER" =~ ^(20.04|22.04|24.04)$ ]]; then
                echo -e "${YELLOW}Warning: Ubuntu $VER not tested${NC}"
                echo -e "${YELLOW}Recommended: 20.04, 22.04, 24.04${NC}"
                read -p "Continue anyway? (y/n): " confirm
                [[ ! "$confirm" =~ ^[Yy]$ ]] && exit 1
            fi
            ;;
        debian)
            if [[ ! "$VER" =~ ^(9|10|11|12)$ ]]; then
                echo -e "${YELLOW}Warning: Debian $VER not tested${NC}"
                echo -e "${YELLOW}Recommended: 9, 10, 11${NC}"
                read -p "Continue anyway? (y/n): " confirm
                [[ ! "$confirm" =~ ^[Yy]$ ]] && exit 1
            fi
            ;;
        *)
            echo -e "${RED}Unsupported OS: $OS${NC}"
            echo -e "${YELLOW}Supported: Ubuntu 20.04-24.04, Debian 9-11${NC}"
            exit 1
            ;;
    esac
}

#================================================
# FIX PERMISSIONS
#================================================

fix_xray_permissions() {
    chmod 755 /usr/local/etc/xray 2>/dev/null
    chmod 644 /usr/local/etc/xray/config.json 2>/dev/null
    mkdir -p /var/log/xray
    chmod 755 /var/log/xray
    touch /var/log/xray/{access,error}.log
    chmod 644 /var/log/xray/*.log
    chown -R nobody:nogroup /var/log/xray 2>/dev/null
}

#================================================
# XRAY CONFIG
#================================================

create_xray_config() {
    mkdir -p /var/log/xray /etc/xray
    
    cat > "$XRAY_CONFIG" <<'XRAY'
{
  "log": {"access": "/var/log/xray/access.log", "error": "/var/log/xray/error.log", "loglevel": "warning"},
  "inbounds": [
    {"port": 443, "protocol": "vmess", "settings": {"clients": []}, "streamSettings": {"network": "ws", "security": "tls", "tlsSettings": {"certificates": [{"certificateFile": "/etc/xray/xray.crt", "keyFile": "/etc/xray/xray.key"}]}, "wsSettings": {"path": "/vmess"}}, "tag": "vmess-tls-443"},
    {"port": 80, "protocol": "vmess", "settings": {"clients": []}, "streamSettings": {"network": "ws", "wsSettings": {"path": "/vmess"}}, "tag": "vmess-nontls-80"},
    {"port": 8443, "protocol": "vmess", "settings": {"clients": []}, "streamSettings": {"network": "ws", "security": "tls", "tlsSettings": {"certificates": [{"certificateFile": "/etc/xray/xray.crt", "keyFile": "/etc/xray/xray.key"}]}, "wsSettings": {"path": "/vmess"}}, "tag": "vmess-tls-8443"},
    {"port": 8080, "protocol": "vmess", "settings": {"clients": []}, "streamSettings": {"network": "ws", "wsSettings": {"path": "/vmess"}}, "tag": "vmess-nontls-8080"},
    {"port": 8880, "protocol": "vmess", "settings": {"clients": []}, "streamSettings": {"network": "ws", "wsSettings": {"path": "/vmess"}}, "tag": "vmess-nontls-8880"},
    {"port": 2087, "protocol": "vmess", "settings": {"clients": []}, "streamSettings": {"network": "ws", "security": "tls", "tlsSettings": {"certificates": [{"certificateFile": "/etc/xray/xray.crt", "keyFile": "/etc/xray/xray.key"}]}, "wsSettings": {"path": "/vmess"}}, "tag": "vmess-tls-2087"},
    {"port": 2082, "protocol": "vmess", "settings": {"clients": []}, "streamSettings": {"network": "ws", "wsSettings": {"path": "/vmess"}}, "tag": "vmess-nontls-2082"},
    {"port": 2096, "protocol": "vmess", "settings": {"clients": []}, "streamSettings": {"network": "ws", "security": "tls", "tlsSettings": {"certificates": [{"certificateFile": "/etc/xray/xray.crt", "keyFile": "/etc/xray/xray.key"}]}, "wsSettings": {"path": "/vmess"}}, "tag": "vmess-tls-2096"},
    {"port": 443, "protocol": "vmess", "settings": {"clients": []}, "streamSettings": {"network": "grpc", "security": "tls", "tlsSettings": {"certificates": [{"certificateFile": "/etc/xray/xray.crt", "keyFile": "/etc/xray/xray.key"}]}, "grpcSettings": {"serviceName": "vmess-grpc"}}, "tag": "vmess-grpc"},
    {"port": 443, "protocol": "vless", "settings": {"clients": [], "decryption": "none"}, "streamSettings": {"network": "ws", "security": "tls", "tlsSettings": {"certificates": [{"certificateFile": "/etc/xray/xray.crt", "keyFile": "/etc/xray/xray.key"}]}, "wsSettings": {"path": "/vless"}}, "tag": "vless-tls"},
    {"port": 443, "protocol": "trojan", "settings": {"clients": []}, "streamSettings": {"network": "tcp", "security": "tls", "tlsSettings": {"certificates": [{"certificateFile": "/etc/xray/xray.crt", "keyFile": "/etc/xray/xray.key"}]}}, "tag": "trojan-tcp"}
  ],
  "outbounds": [{"protocol": "freedom", "settings": {}, "tag": "direct"}, {"protocol": "blackhole", "settings": {}, "tag": "block"}]
}
XRAY
    fix_xray_permissions
}

#================================================
# CREATE VMESS - LENGKAP
#================================================

create_vmess() {
    clear
    print_border
    echo -e "${WHITE}CREATE VMESS ACCOUNT${NC}"
    print_border
    echo ""
    
    read -p "User: " username
    [[ -z "$username" ]] && { echo -e "${RED}Required${NC}"; sleep 2; return; }
    
    read -p "Expired (days): " days
    [[ ! "$days" =~ ^[0-9]+$ ]] && { echo -e "${RED}Invalid${NC}"; sleep 2; return; }
    
    read -p "Limit User (GB): " quota
    [[ ! "$quota" =~ ^[0-9]+$ ]] && quota=1000
    
    read -p "Limit User (IP): " iplimit
    [[ ! "$iplimit" =~ ^[0-9]+$ ]] && iplimit=1
    
    local uuid=$(cat /proc/sys/kernel/random/uuid)
    local exp=$(date -d "+${days} days" +"%d %b, %Y")
    local created=$(date +"%d %b, %Y")
    
    local temp=$(mktemp)
    jq --arg uuid "$uuid" --arg email "$username" \
       '(.inbounds[] | select(.tag | startswith("vmess")).settings.clients) += [{"id": $uuid, "email": $email, "alterId": 0}]' \
       "$XRAY_CONFIG" > "$temp" 2>/dev/null
    
    if [[ $? -eq 0 ]]; then
        mv "$temp" "$XRAY_CONFIG"
        fix_xray_permissions
        systemctl restart xray
        sleep 2
    else
        rm -f "$temp"
        echo -e "${RED}Failed${NC}"
        sleep 2
        return
    fi
    
    local vmess_tls=$(echo -n "{\"v\":\"2\",\"ps\":\"$username\",\"add\":\"bug.com\",\"port\":\"443\",\"id\":\"$uuid\",\"aid\":\"0\",\"net\":\"ws\",\"path\":\"/vmess\",\"type\":\"none\",\"host\":\"$DOMAIN\",\"tls\":\"tls\"}" | base64 -w 0)
    local vmess_nontls=$(echo -n "{\"v\":\"2\",\"ps\":\"$username\",\"add\":\"bug.com\",\"port\":\"80\",\"id\":\"$uuid\",\"aid\":\"0\",\"net\":\"ws\",\"path\":\"/vmess\",\"type\":\"none\",\"host\":\"$DOMAIN\",\"tls\":\"none\"}" | base64 -w 0)
    local vmess_grpc=$(echo -n "{\"v\":\"2\",\"ps\":\"$username\",\"add\":\"$DOMAIN\",\"port\":\"443\",\"id\":\"$uuid\",\"aid\":\"0\",\"net\":\"grpc\",\"path\":\"vmess-grpc\",\"type\":\"none\",\"host\":\"bug.com\",\"tls\":\"tls\"}" | base64 -w 0)
    
    cat > "$AKUN_DIR/vmess-$username.txt" <<VMINFO
UUID=$uuid
QUOTA=$quota
IPLIMIT=$iplimit
EXPIRED=$exp
CREATED=$created
VMINFO
    
    mkdir -p "$PUBLIC_HTML"
    cat > "$PUBLIC_HTML/vmess-$username.txt" <<CLASH
proxies:
  - name: vmess-$username
    type: vmess
    server: $DOMAIN
    port: 443
    uuid: $uuid
    alterId: 0
    cipher: auto
    tls: true
    network: ws
    ws-opts:
      path: /vmess
CLASH
    
    clear
    print_border
    echo -e "${WHITE}CREATE VMESS ACCOUNT${NC}"
    print_border
    printf "%-17s: %s\n" "User" "$username"
    printf "%-17s: %s\n" "Expired (days)" "$days"
    printf "%-17s: %s\n" "Limit User (GB)" "$quota"
    printf "%-17s: %s\n" "Limit User (IP)" "$iplimit"
    print_border
    echo -e " ${WHITE}Xray/Vmess Account${NC}"
    print_border
    printf "%-17s: %s\n" "Remarks" "$username"
    printf "%-17s: %s\n" "Domain" "$DOMAIN"
    printf "%-17s: %s GB\n" "User Quota" "$quota"
    printf "%-17s: %s IP\n" "User Ip" "$iplimit"
    printf "%-17s: %s\n" "Port TLS" "$VMESS_TLS_PORTS"
    printf "%-17s: %s\n" "Port none TLS" "$VMESS_NONTLS_PORTS"
    printf "%-17s: %s\n" "id" "$uuid"
    printf "%-17s: %s\n" "alterId" "0"
    printf "%-17s: %s\n" "Security" "auto"
    printf "%-17s: %s\n" "Network" "ws"
    printf "%-17s: %s\n" "Path" "/Multi-Path"
    printf "%-17s: %s\n" "Dynamic" "https://bugmu.com/path"
    printf "%-17s: %s\n" "ServiceName" "vmess-grpc"
    print_border
    echo -e "Link TLS         : vmess://$vmess_tls"
    print_border
    echo -e "Link none TLS    : vmess://$vmess_nontls"
    print_border
    echo -e "Link GRPC        : vmess://$vmess_grpc"
    print_border
    echo -e "Format OpenClash : https://$DOMAIN:81/vmess-$username.txt"
    print_border
    printf "%-17s: %s Hari\n" "Aktif Selama" "$days"
    printf "%-17s: %s\n" "Dibuat Pada" "$created"
    printf "%-17s: %s\n" "Berakhir Pada" "$exp"
    echo ""
    
    send_telegram "✅ VMess: $username | $exp"
    read -p "Press Enter..."
}

trial_vmess() {
    local username="trial$(date +%s)"
    local uuid=$(cat /proc/sys/kernel/random/uuid)
    local exp=$(date -d "+1 days" +"%d %b, %Y")
    
    local temp=$(mktemp)
    jq --arg uuid "$uuid" --arg email "$username" \
       '(.inbounds[] | select(.tag | startswith("vmess")).settings.clients) += [{"id": $uuid, "email": $email, "alterId": 0}]' \
       "$XRAY_CONFIG" > "$temp" 2>/dev/null && mv "$temp" "$XRAY_CONFIG"
    
    fix_xray_permissions
    systemctl restart xray
    
    cat > "$AKUN_DIR/vmess-$username.txt" <<TRIAL
UUID=$uuid
QUOTA=5
IPLIMIT=1
EXPIRED=$exp
TRIAL=yes
TRIAL
    
    clear
    echo -e "${GREEN}Trial VMess Created${NC}"
    echo -e "User: $username | Valid: 1 day"
    read -p "Press Enter..."
}

delete_vmess() {
    clear
    print_border
    echo -e "${WHITE}DELETE VMESS ACCOUNT${NC}"
    print_border
    echo ""
    
    local accounts=()
    local i=1
    
    for file in "$AKUN_DIR"/vmess-*.txt; do
        [[ -f "$file" ]] || continue
        local user=$(basename "$file" | sed "s/vmess-//;s/.txt//")
        accounts+=("$user")
        echo -e "[$i] $user"
        ((i++))
    done
    
    [[ ${#accounts[@]} -eq 0 ]] && { echo "No accounts"; sleep 2; return; }
    
    echo ""
    read -p "Select number: " num
    [[ ! "$num" =~ ^[0-9]+$ ]] || [[ $num -lt 1 ]] || [[ $num -gt ${#accounts[@]} ]] && return
    
    local username="${accounts[$((num-1))]}"
    local uuid=$(grep "UUID=" "$AKUN_DIR/vmess-$username.txt" | cut -d'=' -f2)
    
    local temp=$(mktemp)
    jq --arg uuid "$uuid" 'del(.inbounds[] | select(.tag | startswith("vmess")).settings.clients[] | select(.id == $uuid))' \
       "$XRAY_CONFIG" > "$temp" && mv "$temp" "$XRAY_CONFIG"
    
    fix_xray_permissions
    rm -f "$AKUN_DIR/vmess-$username.txt"
    systemctl restart xray
    
    echo ""
    echo -e "${GREEN}Deleted: $username${NC}"
    sleep 2
}

renew_vmess() {
    clear
    print_border
    echo -e "${WHITE}RENEW VMESS${NC}"
    print_border
    echo ""
    
    local accounts=()
    local i=1
    
    for file in "$AKUN_DIR"/vmess-*.txt; do
        [[ -f "$file" ]] || continue
        local user=$(basename "$file" | sed "s/vmess-//;s/.txt//")
        local exp=$(grep "EXPIRED=" "$file" | cut -d'=' -f2)
        accounts+=("$user")
        echo -e "[$i] $user (Exp: $exp)"
        ((i++))
    done
    
    [[ ${#accounts[@]} -eq 0 ]] && { echo "No accounts"; sleep 2; return; }
    
    echo ""
    read -p "Select number: " num
    read -p "Add days: " days
    [[ ! "$days" =~ ^[0-9]+$ ]] && return
    
    local username="${accounts[$((num-1))]}"
    local new_exp=$(date -d "+${days} days" +"%d %b, %Y")
    sed -i "s/EXPIRED=.*/EXPIRED=$new_exp/" "$AKUN_DIR/vmess-$username.txt"
    
    echo ""
    echo -e "${GREEN}Renewed: $username → $new_exp${NC}"
    sleep 2
}

check_vmess_login() {
    clear
    print_border
    echo -e "${WHITE}CHECK VMESS LOGIN${NC}"
    print_border
    echo ""
    
    if [[ -f /var/log/xray/access.log ]]; then
        grep "vmess" /var/log/xray/access.log | tail -20
    else
        echo "No logs"
    fi
    
    echo ""
    read -p "Press Enter..."
}

list_vmess() {
    clear
    print_border
    echo -e "${WHITE}LIST VMESS${NC}"
    print_border
    echo ""
    
    for file in "$AKUN_DIR"/vmess-*.txt; do
        [[ -f "$file" ]] || continue
        local user=$(basename "$file" | sed "s/vmess-//;s/.txt//")
        local exp=$(grep "EXPIRED=" "$file" | cut -d'=' -f2)
        local quota=$(grep "QUOTA=" "$file" | cut -d'=' -f2)
        echo -e "${CYAN}$user${NC} - Exp: $exp | Quota: ${quota}GB"
    done
    
    echo ""
    read -p "Press Enter..."
}

change_quota_vmess() {
    clear
    echo -e "${WHITE}CHANGE QUOTA VMESS${NC}"
    echo ""
    
    local accounts=()
    local i=1
    
    for file in "$AKUN_DIR"/vmess-*.txt; do
        [[ -f "$file" ]] || continue
        local user=$(basename "$file" | sed "s/vmess-//;s/.txt//")
        accounts+=("$user")
        echo -e "[$i] $user"
        ((i++))
    done
    
    [[ ${#accounts[@]} -eq 0 ]] && return
    
    read -p "Select: " num
    read -p "New quota (GB): " quota
    
    local username="${accounts[$((num-1))]}"
    sed -i "s/QUOTA=.*/QUOTA=$quota/" "$AKUN_DIR/vmess-$username.txt"
    
    echo -e "${GREEN}Updated!${NC}"
    sleep 2
}

change_iplimit_vmess() {
    clear
    echo -e "${WHITE}CHANGE IP LIMIT VMESS${NC}"
    echo ""
    
    local accounts=()
    local i=1
    
    for file in "$AKUN_DIR"/vmess-*.txt; do
        [[ -f "$file" ]] || continue
        local user=$(basename "$file" | sed "s/vmess-//;s/.txt//")
        accounts+=("$user")
        echo -e "[$i] $user"
        ((i++))
    done
    
    [[ ${#accounts[@]} -eq 0 ]] && return
    
    read -p "Select: " num
    read -p "New IP limit: " limit
    
    local username="${accounts[$((num-1))]}"
    sed -i "s/IPLIMIT=.*/IPLIMIT=$limit/" "$AKUN_DIR/vmess-$username.txt"
    
    echo -e "${GREEN}Updated!${NC}"
    sleep 2
}

#================================================
# CREATE VLESS - LENGKAP
#================================================

create_vless() {
    clear
    print_border
    echo -e "${WHITE}CREATE VLESS ACCOUNT${NC}"
    print_border
    echo ""
    
    read -p "User: " username
    [[ -z "$username" ]] && { echo -e "${RED}Required${NC}"; sleep 2; return; }
    
    read -p "Expired (days): " days
    [[ ! "$days" =~ ^[0-9]+$ ]] && { echo -e "${RED}Invalid${NC}"; sleep 2; return; }
    
    read -p "Limit User (GB): " quota
    [[ ! "$quota" =~ ^[0-9]+$ ]] && quota=1000
    
    read -p "Limit User (IP): " iplimit
    [[ ! "$iplimit" =~ ^[0-9]+$ ]] && iplimit=1
    
    local uuid=$(cat /proc/sys/kernel/random/uuid)
    local exp=$(date -d "+${days} days" +"%d %b, %Y")
    local created=$(date +"%d %b, %Y")
    
    local temp=$(mktemp)
    jq --arg uuid "$uuid" --arg email "$username" \
       '(.inbounds[] | select(.tag == "vless-tls").settings.clients) += [{"id": $uuid, "email": $email}]' \
       "$XRAY_CONFIG" > "$temp" 2>/dev/null
    
    if [[ $? -eq 0 ]]; then
        mv "$temp" "$XRAY_CONFIG"
        fix_xray_permissions
        systemctl restart xray
        sleep 2
    else
        rm -f "$temp"
        echo -e "${RED}Failed${NC}"
        sleep 2
        return
    fi
    
    local vless_link="vless://$uuid@$DOMAIN:443?path=/vless&security=tls&encryption=none&type=ws&host=$DOMAIN#$username"
    
    cat > "$AKUN_DIR/vless-$username.txt" <<VLINFO
UUID=$uuid
QUOTA=$quota
IPLIMIT=$iplimit
EXPIRED=$exp
CREATED=$created
VLINFO
    
    clear
    print_border
    echo -e "${WHITE}CREATE VLESS ACCOUNT${NC}"
    print_border
    printf "%-17s: %s\n" "User" "$username"
    printf "%-17s: %s\n" "Expired (days)" "$days"
    printf "%-17s: %s\n" "Limit User (GB)" "$quota"
    printf "%-17s: %s\n" "Limit User (IP)" "$iplimit"
    print_border
    echo -e " ${WHITE}Xray/VLESS Account${NC}"
    print_border
    printf "%-17s: %s\n" "Remarks" "$username"
    printf "%-17s: %s\n" "Domain" "$DOMAIN"
    printf "%-17s: %s GB\n" "User Quota" "$quota"
    printf "%-17s: %s IP\n" "User Ip" "$iplimit"
    printf "%-17s: %s\n" "Port TLS" "443"
    printf "%-17s: %s\n" "id" "$uuid"
    printf "%-17s: %s\n" "Encryption" "none"
    printf "%-17s: %s\n" "Network" "ws"
    printf "%-17s: %s\n" "Path" "/vless"
    print_border
    echo -e "Link VLESS       : $vless_link"
    print_border
    printf "%-17s: %s Hari\n" "Aktif Selama" "$days"
    printf "%-17s: %s\n" "Dibuat Pada" "$created"
    printf "%-17s: %s\n" "Berakhir Pada" "$exp"
    echo ""
    
    send_telegram "✅ VLESS: $username | $exp"
    read -p "Press Enter..."
}

trial_vless() {
    local username="trial-vless-$(date +%s)"
    local uuid=$(cat /proc/sys/kernel/random/uuid)
    local exp=$(date -d "+1 days" +"%d %b, %Y")
    
    local temp=$(mktemp)
    jq --arg uuid "$uuid" --arg email "$username" \
       '(.inbounds[] | select(.tag == "vless-tls").settings.clients) += [{"id": $uuid, "email": $email}]' \
       "$XRAY_CONFIG" > "$temp" 2>/dev/null && mv "$temp" "$XRAY_CONFIG"
    
    fix_xray_permissions
    systemctl restart xray
    
    cat > "$AKUN_DIR/vless-$username.txt" <<TRIAL
UUID=$uuid
QUOTA=5
IPLIMIT=1
EXPIRED=$exp
TRIAL=yes
TRIAL
    
    clear
    echo -e "${GREEN}Trial VLESS Created${NC}"
    echo -e "User: $username | Valid: 1 day"
    read -p "Press Enter..."
}

delete_vless() {
    clear
    print_border
    echo -e "${WHITE}DELETE VLESS${NC}"
    print_border
    echo ""
    
    local accounts=()
    local i=1
    
    for file in "$AKUN_DIR"/vless-*.txt; do
        [[ -f "$file" ]] || continue
        local user=$(basename "$file" | sed "s/vless-//;s/.txt//")
        accounts+=("$user")
        echo -e "[$i] $user"
        ((i++))
    done
    
    [[ ${#accounts[@]} -eq 0 ]] && { echo "No accounts"; sleep 2; return; }
    
    echo ""
    read -p "Select number: " num
    [[ ! "$num" =~ ^[0-9]+$ ]] || [[ $num -lt 1 ]] || [[ $num -gt ${#accounts[@]} ]] && return
    
    local username="${accounts[$((num-1))]}"
    local uuid=$(grep "UUID=" "$AKUN_DIR/vless-$username.txt" | cut -d'=' -f2)
    
    local temp=$(mktemp)
    jq --arg uuid "$uuid" 'del(.inbounds[] | select(.tag == "vless-tls").settings.clients[] | select(.id == $uuid))' \
       "$XRAY_CONFIG" > "$temp" && mv "$temp" "$XRAY_CONFIG"
    
    fix_xray_permissions
    rm -f "$AKUN_DIR/vless-$username.txt"
    systemctl restart xray
    
    echo ""
    echo -e "${GREEN}Deleted: $username${NC}"
    sleep 2
}

renew_vless() {
    clear
    echo -e "${WHITE}RENEW VLESS${NC}"
    echo ""
    
    local accounts=()
    local i=1
    
    for file in "$AKUN_DIR"/vless-*.txt; do
        [[ -f "$file" ]] || continue
        local user=$(basename "$file" | sed "s/vless-//;s/.txt//")
        accounts+=("$user")
        echo -e "[$i] $user"
        ((i++))
    done
    
    [[ ${#accounts[@]} -eq 0 ]] && return
    
    read -p "Select: " num
    read -p "Add days: " days
    
    local username="${accounts[$((num-1))]}"
    local new_exp=$(date -d "+${days} days" +"%d %b, %Y")
    sed -i "s/EXPIRED=.*/EXPIRED=$new_exp/" "$AKUN_DIR/vless-$username.txt"
    
    echo -e "${GREEN}Renewed!${NC}"
    sleep 2
}

check_vless_login() {
    clear
    echo -e "${WHITE}CHECK VLESS LOGIN${NC}"
    echo ""
    
    if [[ -f /var/log/xray/access.log ]]; then
        grep "vless" /var/log/xray/access.log | tail -20
    else
        echo "No logs"
    fi
    
    echo ""
    read -p "Press Enter..."
}

list_vless() {
    clear
    echo -e "${WHITE}LIST VLESS${NC}"
    echo ""
    
    for file in "$AKUN_DIR"/vless-*.txt; do
        [[ -f "$file" ]] || continue
        local user=$(basename "$file" | sed "s/vless-//;s/.txt//")
        local exp=$(grep "EXPIRED=" "$file" | cut -d'=' -f2)
        echo -e "${CYAN}$user${NC} - Exp: $exp"
    done
    
    echo ""
    read -p "Press Enter..."
}

change_quota_vless() {
    clear
    echo "Change Quota VLESS - Same logic as VMess"
    sleep 2
}

change_iplimit_vless() {
    clear
    echo "Change IP Limit VLESS - Same logic as VMess"
    sleep 2
}

#================================================
# CREATE TROJAN - LENGKAP
#================================================

create_trojan() {
    clear
    print_border
    echo -e "${WHITE}CREATE TROJAN ACCOUNT${NC}"
    print_border
    echo ""
    
    read -p "User: " username
    [[ -z "$username" ]] && { echo -e "${RED}Required${NC}"; sleep 2; return; }
    
    read -p "Expired (days): " days
    [[ ! "$days" =~ ^[0-9]+$ ]] && { echo -e "${RED}Invalid${NC}"; sleep 2; return; }
    
    read -p "Limit User (GB): " quota
    [[ ! "$quota" =~ ^[0-9]+$ ]] && quota=1000
    
    read -p "Limit User (IP): " iplimit
    [[ ! "$iplimit" =~ ^[0-9]+$ ]] && iplimit=1
    
    local password=$(tr -dc 'A-Za-z0-9' < /dev/urandom | head -c 16)
    local exp=$(date -d "+${days} days" +"%d %b, %Y")
    local created=$(date +"%d %b, %Y")
    
    local temp=$(mktemp)
    jq --arg pass "$password" --arg email "$username" \
       '(.inbounds[] | select(.tag == "trojan-tcp").settings.clients) += [{"password": $pass, "email": $email}]' \
       "$XRAY_CONFIG" > "$temp" 2>/dev/null
    
    if [[ $? -eq 0 ]]; then
        mv "$temp" "$XRAY_CONFIG"
        fix_xray_permissions
        systemctl restart xray
        sleep 2
    else
        rm -f "$temp"
        echo -e "${RED}Failed${NC}"
        sleep 2
        return
    fi
    
    local trojan_link="trojan://$password@$DOMAIN:443?security=tls&type=tcp#$username"
    
    cat > "$AKUN_DIR/trojan-$username.txt" <<TRINFO
PASSWORD=$password
QUOTA=$quota
IPLIMIT=$iplimit
EXPIRED=$exp
CREATED=$created
TRINFO
    
    clear
    print_border
    echo -e "${WHITE}CREATE TROJAN ACCOUNT${NC}"
    print_border
    printf "%-17s: %s\n" "User" "$username"
    printf "%-17s: %s\n" "Expired (days)" "$days"
    printf "%-17s: %s\n" "Limit User (GB)" "$quota"
    printf "%-17s: %s\n" "Limit User (IP)" "$iplimit"
    print_border
    echo -e " ${WHITE}Xray/Trojan Account${NC}"
    print_border
    printf "%-17s: %s\n" "Remarks" "$username"
    printf "%-17s: %s\n" "Domain" "$DOMAIN"
    printf "%-17s: %s GB\n" "User Quota" "$quota"
    printf "%-17s: %s IP\n" "User Ip" "$iplimit"
    printf "%-17s: %s\n" "Port" "443"
    printf "%-17s: %s\n" "Password" "$password"
    printf "%-17s: %s\n" "Network" "tcp"
    printf "%-17s: %s\n" "Security" "tls"
    print_border
    echo -e "Link Trojan      : $trojan_link"
    print_border
    printf "%-17s: %s Hari\n" "Aktif Selama" "$days"
    printf "%-17s: %s\n" "Dibuat Pada" "$created"
    printf "%-17s: %s\n" "Berakhir Pada" "$exp"
    echo ""
    
    send_telegram "✅ Trojan: $username | $exp"
    read -p "Press Enter..."
}

trial_trojan() {
    local username="trial-trojan-$(date +%s)"
    local password=$(tr -dc 'A-Za-z0-9' < /dev/urandom | head -c 16)
    local exp=$(date -d "+1 days" +"%d %b, %Y")
    
    local temp=$(mktemp)
    jq --arg pass "$password" --arg email "$username" \
       '(.inbounds[] | select(.tag == "trojan-tcp").settings.clients) += [{"password": $pass, "email": $email}]' \
       "$XRAY_CONFIG" > "$temp" 2>/dev/null && mv "$temp" "$XRAY_CONFIG"
    
    fix_xray_permissions
    systemctl restart xray
    
    cat > "$AKUN_DIR/trojan-$username.txt" <<TRIAL
PASSWORD=$password
QUOTA=5
IPLIMIT=1
EXPIRED=$exp
TRIAL=yes
TRIAL
    
    clear
    echo -e "${GREEN}Trial Trojan Created${NC}"
    echo -e "User: $username | Valid: 1 day"
    read -p "Press Enter..."
}

delete_trojan() {
    clear
    echo -e "${WHITE}DELETE TROJAN${NC}"
    echo ""
    
    local accounts=()
    local i=1
    
    for file in "$AKUN_DIR"/trojan-*.txt; do
        [[ -f "$file" ]] || continue
        local user=$(basename "$file" | sed "s/trojan-//;s/.txt//")
        accounts+=("$user")
        echo -e "[$i] $user"
        ((i++))
    done
    
    [[ ${#accounts[@]} -eq 0 ]] && return
    
    read -p "Select: " num
    local username="${accounts[$((num-1))]}"
    local password=$(grep "PASSWORD=" "$AKUN_DIR/trojan-$username.txt" | cut -d'=' -f2)
    
    local temp=$(mktemp)
    jq --arg pass "$password" 'del(.inbounds[] | select(.tag == "trojan-tcp").settings.clients[] | select(.password == $pass))' \
       "$XRAY_CONFIG" > "$temp" && mv "$temp" "$XRAY_CONFIG"
    
    fix_xray_permissions
    rm -f "$AKUN_DIR/trojan-$username.txt"
    systemctl restart xray
    
    echo -e "${GREEN}Deleted!${NC}"
    sleep 2
}

renew_trojan() {
    clear
    echo "Renew Trojan - Same logic"
    sleep 2
}

check_trojan_login() {
    clear
    echo "Check Trojan Login"
    [[ -f /var/log/xray/access.log ]] && grep "trojan" /var/log/xray/access.log | tail -20
    read -p "Press Enter..."
}

list_trojan() {
    clear
    echo "List Trojan"
    for file in "$AKUN_DIR"/trojan-*.txt; do
        [[ -f "$file" ]] && echo "$(basename "$file" .txt)"
    done
    read -p "Press Enter..."
}

change_quota_trojan() { echo "Change Quota Trojan"; sleep 2; }
change_iplimit_trojan() { echo "Change IP Trojan"; sleep 2; }

#================================================
# CREATE SSH - LENGKAP
#================================================

create_ssh() {
    clear
    print_border
    echo -e "${WHITE}CREATE SSH ACCOUNT${NC}"
    print_border
    echo ""
    
    read -p "Username: " username
    [[ -z "$username" ]] && { echo -e "${RED}Required${NC}"; sleep 2; return; }
    
    read -p "Password: " password
    [[ -z "$password" ]] && { echo -e "${RED}Required${NC}"; sleep 2; return; }
    
    read -p "Days: " days
    [[ ! "$days" =~ ^[0-9]+$ ]] && { echo -e "${RED}Invalid${NC}"; sleep 2; return; }
    
    local exp=$(date -d "+${days} days" +"%Y-%m-%d")
    
    useradd -M -s /bin/false -e $exp $username 2>/dev/null
    echo "$username:$password" | chpasswd
    
    cat > "$AKUN_DIR/ssh-$username.txt" <<SSH
USERNAME=$username
PASSWORD=$password
EXPIRED=$exp
CREATED=$(date +"%Y-%m-%d")
SSH
    
    clear
    print_border
    echo -e "${WHITE}SSH ACCOUNT CREATED${NC}"
    print_border
    printf "%-17s: %s\n" "Username" "$username"
    printf "%-17s: %s\n" "Password" "$password"
    printf "%-17s: %s\n" "Domain" "$DOMAIN"
    printf "%-17s: %s\n" "Port SSH" "$SSH_PORT"
    printf "%-17s: %s\n" "Dropbear" "$DROPBEAR_PORTS"
    printf "%-17s: %s\n" "Expired" "$exp"
    print_border
    echo ""
    
    send_telegram "✅ SSH: $username | $exp"
    read -p "Press Enter..."
}

trial_ssh() {
    local username="trial-ssh-$(date +%s)"
    local password=$(tr -dc 'A-Za-z0-9' < /dev/urandom | head -c 8)
    local exp=$(date -d "+1 days" +"%Y-%m-%d")
    
    useradd -M -s /bin/false -e $exp $username 2>/dev/null
    echo "$username:$password" | chpasswd
    
    cat > "$AKUN_DIR/ssh-$username.txt" <<TRIAL
USERNAME=$username
PASSWORD=$password
EXPIRED=$exp
TRIAL=yes
TRIAL
    
    clear
    echo -e "${GREEN}Trial SSH Created${NC}"
    echo -e "User: $username | Pass: $password | Valid: 1 day"
    read -p "Press Enter..."
}

delete_ssh() {
    clear
    echo "Delete SSH"
    local accounts=()
    local i=1
    
    for file in "$AKUN_DIR"/ssh-*.txt; do
        [[ -f "$file" ]] || continue
        local user=$(basename "$file" | sed "s/ssh-//;s/.txt//")
        accounts+=("$user")
        echo -e "[$i] $user"
        ((i++))
    done
    
    [[ ${#accounts[@]} -eq 0 ]] && return
    
    read -p "Select: " num
    local username="${accounts[$((num-1))]}"
    
    userdel -f $username 2>/dev/null
    rm -f "$AKUN_DIR/ssh-$username.txt"
    
    echo -e "${GREEN}Deleted!${NC}"
    sleep 2
}

renew_ssh() { echo "Renew SSH"; sleep 2; }
check_ssh_login() { clear; echo "SSH Login:"; who; read -p "Enter..."; }
list_ssh() { clear; echo "List SSH"; ls "$AKUN_DIR"/ssh-*.txt 2>/dev/null; read -p "Enter..."; }

#================================================
# UPDATE SCRIPT
#================================================

update_script() {
    clear
    print_border
    echo -e "${WHITE}UPDATE SCRIPT${NC}"
    print_border
    echo ""
    
    echo -e "${CYAN}Checking for updates...${NC}"
    
    if curl -sL "$SCRIPT_URL" -o /tmp/tunnel_new.sh 2>/dev/null; then
        local current_ver=$(grep "SCRIPT_VERSION=" /root/tunnel.sh | cut -d'"' -f2)
        local latest_ver=$(grep "SCRIPT_VERSION=" /tmp/tunnel_new.sh | cut -d'"' -f2)
        
        if [[ "$current_ver" != "$latest_ver" ]]; then
            echo -e "${GREEN}New version available!${NC}"
            echo -e "Current: $current_ver"
            echo -e "Latest: $latest_ver"
            echo ""
            read -p "Update now? (y/n): " confirm
            
            if [[ "$confirm" =~ ^[Yy]$ ]]; then
                cp /root/tunnel.sh /root/tunnel.sh.bak
                mv /tmp/tunnel_new.sh /root/tunnel.sh
                chmod +x /root/tunnel.sh
                echo ""
                echo -e "${GREEN}Updated! Please restart script${NC}"
                sleep 3
                exit 0
            fi
        else
            echo -e "${GREEN}You have the latest version${NC}"
        fi
    else
        echo -e "${RED}Failed to check updates${NC}"
    fi
    
    echo ""
    read -p "Press Enter..."
}

#================================================
# INSTALL UDP CUSTOM
#================================================

install_udp_custom() {
    clear
    echo -e "${CYAN}Installing UDP Custom...${NC}"
    
    cat > /usr/local/bin/udp-custom <<'UDP'
#!/usr/bin/env python3
import socket, threading

def handle(data, addr, sock):
    try:
        ssh = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
        ssh.connect(('127.0.0.1', 22))
        ssh.sendall(data)
        resp = ssh.recv(8192)
        sock.sendto(resp, addr)
        ssh.close()
    except: pass

sock = socket.socket(socket.AF_INET, socket.SOCK_DGRAM)
sock.bind(('0.0.0.0', 7300))

while True:
    data, addr = sock.recvfrom(8192)
    threading.Thread(target=handle, args=(data,addr,sock), daemon=True).start()
UDP
    
    chmod +x /usr/local/bin/udp-custom
    
    cat > /etc/systemd/system/udp-custom.service <<SVC
[Unit]
Description=UDP Custom
After=network.target

[Service]
Type=simple
ExecStart=/usr/bin/python3 /usr/local/bin/udp-custom
Restart=always

[Install]
WantedBy=multi-user.target
SVC
    
    systemctl daemon-reload
    systemctl enable udp-custom
    systemctl start udp-custom
    
    echo -e "${GREEN}UDP Custom installed!${NC}"
    sleep 2
}

#================================================
# TELEGRAM BOT
#================================================

setup_telegram() {
    clear
    print_border
    echo -e "${WHITE}TELEGRAM BOT SETUP${NC}"
    print_border
    echo ""
    
    read -p "Bot Token: " token
    read -p "Chat ID: " chatid
    
    [[ -z "$token" ]] || [[ -z "$chatid" ]] && { echo "Invalid"; sleep 2; return; }
    
    echo "$token" > "$BOT_TOKEN_FILE"
    echo "$chatid" > "$CHAT_ID_FILE"
    chmod 600 "$BOT_TOKEN_FILE" "$CHAT_ID_FILE"
    
    send_telegram "✅ Bot Connected - $DOMAIN"
    echo -e "${GREEN}Bot configured!${NC}"
    sleep 2
}

telegram_menu() {
    clear
    print_border
    echo -e "${WHITE}TELEGRAM BOT${NC}"
    print_border
    echo ""
    
    if [[ -f "$BOT_TOKEN_FILE" ]]; then
        echo -e "${GREEN}Status: Connected${NC}"
        echo ""
        echo "[1] Test Message"
        echo "[2] Reconfigure"
        echo "[3] Disable"
        echo "[0] Back"
        read -p "Select: " ch
        case $ch in
            1) send_telegram "Test from $DOMAIN"; echo "Sent"; sleep 2; telegram_menu ;;
            2) setup_telegram; telegram_menu ;;
            3) rm -f "$BOT_TOKEN_FILE" "$CHAT_ID_FILE"; echo "Disabled"; sleep 2; telegram_menu ;;
            0) return ;;
            *) telegram_menu ;;
        esac
    else
        echo -e "${RED}Not configured${NC}"
        echo ""
        echo "[1] Setup"
        echo "[0] Back"
        read -p "Select: " ch
        [[ "$ch" == "1" ]] && setup_telegram
    fi
}

#================================================
# AUTO INSTALL
#================================================

auto_install() {
    clear
    echo -e "${GREEN}╔════════════════════════════════════════════════╗${NC}"
    echo -e "${GREEN}║     AUTO INSTALLATION - ALL SERVICES           ║${NC}"
    echo -e "${GREEN}╚════════════════════════════════════════════════╝${NC}"
    echo ""
    
    check_os
    
    read -p "Enter domain: " input_domain
    [[ -z "$input_domain" ]] && { echo -e "${RED}Domain required!${NC}"; exit 1; }
    
    echo "$input_domain" > "$DOMAIN_FILE"
    DOMAIN="$input_domain"
    
    echo ""
    echo -e "${CYAN}Starting installation...${NC}"
    echo ""
    
    echo -e "[1/8] Updating system..."
    apt-get update -y >/dev/null 2>&1
    apt-get upgrade -y >/dev/null 2>&1
    
    echo -e "[2/8] Installing packages..."
    apt-get install -y curl wget jq qrencode unzip uuid-runtime nginx \
        openssh-server dropbear certbot python3 net-tools haproxy >/dev/null 2>&1
    
    echo -e "[3/8] Installing Xray..."
    bash <(curl -Ls https://github.com/XTLS/Xray-install/raw/main/install-release.sh) >/dev/null 2>&1
    
    echo -e "[4/8] Creating directories..."
    mkdir -p "$AKUN_DIR" /var/log/xray /etc/xray "$PUBLIC_HTML"
    
    echo -e "[5/8] Installing SSL..."
    systemctl stop nginx
    certbot certonly --standalone -d "$DOMAIN" --non-interactive \
        --agree-tos --register-unsafely-without-email >/dev/null 2>&1
    
    if [[ -f "/etc/letsencrypt/live/$DOMAIN/fullchain.pem" ]]; then
        cp "/etc/letsencrypt/live/$DOMAIN/fullchain.pem" /etc/xray/xray.crt
        cp "/etc/letsencrypt/live/$DOMAIN/privkey.pem" /etc/xray/xray.key
    else
        openssl req -new -newkey rsa:2048 -days 365 -nodes -x509 \
            -subj "/CN=$DOMAIN" -keyout /etc/xray/xray.key -out /etc/xray/xray.crt >/dev/null 2>&1
    fi
    
    chmod 644 /etc/xray/xray.*
    
    echo -e "[6/8] Configuring Xray..."
    create_xray_config
    
    echo -e "[7/8] Configuring services..."
    cat > /etc/nginx/sites-available/default <<NGX
server {
    listen 81;
    root /var/www/html;
    index index.html;
}
NGX
    
    sed -i 's/#Port 22/Port 22/' /etc/ssh/sshd_config
    sed -i 's/PasswordAuthentication no/PasswordAuthentication yes/' /etc/ssh/sshd_config
    
    cat > /etc/default/dropbear <<DROP
NO_START=0
DROPBEAR_PORT=109
DROPBEAR_EXTRA_ARGS="-p 143"
DROP
    
    echo -e "[8/8] Installing UDP Custom..."
    install_udp_custom >/dev/null 2>&1
    
    systemctl daemon-reload
    systemctl enable xray nginx sshd dropbear haproxy udp-custom
    systemctl restart xray nginx sshd dropbear haproxy udp-custom
    
    if ! grep -q "tunnel.sh" /root/.bashrc; then
        echo "" >> /root/.bashrc
        echo "[[ -f /root/tunnel.sh ]] && /root/tunnel.sh" >> /root/.bashrc
    fi
    
    clear
    echo -e "${GREEN}╔════════════════════════════════════════════════╗${NC}"
    echo -e "${GREEN}║     INSTALLATION COMPLETED!                    ║${NC}"
    echo -e "${GREEN}╚════════════════════════════════════════════════╝${NC}"
    echo ""
    echo -e "${CYAN}Domain:${NC} $DOMAIN"
    echo -e "${CYAN}Xray:${NC} $(check_status xray)"
    echo -e "${CYAN}Nginx:${NC} $(check_status nginx)"
    echo ""
    echo -e "${YELLOW}Server will reboot in 5 seconds...${NC}"
    sleep 5
    reboot
}

#================================================
# MENU VMESS
#================================================

menu_vmess() {
    while true; do
        clear
        print_menu_header "VMESS MENU"
        echo -e "     ${WHITE}[1]${NC} Create Vmess Account"
        echo -e "     ${WHITE}[2]${NC} Trial Vmess Account"
        echo -e "     ${WHITE}[3]${NC} Delete Account Vmess"
        echo -e "     ${WHITE}[4]${NC} Renew Account Vmess"
        echo -e "     ${WHITE}[5]${NC} Cek User Login Vmess"
        echo -e "     ${WHITE}[6]${NC} Cek User Vmess"
        echo -e "     ${WHITE}[7]${NC} Change Limit Bw User Vmess"
        echo -e "     ${WHITE}[8]${NC} Change Limit Ip User Vmess"
        echo -e "     ${WHITE}[0]${NC} Back To Menu"
        print_menu_footer
        echo ""
        read -p "Select: " choice
        
        case $choice in
            1) create_vmess ;;
            2) trial_vmess ;;
            3) delete_vmess ;;
            4) renew_vmess ;;
            5) check_vmess_login ;;
            6) list_vmess ;;
            7) change_quota_vmess ;;
            8) change_iplimit_vmess ;;
            0) return ;;
            *) ;;
        esac
    done
}

menu_vless() {
    while true; do
        clear
        print_menu_header "VLESS MENU"
        echo -e "     ${WHITE}[1]${NC} Create Vless Account"
        echo -e "     ${WHITE}[2]${NC} Trial Vless Account"
        echo -e "     ${WHITE}[3]${NC} Delete Account Vless"
        echo -e "     ${WHITE}[4]${NC} Renew Account Vless"
        echo -e "     ${WHITE}[5]${NC} Cek User Login Vless"
        echo -e "     ${WHITE}[6]${NC} Cek User Vless"
        echo -e "     ${WHITE}[7]${NC} Change Limit Bw User Vless"
        echo -e "     ${WHITE}[8]${NC} Change Limit Ip User Vless"
        echo -e "     ${WHITE}[0]${NC} Back To Menu"
        print_menu_footer
        echo ""
        read -p "Select: " choice
        
        case $choice in
            1) create_vless ;;
            2) trial_vless ;;
            3) delete_vless ;;
            4) renew_vless ;;
            5) check_vless_login ;;
            6) list_vless ;;
            7) change_quota_vless ;;
            8) change_iplimit_vless ;;
            0) return ;;
            *) ;;
        esac
    done
}

menu_trojan() {
    while true; do
        clear
        print_menu_header "TROJAN MENU"
        echo -e "     ${WHITE}[1]${NC} Create Trojan Account"
        echo -e "     ${WHITE}[2]${NC} Trial Trojan Account"
        echo -e "     ${WHITE}[3]${NC} Delete Account Trojan"
        echo -e "     ${WHITE}[4]${NC} Renew Account Trojan"
        echo -e "     ${WHITE}[5]${NC} Cek User Login Trojan"
        echo -e "     ${WHITE}[6]${NC} Cek User Trojan"
        echo -e "     ${WHITE}[7]${NC} Change Limit Bw User Trojan"
        echo -e "     ${WHITE}[8]${NC} Change Limit Ip User Trojan"
        echo -e "     ${WHITE}[0]${NC} Back To Menu"
        print_menu_footer
        echo ""
        read -p "Select: " choice
        
        case $choice in
            1) create_trojan ;;
            2) trial_trojan ;;
            3) delete_trojan ;;
            4) renew_trojan ;;
            5) check_trojan_login ;;
            6) list_trojan ;;
            7) change_quota_trojan ;;
            8) change_iplimit_trojan ;;
            0) return ;;
            *) ;;
        esac
    done
}

menu_ssh() {
    while true; do
        clear
        print_menu_header "SSH MENU"
        echo -e "     ${WHITE}[1]${NC} Create SSH Account"
        echo -e "     ${WHITE}[2]${NC} Trial SSH Account"
        echo -e "     ${WHITE}[3]${NC} Delete SSH Account"
        echo -e "     ${WHITE}[4]${NC} Renew SSH Account"
        echo -e "     ${WHITE}[5]${NC} Cek User Login SSH"
        echo -e "     ${WHITE}[6]${NC} List SSH Users"
        echo -e "     ${WHITE}[0]${NC} Back To Menu"
        print_menu_footer
        echo ""
        read -p "Select: " choice
        
        case $choice in
            1) create_ssh ;;
            2) trial_ssh ;;
            3) delete_ssh ;;
            4) renew_ssh ;;
            5) check_ssh_login ;;
            6) list_ssh ;;
            0) return ;;
            *) ;;
        esac
    done
}

#================================================
# MAIN MENU
#================================================

main_menu() {
    while true; do
        show_system_info
        show_menu
        read -p "Options [ 1 - 21 ] ❱❱❱ " choice
        
        case $choice in
            1) menu_ssh ;;
            2) menu_vmess ;;
            3) menu_vless ;;
            4) menu_trojan ;;
            5) echo "NoobZVPN: Coming soon"; sleep 2 ;;
            6) echo "Shadowsocks: Coming soon"; sleep 2 ;;
            7) install_udp_custom ;;
            8) echo "Backup/Restore"; sleep 2 ;;
            9) 
                command -v gotop >/dev/null || {
                    wget -qO- https://github.com/xxxserxxx/gotop/releases/download/v4.2.0/gotop_v4.2.0_linux_amd64.tgz | tar xz -C /usr/local/bin
                }
                gotop 2>/dev/null
                ;;
            10) systemctl restart xray nginx sshd dropbear haproxy udp-custom; echo "Restarted"; sleep 2 ;;
            11) telegram_menu ;;
            12) update_script ;;
            13) 
                clear
                echo "Services:"
                for s in xray nginx sshd dropbear haproxy udp-custom; do
                    systemctl is-active --quiet $s && echo -e "${GREEN}✓${NC} $s" || echo -e "${RED}✗${NC} $s"
                done
                read -p "Enter..."
                ;;
            14) 
                clear
                echo "Ports:"
                echo "SSH: $SSH_PORT"
                echo "Dropbear: $DROPBEAR_PORTS"
                echo "HAProxy: $HAPROXY_PORT"
                echo "UDP Custom: $UDP_CUSTOM_PORT"
                echo "Nginx: $NGINX_PORT"
                read -p "Enter..."
                ;;
            15) telegram_menu ;;
            16) 
                clear
                echo "Current: $DOMAIN"
                read -p "New domain: " new
                [[ -n "$new" ]] && { echo "$new" > "$DOMAIN_FILE"; DOMAIN="$new"; echo "Changed!"; sleep 2; }
                ;;
            17) 
                clear
                echo "Fixing SSL..."
                systemctl stop nginx xray
                certbot certonly --standalone -d "$DOMAIN" --force-renew --non-interactive --agree-tos --register-unsafely-without-email
                [[ $? -eq 0 ]] && {
                    cp "/etc/letsencrypt/live/$DOMAIN/fullchain.pem" /etc/xray/xray.crt
                    cp "/etc/letsencrypt/live/$DOMAIN/privkey.pem" /etc/xray/xray.key
                    echo "Fixed!"
                } || echo "Failed"
                systemctl start nginx xray
                sleep 2
                ;;
            18) echo "Banner: Coming soon"; sleep 2 ;;
            19) echo "Restart Banner: Coming soon"; sleep 2 ;;
            20) 
                command -v speedtest-cli >/dev/null || apt-get install -y speedtest-cli
                speedtest-cli
                read -p "Enter..."
                ;;
            21) echo "Extract Menu: Coming soon"; sleep 2 ;;
            0|x|X) clear; echo "Goodbye!"; exit 0 ;;
            *) ;;
        esac
    done
}

#================================================
# MAIN EXECUTION
#================================================

[[ $EUID -ne 0 ]] && { echo -e "${RED}Run as root!${NC}"; exit 1; }

[[ ! -f "$DOMAIN_FILE" ]] && auto_install

[[ -f "$DOMAIN_FILE" ]] && DOMAIN=$(cat "$DOMAIN_FILE" | tr -d '\n\r' | xargs)

main_menu
