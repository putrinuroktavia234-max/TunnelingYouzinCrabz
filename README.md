# VPN Auto Script - Multi Protocol

[![License](https://img.shields.io/badge/license-MIT-blue.svg)](LICENSE)
[![OS Support](https://img.shields.io/badge/OS-Ubuntu%2020.04--24.04%20|%20Debian%209--11-green.svg)]()
[![Version](https://img.shields.io/badge/version-1.0.0-orange.svg)]()

Auto installation script for VPN server with multiple protocols support (VMess, VLESS, Trojan, SSH, UDP Custom).

**By The Proffessor Squad**

---

## 🌟 Features

### Supported Protocols
- ✅ **VMess** (WebSocket + gRPC + Multi-Port)
- ✅ **VLESS** (WebSocket + TLS)
- ✅ **Trojan** (TCP + TLS)
- ✅ **SSH** (OpenSSH + Dropbear)
- ✅ **UDP Custom** (SSH over UDP)

### Key Features
- 🚀 **One-Click Installation** - Automated setup in minutes
- 🔐 **Auto SSL Certificate** - Let's Encrypt with fallback to self-signed
- 📱 **Telegram Bot Integration** - Get notifications for all account activities
- 🎨 **Beautiful UI** - Professional menu design with color coding
- 📊 **Account Management** - Create, delete, renew, trial accounts
- 💾 **Bandwidth & IP Limit** - Control quota and concurrent connections
- 🔄 **Auto Update** - Update script from GitHub
- 🌐 **Multi-Port Support** - VMess works on ports: 443, 8443, 80, 8080, 8880, 2082, 2087, 2096
- 📱 **OpenClash Format** - Auto-generate config for OpenClash

---

## 📋 System Requirements

### Supported Operating Systems
- ✅ Ubuntu 20.04 LTS
- ✅ Ubuntu 22.04 LTS
- ✅ Ubuntu 24.04 LTS
- ✅ Debian 9 (Stretch)
- ✅ Debian 10 (Buster)
- ✅ Debian 11 (Bullseye)

### Minimum Requirements
- **RAM**: 512 MB (1 GB recommended)
- **CPU**: 1 Core
- **Storage**: 10 GB
- **Network**: Public IP with domain pointed to server
- **Root Access**: Required

### Required Ports
Make sure these ports are open in your firewall:
- `22` - SSH
- `80` - HTTP / WebSocket
- `81` - Nginx Web
- `109, 143` - Dropbear
- `443` - HTTPS / TLS
- `7300` - UDP Custom
- `8080, 8443, 8880` - VMess Alternative Ports
- `2082, 2087, 2096` - VMess Alternative Ports

---

## 🚀 Quick Installation

### 1. One-Line Install Command

```bash
wget -qO tunnel.sh https://raw.githubusercontent.com/putrinuroktavia234-max/TunnelingYouzinCrabz/main/tunnel.sh && chmod +x tunnel.sh && ./tunnel.sh

```

### 2. Step-by-Step Installation

```bash
# Download script
wget https://raw.githubusercontent.com/putrinuroktavia234-max/TunnelingYouzinCrabz/main/tunnel.sh

# Make executable
chmod +x tunnel.sh

# Run installation
sudo ./tunnel.sh
```

### 3. During Installation

The script will ask for:
1. **Domain name** - Your domain pointed to server IP
2. The script will automatically:
   - Update system
   - Install required packages
   - Install Xray-Core
   - Configure SSL certificate
   - Setup all services
   - Reboot server

### 4. After Reboot

The menu will appear automatically when you login via SSH.

---

## 📖 Usage Guide

### Main Menu

When you run the script, you'll see:

```
╭════════════════════════════════════════════════════════════╮
│      Welcome Mr.YouzinCrabz
╰════════════════════════════════════════════════════════════╯
╭════════════════════════════════════════════════════════════╮
│ ● SYSTEM OS    = Ubuntu 22.04.5 LTS
│ ● SYSTEM CORE  = 2
│ ● SERVER RAM   = 284 / 955 MB
│ ● LOADCPU      = 3%
│ ● DATE         = 10-02-2026
│ ● TIME         = 14:30:45
│ ● UPTIME       = 1 day, 5 hours
│ ● IP VPS       = 192.168.1.1
│ ● DOMAIN       = your.domain.com
╰════════════════════════════════════════════════════════════╯

                   >>> INFORMATION ACCOUNT <<<
          ═════════════════════════════════════════════
                SSH/OPENVPN/UDP  = 0
                VMESS/WS/GRPC    = 2
                VLESS/WS/GRPC    = 1
                TROJAN/WS/GRPC   = 1
          ═════════════════════════════════════════════

╭════════════════════════════════════════════════════════════╮
│ [01] SSH MENU     │ [08] BCKP/RSTR    │ [15] MENU BOT
│ [02] VMESS MENU   │ [09] GOTOP X RAM  │ [16] CHANGE DOMAIN
│ [03] VLESS MENU   │ [10] RESTART ALL  │ [17] FIX CRT DOMAIN
│ [04] TROJAN MENU  │ [11] TELE BOT     │ [18] CANGE BANNER
│ [05] AKUN NOOBZVPN│ [12] UPDATE MENU  │ [19] RESTART BANNER
│ [06] SS - LIBEV   │ [13] RUNNING      │ [20] SPEEDTEST
│ [07] INSTALL UDP  │ [14] INFO PORT    │ [21] EKSTRAK MENU
╰════════════════════════════════════════════════════════════╯

Options [ 1 - 21 ] ❱❱❱
```

### Menu Options Explained

| No | Menu | Description |
|----|------|-------------|
| 01 | SSH MENU | Create, delete, renew SSH accounts |
| 02 | VMESS MENU | Manage VMess accounts (8 options) |
| 03 | VLESS MENU | Manage VLESS accounts (8 options) |
| 04 | TROJAN MENU | Manage Trojan accounts (8 options) |
| 05 | AKUN NOOBZVPN | NoobVPN management (coming soon) |
| 06 | SS - LIBEV | Shadowsocks-libev (coming soon) |
| 07 | INSTALL UDP | Install UDP Custom service |
| 08 | BCKP/RSTR | Backup and restore configuration |
| 09 | GOTOP X RAM | System resource monitor |
| 10 | RESTART ALL | Restart all VPN services |
| 11 | TELE BOT | Setup Telegram bot |
| 12 | UPDATE MENU | Update script to latest version |
| 13 | RUNNING | Check service status |
| 14 | INFO PORT | Show all port information |
| 15 | MENU BOT | Telegram bot management |
| 16 | CHANGE DOMAIN | Change server domain |
| 17 | FIX CRT DOMAIN | Fix SSL certificate |
| 18 | CANGE BANNER | Customize banner (coming soon) |
| 19 | RESTART BANNER | Restart banner service |
| 20 | SPEEDTEST | Test server bandwidth |
| 21 | EKSTRAK MENU | Extract menu features |

---

## 📱 VMess Menu Features

When you select **[02] VMESS MENU**, you get:

```
┌─────────────────────────────────────────────────┐
│                   VMESS MENU                    │
└─────────────────────────────────────────────────┘
┌─────────────────────────────────────────────────┐
     [1] Create Vmess Account
     [2] Trial Vmess Account
     [3] Delete Account Vmess
     [4] Renew Account Vmess
     [5] Cek User Login Vmess
     [6] Cek User Vmess
     [7] Change Limit Bw User Vmess
     [8] Change Limit Ip User Vmess
     [0] Back To Menu
└─────────────────────────────────────────────────┘
```

### Feature Details:

1. **Create Account** - Full VMess account with custom settings
2. **Trial Account** - 1-day trial account (5GB quota, 1 IP limit)
3. **Delete Account** - Remove existing account
4. **Renew Account** - Extend expiry date
5. **Check Login** - See active connections
6. **List Users** - View all accounts with details
7. **Change Bandwidth** - Modify quota limit
8. **Change IP Limit** - Modify concurrent connection limit

**Same features available for VLESS, Trojan, and SSH menus!**

---

## 🎯 Creating VMess Account

### Step 1: Select Create Account

```bash
Options [ 1 - 21 ] ❱❱❱ 2  # Select VMess Menu
Select: 1  # Create VMess Account
```

### Step 2: Enter Account Details

```bash
User: johndoe
Expired (days): 30
Limit User (GB): 100
Limit User (IP): 2
```

### Step 3: Get Complete Information

```
◇━━━━━━━━━━━━━━━━━◇
CREATE VMESS ACCOUNT
◇━━━━━━━━━━━━━━━━━◇
User              : johndoe
Expired (days)    : 30
Limit User (GB)   : 100
Limit User (IP)   : 2
◇━━━━━━━━━━━━━━━━━◇
 Xray/Vmess Account
◇━━━━━━━━━━━━━━━━━◇
Remarks          : johndoe
Domain           : your.domain.com
User Quota       : 100 GB
User Ip          : 2 IP
Port TLS         : 443, 8443, 2087, 2096
Port none TLS    : 80, 8080, 8880, 2082
id               : 4d512d17-06c3-4c4c-8d36-47097566f1d7
alterId          : 0
Security         : auto
Network          : ws
Path             : /Multi-Path
Dynamic          : https://bugmu.com/path
ServiceName      : vmess-grpc
◇━━━━━━━━━━━━━━━━━◇
Link TLS         : vmess://eyAidiI6ICIyIiwgInBzIjogImFyaWZpbiIsICJhZGQiOiAi...
◇━━━━━━━━━━━━━━━━━◇
Link none TLS    : vmess://eyAidiI6ICIyIiwgInBzIjogImFyaWZpbiIsICJhZGQiOiAi...
◇━━━━━━━━━━━━━━━━━◇
Link GRPC        : vmess://eyAidiI6ICIyIiwgInBzIjogImFyaWZpbiIsICJhZGQiOiAi...
◇━━━━━━━━━━━━━━━━━◇
Format OpenClash : https://your.domain.com:81/vmess-johndoe.txt
◇━━━━━━━━━━━━━━━━━◇
Aktif Selama     : 30 Hari
Dibuat Pada      : 10 Feb, 2026
Berakhir Pada    : 12 Mar, 2026
```

---

## 🤖 Telegram Bot Setup

### Why Use Telegram Bot?

Get instant notifications for:
- ✅ New account created
- ❌ Account deleted
- 🔄 Account renewed
- ⏰ Auto-delete expired accounts
- 📊 Server status updates

### How to Setup

1. **Create Bot in Telegram**
   - Open Telegram
   - Search for `@BotFather`
   - Send `/newbot`
   - Follow instructions
   - Copy the Bot Token

2. **Get Your Chat ID**
   - Search for `@userinfobot`
   - Start the bot
   - Copy your Chat ID

3. **Configure in Script**
   ```bash
   Options [ 1 - 21 ] ❱❱❱ 11  # Select TELE BOT
   ```
   - Enter Bot Token
   - Enter Chat ID
   - Test message will be sent

### Notification Examples

```
✅ New VMess Account
User: johndoe
Expired: 12 Mar, 2026
Domain: your.domain.com
```

```
❌ Account Deleted
User: johndoe
Type: VMESS
```

```
🔄 VMess Renewed
User: johndoe
New expiry: 15 Apr, 2026
```

---

## 🔧 Advanced Configuration

### Change Domain

```bash
Options [ 1 - 21 ] ❱❱❱ 16
Current: old.domain.com
New domain: new.domain.com
```

**Important:** After changing domain, run **[17] FIX CRT DOMAIN** to get new SSL certificate.

### Fix SSL Certificate

```bash
Options [ 1 - 21 ] ❱❱❱ 17
```

This will:
- Stop services
- Obtain new Let's Encrypt certificate
- Configure Xray to use new certificate
- Restart services

### Restart All Services

```bash
Options [ 1 - 21 ] ❱❱❱ 10
```

Restarts:
- Xray
- Nginx
- SSH
- Dropbear
- HAProxy
- UDP Custom

### Check Service Status

```bash
Options [ 1 - 21 ] ❱❱❱ 13
```

Shows:
- ✓ xray - Running
- ✓ nginx - Running
- ✓ sshd - Running
- ✗ haproxy - Stopped

### Update Script

```bash
Options [ 1 - 21 ] ❱❱❱ 12
```

Checks GitHub for latest version and updates automatically.

---

## 📂 File Locations

### Account Files
```
/root/akun/
├── vmess-username.txt
├── vless-username.txt
├── trojan-username.txt
└── ssh-username.txt
```

### Configuration Files
```
/usr/local/etc/xray/config.json    # Xray configuration
/etc/xray/xray.crt                 # SSL certificate
/etc/xray/xray.key                 # SSL private key
/root/domain                       # Domain file
```

### Service Files
```
/usr/local/bin/udp-custom          # UDP Custom script
/etc/systemd/system/udp-custom.service
/etc/nginx/sites-available/default  # Nginx config
```

### Log Files
```
/var/log/xray/access.log           # Xray access log
/var/log/xray/error.log            # Xray error log
```

---

## 🐛 Troubleshooting

### Xray Not Running

```bash
# Check status
systemctl status xray

# View logs
journalctl -u xray -n 50

# Restart
systemctl restart xray
```

### SSL Certificate Failed

```bash
# Check domain DNS
dig +short your.domain.com

# Should return your server IP

# Fix certificate
Options [ 1 - 21 ] ❱❱❱ 17
```

### Port Already in Use

```bash
# Check what's using port 80
netstat -tulpn | grep :80

# Kill process
fuser -k 80/tcp

# Restart services
Options [ 1 - 21 ] ❱❱❱ 10
```

### Can't Connect to Account

1. Check if service is running: `systemctl status xray`
2. Check if ports are open: `netstat -tulpn | grep -E ':(80|443)'`
3. Check firewall rules: `ufw status` or `iptables -L`
4. Verify domain DNS points to correct IP
5. Test connection with `curl https://your.domain.com`

### Performance Issues

```bash
# Install monitoring tool
Options [ 1 - 21 ] ❱❱❱ 9  # GOTOP X RAM

# Run speedtest
Options [ 1 - 21 ] ❱❱❱ 20

# Check service status
Options [ 1 - 21 ] ❱❱❱ 13
```

---

## 🔒 Security Best Practices

1. **Use Strong Passwords** for SSH accounts
2. **Enable UFW Firewall**
   ```bash
   ufw allow 22/tcp
   ufw allow 80/tcp
   ufw allow 443/tcp
   ufw enable
   ```
3. **Regular Updates**
   ```bash
   apt update && apt upgrade -y
   ```
4. **Monitor Logs** regularly
5. **Limit Account Sharing** - Use IP limits
6. **Set Bandwidth Quotas** - Prevent abuse
7. **Regular Backups** - Use backup feature
8. **Change Default Ports** if needed

---

## 📊 Port Reference

### VMess Ports

| Port | Type | Protocol | TLS |
|------|------|----------|-----|
| 443 | WebSocket | VMess | ✅ |
| 8443 | WebSocket | VMess | ✅ |
| 2087 | WebSocket | VMess | ✅ |
| 2096 | WebSocket | VMess | ✅ |
| 80 | WebSocket | VMess | ❌ |
| 8080 | WebSocket | VMess | ❌ |
| 8880 | WebSocket | VMess | ❌ |
| 2082 | WebSocket | VMess | ❌ |
| 443 | gRPC | VMess | ✅ |

### VLESS Ports
| Port | Type | Protocol | TLS |
|------|------|----------|-----|
| 443 | WebSocket | VLESS | ✅ |

### Trojan Ports
| Port | Type | Protocol | TLS |
|------|------|----------|-----|
| 443 | TCP | Trojan | ✅ |

### SSH Ports
| Port | Service |
|------|---------|
| 22 | OpenSSH |
| 109 | Dropbear |
| 143 | Dropbear |

### Other Services
| Port | Service |
|------|---------|
| 81 | Nginx Web |
| 7300 | UDP Custom |
| 8000 | HAProxy |

---

## 🤝 Contributing

Contributions are welcome! Please:

1. Fork the repository
2. Create feature branch: `git checkout -b feature-name`
3. Commit changes: `git commit -am 'Add feature'`
4. Push to branch: `git push origin feature-name`
5. Submit Pull Request

---

## 📝 Changelog

### Version 1.0.0 (2026-02-10)
- ✅ Initial release
- ✅ VMess, VLESS, Trojan, SSH support
- ✅ Multi-port VMess
- ✅ Telegram bot integration
- ✅ Auto SSL certificate
- ✅ Beautiful UI
- ✅ Account management (8 features per protocol)
- ✅ OS compatibility: Ubuntu 20-24, Debian 9-11
- ✅ UDP Custom support
- ✅ Auto-update feature

---

## 📜 License

MIT License - See [LICENSE](LICENSE) file for details

---

## 👥 Credits

**Created by:** The Proffessor Squad

**Contributors:**
- YouzinCrabz - Lead Developer

**Special Thanks:**
- Xray-Core Team
- Certbot Team
- Community Contributors

---

## 📞 Support

- **Issues:** [GitHub Issues](https://github.com/putrinuroktavia234-max/tunnel/issues)
- **Telegram:** @ridhani16
- **Email:** hudaacuan@gmail.com

---

## ⚠️ Disclaimer

This script is provided "as is" without warranty of any kind. Use at your own risk. The authors are not responsible for any misuse or damage caused by this script.

**Educational Purpose Only** - Make sure you comply with your country's laws and regulations regarding VPN services.

---

## 🌟 Star History

[![Star History Chart](https://api.star-history.com/svg?repos=putrinuroktavia234-max/tunnel&type=Date)](https://star-history.com/#putrinuroktavia234-max/tunnel&Date)

---

## 📈 Statistics

![GitHub stars](https://img.shields.io/github/stars/putrinuroktavia234-max/tunnel?style=social)
![GitHub forks](https://img.shields.io/github/forks/putrinuroktavia234-max/tunnel?style=social)
![GitHub watchers](https://img.shields.io/github/watchers/putrinuroktavia234-max/tunnel?style=social)

---

**By The Proffessor Squad**
