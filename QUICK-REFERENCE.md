# 📚 QUICK REFERENCE - VPN Auto Script

## 🚀 INSTALLATION

```bash
# One-line install
wget -qO- https://raw.githubusercontent.com/YOURUSERNAME/tunnel/main/install.sh | bash

# Or manual
wget https://raw.githubusercontent.com/YOURUSERNAME/tunnel/main/tunnel.sh
chmod +x tunnel.sh
sudo ./tunnel.sh
```

---

## 🔧 STABILITY FIX (Jika masih disconnect)

```bash
# Download & run
wget https://raw.githubusercontent.com/YOURUSERNAME/tunnel/main/fix-ping-loss.sh
chmod +x fix-ping-loss.sh
sudo ./fix-ping-loss.sh

# Restart services
systemctl restart xray nginx

# Verify BBR active
sysctl net.ipv4.tcp_congestion_control
# Output harus: bbr
```

---

## 📋 MENU COMMANDS

### Main Menu
```bash
# Run menu
/root/tunnel.sh
# or just login via SSH (auto-run)

[01] SSH MENU          - Manage SSH accounts
[02] VMESS MENU        - Manage VMess accounts  
[03] VLESS MENU        - Manage VLESS accounts
[04] TROJAN MENU       - Manage Trojan accounts
[05] NOOBZVPN         - Manage NoobzVPN accounts
[06] SHADOWSOCKS      - Manage Shadowsocks accounts
[07] INSTALL UDP      - Install UDP Custom
[08] BCKP/RSTR        - Backup & Restore
[09] GOTOP X RAM      - System monitor
[10] RESTART ALL      - Restart all services
[11] TELE BOT         - Telegram bot setup
[12] UPDATE MENU      - Update script
[13] RUNNING          - Check service status
[14] INFO PORT        - View all ports
[15] MENU BOT         - Bot management
[16] CHANGE DOMAIN    - Change domain
[17] FIX CRT DOMAIN   - Fix SSL certificate
[20] SPEEDTEST        - Test bandwidth
```

---

## 🎯 QUICK ACTIONS

### Create Account (Example: VMess)
```
Menu → [02] → [1]
User: johndoe
Days: 30
Quota (GB): 100
IP Limit: 2
```

### Trial Account (All protocols)
```
Menu → [02/03/04/05/06] → [2]
# Auto-generates trial account
```

### Check Services
```bash
# Via menu
Menu → [13]

# Via command
systemctl status xray
systemctl status nginx
systemctl status dropbear
```

### Restart Services
```bash
# All services
Menu → [10]

# Individual
systemctl restart xray
systemctl restart nginx
```

---

## 🔍 TROUBLESHOOTING

### Xray Not Running
```bash
systemctl status xray
journalctl -u xray -n 50
systemctl restart xray
```

### SSL Certificate Error
```bash
# Via menu
Menu → [17]

# Manual
systemctl stop nginx xray
certbot certonly --standalone -d yourdomain.com --force-renew
systemctl start nginx xray
```

### Connection Dropping
```bash
# Check BBR
sysctl net.ipv4.tcp_congestion_control

# If not bbr, run:
./fix-ping-loss.sh

# Also set in client:
# MTU: 1400
# Mux: Enabled
```

### Ping Loss
```bash
# Run optimization
./fix-ping-loss.sh

# Test ping
ping -c 100 8.8.8.8

# Monitor continuously
watch -n 1 'ping -c 5 8.8.8.8'
```

---

## 📂 FILE LOCATIONS

### Configuration
```bash
/usr/local/etc/xray/config.json    # Xray config
/etc/xray/xray.crt                 # SSL cert
/etc/xray/xray.key                 # SSL key
/root/domain                       # Domain
```

### Accounts
```bash
/root/akun/vmess-*.txt      # VMess accounts
/root/akun/vless-*.txt      # VLESS accounts
/root/akun/trojan-*.txt     # Trojan accounts
/root/akun/ssh-*.txt        # SSH accounts
```

### Logs
```bash
/var/log/xray/access.log    # Access log
/var/log/xray/error.log     # Error log
```

### Web Files
```bash
/var/www/html/              # OpenClash configs
```

---

## 🔑 COMMON COMMANDS

### Service Management
```bash
systemctl status xray       # Check Xray
systemctl restart xray      # Restart Xray
systemctl enable xray       # Enable auto-start

systemctl status nginx      # Check Nginx
systemctl restart nginx     # Restart Nginx

systemctl status dropbear   # Check Dropbear
systemctl restart dropbear  # Restart Dropbear
```

### Check Ports
```bash
netstat -tulpn | grep LISTEN    # All listening ports
netstat -tulpn | grep :443      # Port 443 only
lsof -i :443                    # What's using 443
```

### Check Connections
```bash
netstat -an | grep ESTABLISHED | wc -l  # Active connections
ss -s                                    # Socket statistics
```

### System Resources
```bash
free -h             # Memory usage
df -h               # Disk usage
htop                # Interactive monitor
nload               # Network usage
iftop               # Network bandwidth
```

---

## 🌐 PROTOCOL PORTS

### VMess
```
TLS: 443, 8443, 2087, 2096
Non-TLS: 80, 8080, 8880, 2082
gRPC: 10443
```

### VLESS
```
TLS: 443, 8443, 2087, 2096
Non-TLS: 80, 8080, 2082
gRPC: 10444
```

### Trojan
```
TCP: 10445
WS-TLS: 10446
WS-NonTLS: 10447
gRPC: 10448
```

### Others
```
SSH: 22
Dropbear: 109, 143
NoobzVPN: 8080
Shadowsocks: 8388
UDP Custom: 7300
Nginx: 81
```

---

## 🔄 UPDATE SCRIPT

### Auto Update
```bash
# Via menu
Menu → [12]
```

### Manual Update
```bash
# Backup
cp /root/tunnel.sh /root/tunnel.sh.backup

# Download latest
wget https://raw.githubusercontent.com/YOURUSERNAME/tunnel/main/tunnel.sh -O /root/tunnel.sh

# Make executable
chmod +x /root/tunnel.sh

# Run
./tunnel.sh
```

---

## 💾 BACKUP & RESTORE

### Backup Accounts
```bash
# Manual backup
tar -czf /root/backup-$(date +%F).tar.gz /root/akun/

# Via menu
Menu → [08] → Backup
```

### Restore Accounts
```bash
# Extract backup
tar -xzf /root/backup-2026-02-10.tar.gz -C /

# Via menu  
Menu → [08] → Restore
```

---

## 📱 CLIENT SETTINGS (RECOMMENDED)

### V2RayN / NekoBox
```
MTU: 1400
Mux: Enabled (4 connections)
Fragment: Enabled
DNS: 1.1.1.1, 8.8.8.8
```

### Clash / ClashMeta
```yaml
mtu: 1400
udp: true
skip-cert-verify: false
```

---

## 🆘 EMERGENCY COMMANDS

### Kill All Connections
```bash
systemctl restart xray
systemctl restart nginx
systemctl restart haproxy
```

### Reset Firewall
```bash
ufw --force reset
ufw allow 22/tcp
ufw allow 80/tcp
ufw allow 443/tcp
ufw enable
```

### Fix Permissions
```bash
chmod 755 /usr/local/etc/xray
chmod 644 /usr/local/etc/xray/config.json
chmod 644 /etc/xray/xray.*
chown -R nobody:nogroup /var/log/xray
```

### Reinstall Xray
```bash
bash <(curl -Ls https://github.com/XTLS/Xray-install/raw/main/install-release.sh)
systemctl restart xray
```

---

## 📊 MONITORING

### Real-time Monitoring
```bash
# System resources
htop

# Network bandwidth
nload
# or
iftop

# Xray logs
tail -f /var/log/xray/access.log

# Service status
watch -n 1 'systemctl status xray | grep Active'
```

### Check Account Usage
```bash
# Via menu
Menu → [02/03/04] → [5]  # Check login

# Via logs
grep "username" /var/log/xray/access.log
```

---

## 🔐 SECURITY TIPS

1. **Change SSH Port**
```bash
nano /etc/ssh/sshd_config
# Change Port 22 to something else
systemctl restart sshd
```

2. **Enable Firewall**
```bash
ufw allow 22/tcp
ufw allow 80/tcp
ufw allow 443/tcp
ufw enable
```

3. **Disable Root Login**
```bash
nano /etc/ssh/sshd_config
# Set: PermitRootLogin no
systemctl restart sshd
```

4. **Set IP Limits**
```
When creating accounts, set IP Limit = 1 or 2
```

5. **Set Bandwidth Quotas**
```
Set reasonable GB limits per user
```

---

## 📞 GET HELP

### Documentation
- README.md - Full guide
- VPN-STABILITY-GUIDE.md - Stability issues
- CHANGELOG.md - Version history

### Support
- GitHub Issues: https://github.com/YOURUSERNAME/tunnel/issues
- Telegram: @yourgroup
- Email: support@yourdomain.com

---

## ✅ CHECKLIST AFTER INSTALL

- [ ] All services running (Menu → [13])
- [ ] BBR enabled (`sysctl net.ipv4.tcp_congestion_control`)
- [ ] SSL certificate valid (check domain)
- [ ] Test account created successfully
- [ ] Client can connect and browse
- [ ] Connection stable for 30+ minutes
- [ ] No ping loss (`ping -c 100 8.8.8.8`)
- [ ] Telegram bot configured (optional)

---

**Made with ❤️ by The Proffessor Squad**

**Last Updated:** February 10, 2026
