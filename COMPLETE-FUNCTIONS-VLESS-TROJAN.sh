# ====================================================
# FUNGSI CREATE VLESS - LENGKAP SEPERTI VMESS
# Copy paste ini ke script tunnel.sh Anda
# ====================================================

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
    
    # Add to ALL VLESS inbounds
    local temp=$(mktemp)
    jq --arg uuid "$uuid" --arg email "$username" \
       '(.inbounds[] | select(.tag | startswith("vless")).settings.clients) += [{"id": $uuid, "email": $email}]' \
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
    
    # Generate ALL links (sama seperti VMess!)
    local vless_tls_443="vless://$uuid@$DOMAIN:443?path=/vless&security=tls&encryption=none&type=ws&host=$DOMAIN#$username-TLS-443"
    local vless_nontls_80="vless://$uuid@$DOMAIN:80?path=/vless&security=none&encryption=none&type=ws&host=$DOMAIN#$username-NONTLS-80"
    local vless_tls_8443="vless://$uuid@$DOMAIN:8443?path=/vless&security=tls&encryption=none&type=ws&host=$DOMAIN#$username-TLS-8443"
    local vless_nontls_8080="vless://$uuid@$DOMAIN:8080?path=/vless&security=none&encryption=none&type=ws&host=$DOMAIN#$username-NONTLS-8080"
    local vless_tls_2087="vless://$uuid@$DOMAIN:2087?path=/vless&security=tls&encryption=none&type=ws&host=$DOMAIN#$username-TLS-2087"
    local vless_nontls_2082="vless://$uuid@$DOMAIN:2082?path=/vless&security=none&encryption=none&type=ws&host=$DOMAIN#$username-NONTLS-2082"
    local vless_tls_2096="vless://$uuid@$DOMAIN:2096?path=/vless&security=tls&encryption=none&type=ws&host=$DOMAIN#$username-TLS-2096"
    local vless_grpc="vless://$uuid@$DOMAIN:10444?security=tls&encryption=none&type=grpc&serviceName=vless-grpc&host=$DOMAIN#$username-GRPC"
    
    # Save metadata
    cat > "$AKUN_DIR/vless-$username.txt" <<VLINFO
UUID=$uuid
QUOTA=$quota
IPLIMIT=$iplimit
EXPIRED=$exp
CREATED=$created
VLINFO
    
    # OpenClash format
    mkdir -p "$PUBLIC_HTML"
    cat > "$PUBLIC_HTML/vless-$username.txt" <<CLASH
proxies:
  - name: vless-$username-TLS
    type: vless
    server: $DOMAIN
    port: 443
    uuid: $uuid
    tls: true
    network: ws
    ws-opts:
      path: /vless
      
  - name: vless-$username-GRPC
    type: vless
    server: $DOMAIN
    port: 10444
    uuid: $uuid
    tls: true
    network: grpc
    grpc-opts:
      grpc-service-name: vless-grpc
CLASH
    
    # Display LENGKAP (sama seperti VMess!)
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
    printf "%-17s: %s\n" "Port TLS" "443, 8443, 2087, 2096"
    printf "%-17s: %s\n" "Port none TLS" "80, 8080, 2082"
    printf "%-17s: %s\n" "Port gRPC" "10444"
    printf "%-17s: %s\n" "id" "$uuid"
    printf "%-17s: %s\n" "Encryption" "none"
    printf "%-17s: %s\n" "Network" "ws"
    printf "%-17s: %s\n" "Path" "/vless"
    printf "%-17s: %s\n" "ServiceName" "vless-grpc"
    print_border
    echo -e "Link TLS 443     : $vless_tls_443"
    print_border
    echo -e "Link none TLS 80 : $vless_nontls_80"
    print_border
    echo -e "Link TLS 8443    : $vless_tls_8443"
    print_border
    echo -e "Link none TLS 8080: $vless_nontls_8080"
    print_border
    echo -e "Link TLS 2087    : $vless_tls_2087"
    print_border
    echo -e "Link none TLS 2082: $vless_nontls_2082"
    print_border
    echo -e "Link TLS 2096    : $vless_tls_2096"
    print_border
    echo -e "Link GRPC        : $vless_grpc"
    print_border
    echo -e "Format OpenClash : https://$DOMAIN:81/vless-$username.txt"
    print_border
    printf "%-17s: %s Hari\n" "Aktif Selama" "$days"
    printf "%-17s: %s\n" "Dibuat Pada" "$created"
    printf "%-17s: %s\n" "Berakhir Pada" "$exp"
    echo ""
    
    send_telegram "✅ VLESS: $username | Exp: $exp | Quota: ${quota}GB"
    read -p "Press Enter..."
}

# ====================================================
# TRIAL VLESS - LENGKAP
# ====================================================

trial_vless() {
    local username="trial-vless-$(date +%s)"
    local uuid=$(cat /proc/sys/kernel/random/uuid)
    local exp=$(date -d "+1 days" +"%d %b, %Y")
    local created=$(date +"%d %b, %Y")
    local quota=5
    local iplimit=1
    
    local temp=$(mktemp)
    jq --arg uuid "$uuid" --arg email "$username" \
       '(.inbounds[] | select(.tag | startswith("vless")).settings.clients) += [{"id": $uuid, "email": $email}]' \
       "$XRAY_CONFIG" > "$temp" 2>/dev/null && mv "$temp" "$XRAY_CONFIG"
    
    fix_xray_permissions
    systemctl restart xray
    
    cat > "$AKUN_DIR/vless-$username.txt" <<TRIAL
UUID=$uuid
QUOTA=$quota
IPLIMIT=$iplimit
EXPIRED=$exp
CREATED=$created
TRIAL=yes
TRIAL
    
    # Generate links
    local vless_tls="vless://$uuid@$DOMAIN:443?path=/vless&security=tls&encryption=none&type=ws&host=$DOMAIN#$username"
    local vless_grpc="vless://$uuid@$DOMAIN:10444?security=tls&encryption=none&type=grpc&serviceName=vless-grpc&host=$DOMAIN#$username-GRPC"
    
    # Display LENGKAP (bukan cuma username/password!)
    clear
    print_border
    echo -e "${WHITE}TRIAL VLESS ACCOUNT${NC}"
    print_border
    printf "%-17s: %s\n" "User" "$username"
    printf "%-17s: %s\n" "Expired (days)" "1"
    printf "%-17s: %s\n" "Limit User (GB)" "$quota"
    printf "%-17s: %s\n" "Limit User (IP)" "$iplimit"
    print_border
    echo -e " ${WHITE}Xray/VLESS Account${NC}"
    print_border
    printf "%-17s: %s\n" "Remarks" "$username"
    printf "%-17s: %s\n" "Domain" "$DOMAIN"
    printf "%-17s: %s GB\n" "User Quota" "$quota"
    printf "%-17s: %s IP\n" "User Ip" "$iplimit"
    printf "%-17s: %s\n" "Port TLS" "443, 8443, 2087, 2096"
    printf "%-17s: %s\n" "Port none TLS" "80, 8080, 2082"
    printf "%-17s: %s\n" "Port gRPC" "10444"
    printf "%-17s: %s\n" "id" "$uuid"
    printf "%-17s: %s\n" "Network" "ws / grpc"
    printf "%-17s: %s\n" "Path" "/vless"
    print_border
    echo -e "Link TLS         : $vless_tls"
    print_border
    echo -e "Link GRPC        : $vless_grpc"
    print_border
    printf "%-17s: %s\n" "Expired" "$exp"
    echo ""
    read -p "Press Enter..."
}

# ====================================================
# FUNGSI CREATE TROJAN - LENGKAP SEPERTI VMESS
# ====================================================

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
    
    # Add to ALL TROJAN inbounds
    local temp=$(mktemp)
    jq --arg pass "$password" --arg email "$username" \
       '(.inbounds[] | select(.tag | startswith("trojan")).settings.clients) += [{"password": $pass, "email": $email}]' \
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
    
    # Generate ALL Trojan links
    local trojan_tcp="trojan://$password@$DOMAIN:10445?security=tls&type=tcp#$username-TCP"
    local trojan_ws_tls="trojan://$password@$DOMAIN:10446?path=/trojan&security=tls&type=ws&host=$DOMAIN#$username-WS-TLS"
    local trojan_ws_nontls="trojan://$password@$DOMAIN:10447?path=/trojan&security=none&type=ws&host=$DOMAIN#$username-WS-NONTLS"
    local trojan_grpc="trojan://$password@$DOMAIN:10448?security=tls&type=grpc&serviceName=trojan-grpc&host=$DOMAIN#$username-GRPC"
    
    # Save metadata
    cat > "$AKUN_DIR/trojan-$username.txt" <<TRINFO
PASSWORD=$password
QUOTA=$quota
IPLIMIT=$iplimit
EXPIRED=$exp
CREATED=$created
TRINFO
    
    # OpenClash
    mkdir -p "$PUBLIC_HTML"
    cat > "$PUBLIC_HTML/trojan-$username.txt" <<CLASH
proxies:
  - name: trojan-$username-TCP
    type: trojan
    server: $DOMAIN
    port: 10445
    password: $password
    sni: $DOMAIN
    
  - name: trojan-$username-WS
    type: trojan
    server: $DOMAIN
    port: 10446
    password: $password
    network: ws
    sni: $DOMAIN
    ws-opts:
      path: /trojan
      
  - name: trojan-$username-GRPC
    type: trojan
    server: $DOMAIN
    port: 10448
    password: $password
    network: grpc
    sni: $DOMAIN
    grpc-opts:
      grpc-service-name: trojan-grpc
CLASH
    
    # Display LENGKAP
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
    printf "%-17s: %s\n" "Port TCP" "10445"
    printf "%-17s: %s\n" "Port WS TLS" "10446"
    printf "%-17s: %s\n" "Port WS Non-TLS" "10447"
    printf "%-17s: %s\n" "Port gRPC" "10448"
    printf "%-17s: %s\n" "Password" "$password"
    printf "%-17s: %s\n" "Network" "tcp / ws / grpc"
    printf "%-17s: %s\n" "Path WS" "/trojan"
    printf "%-17s: %s\n" "ServiceName" "trojan-grpc"
    print_border
    echo -e "Link TCP         : $trojan_tcp"
    print_border
    echo -e "Link WS TLS      : $trojan_ws_tls"
    print_border
    echo -e "Link WS Non-TLS  : $trojan_ws_nontls"
    print_border
    echo -e "Link GRPC        : $trojan_grpc"
    print_border
    echo -e "Format OpenClash : https://$DOMAIN:81/trojan-$username.txt"
    print_border
    printf "%-17s: %s Hari\n" "Aktif Selama" "$days"
    printf "%-17s: %s\n" "Dibuat Pada" "$created"
    printf "%-17s: %s\n" "Berakhir Pada" "$exp"
    echo ""
    
    send_telegram "✅ Trojan: $username | Exp: $exp"
    read -p "Press Enter..."
}

# ====================================================
# TRIAL TROJAN - LENGKAP
# ====================================================

trial_trojan() {
    local username="trial-trojan-$(date +%s)"
    local password=$(tr -dc 'A-Za-z0-9' < /dev/urandom | head -c 16)
    local exp=$(date -d "+1 days" +"%d %b, %Y")
    local created=$(date +"%d %b, %Y")
    local quota=5
    local iplimit=1
    
    local temp=$(mktemp)
    jq --arg pass "$password" --arg email "$username" \
       '(.inbounds[] | select(.tag | startswith("trojan")).settings.clients) += [{"password": $pass, "email": $email}]' \
       "$XRAY_CONFIG" > "$temp" 2>/dev/null && mv "$temp" "$XRAY_CONFIG"
    
    fix_xray_permissions
    systemctl restart xray
    
    cat > "$AKUN_DIR/trojan-$username.txt" <<TRIAL
PASSWORD=$password
QUOTA=$quota
IPLIMIT=$iplimit
EXPIRED=$exp
TRIAL=yes
TRIAL
    
    local trojan_tcp="trojan://$password@$DOMAIN:10445?security=tls&type=tcp#$username"
    local trojan_grpc="trojan://$password@$DOMAIN:10448?security=tls&type=grpc&serviceName=trojan-grpc#$username"
    
    # Display LENGKAP
    clear
    print_border
    echo -e "${WHITE}TRIAL TROJAN ACCOUNT${NC}"
    print_border
    printf "%-17s: %s\n" "User" "$username"
    printf "%-17s: %s\n" "Password" "$password"
    printf "%-17s: %s\n" "Expired (days)" "1"
    printf "%-17s: %s GB\n" "Quota" "$quota"
    print_border
    echo -e " ${WHITE}Xray/Trojan Account${NC}"
    print_border
    printf "%-17s: %s\n" "Domain" "$DOMAIN"
    printf "%-17s: %s\n" "Port TCP" "10445"
    printf "%-17s: %s\n" "Port WS TLS" "10446"
    printf "%-17s: %s\n" "Port gRPC" "10448"
    printf "%-17s: %s\n" "Network" "tcp / ws / grpc"
    print_border
    echo -e "Link TCP         : $trojan_tcp"
    print_border
    echo -e "Link GRPC        : $trojan_grpc"
    print_border
    printf "%-17s: %s\n" "Expired" "$exp"
    echo ""
    read -p "Press Enter..."
}
