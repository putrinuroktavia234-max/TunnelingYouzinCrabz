# 🚀 INSTALLATION GUIDE - TunnelingYouzinCrabz

## ⚡ Quick Install (One-Line Command)

```bash
wget -qO- https://raw.githubusercontent.com/putrinuroktavia234-max/TunnelingYouzinCrabz/main/install.sh | bash
```

**That's it!** Script akan otomatis:
- Install semua dependencies
- Setup Xray dengan semua protocol
- Configure SSL certificate
- Optimize system untuk stabilitas
- Reboot server

---

## 📖 Manual Installation

Jika prefer cara manual:

```bash
# 1. Download script
wget https://raw.githubusercontent.com/putrinuroktavia234-max/TunnelingYouzinCrabz/main/tunnel.sh

# 2. Make executable
chmod +x tunnel.sh

# 3. Run as root
sudo ./tunnel.sh
```

---

## 🔧 Fix Connection Stability (Jika VPN Sering Disconnect)

Jalankan script ini untuk fix ping loss dan connection drops:

```bash
# Download stability fix
wget https://raw.githubusercontent.com/putrinuroktavia234-max/TunnelingYouzinCrabz/main/fix-ping-loss.sh

# Make executable
chmod +x fix-ping-loss.sh

# Run
sudo ./fix-ping-loss.sh

# Restart services
systemctl restart xray nginx
```

**Result:** 
- ✅ Ping loss 0%
- ✅ No more random disconnects
- ✅ Stable connection 24/7

---

## 📋 System Requirements

- **OS**: Ubuntu 20.04-24.04 atau Debian 9-12
- **RAM**: Minimal 512MB (recommended 1GB)
- **Storage**: 10GB
- **Domain**: Wajib ada domain yang sudah di-point ke IP server
- **Root Access**: Wajib

---

## 🎯 Supported Protocols

### VMess
- Port TLS: 443, 8443, 2087, 2096
- Port Non-TLS: 80, 8080, 8880, 2082
- Port gRPC: 10443

### VLESS
- Port TLS: 443, 8443, 2087, 2096
- Port Non-TLS: 80, 8080, 2082
- Port gRPC: 10444

### Trojan
- Port TCP: 10445
- Port WS-TLS: 10446
- Port WS-NonTLS: 10447
- Port gRPC: 10448

### Others
- SSH: 22
- Dropbear: 109, 143
- NoobzVPN: 8080
- Shadowsocks: 8388
- UDP Custom: 7300

---

## 📱 After Installation

Setelah install selesai dan server reboot, login SSH kembali.

Menu akan muncul otomatis:

```
╭════════════════════════════════════════════════════════════╮
│      Welcome Mr.YouzinCrabz
╰════════════════════════════════════════════════════════════╯

[01] SSH MENU          [08] BCKP/RSTR       [15] MENU BOT
[02] VMESS MENU        [09] GOTOP X RAM     [16] CHANGE DOMAIN
[03] VLESS MENU        [10] RESTART ALL     [17] FIX CRT DOMAIN
[04] TROJAN MENU       [11] TELE BOT        [18] CANGE BANNER
[05] NOOBZVPN          [12] UPDATE MENU     [19] RESTART BANNER
[06] SHADOWSOCKS       [13] RUNNING         [20] SPEEDTEST
[07] INSTALL UDP       [14] INFO PORT       [21] EKSTRAK MENU
```

---

## ✅ Quick Test

Test apakah semua service running:

```bash
# Via menu
# Pilih [13] RUNNING

# Atau via command
systemctl status xray
systemctl status nginx
```

Check BBR enabled:
```bash
sysctl net.ipv4.tcp_congestion_control
# Output harus: net.ipv4.tcp_congestion_control = bbr
```

Test ping stability:
```bash
ping -c 100 8.8.8.8
# Packet loss harus 0% atau < 1%
```

---

## 🎯 Create Your First Account

### Example: VMess Account

```bash
# 1. Select menu [02] VMESS MENU
# 2. Select [1] Create Account
# 3. Enter details:

User: testuser
Expired (days): 30
Limit User (GB): 100
Limit User (IP): 2
```

Output akan keluar lengkap dengan:
- Link untuk semua port (TLS, Non-TLS, gRPC)
- OpenClash config URL
- QR Code
- Account details

**Same untuk semua protocol!** VLESS, Trojan, SSH, dll semua punya format output lengkap.

---

## 🔄 Update Script

Update ke versi terbaru:

```bash
# Via menu
# Pilih [12] UPDATE MENU

# Atau manual
wget https://raw.githubusercontent.com/putrinuroktavia234-max/TunnelingYouzinCrabz/main/tunnel.sh -O /root/tunnel.sh
chmod +x /root/tunnel.sh
```

---

## 🆘 Troubleshooting

### Xray Not Running
```bash
systemctl status xray
journalctl -u xray -n 50
systemctl restart xray
```

### SSL Certificate Error
```bash
# Menu → [17] FIX CRT DOMAIN
# Atau manual:
certbot certonly --standalone -d yourdomain.com --force-renew
systemctl restart xray nginx
```

### Connection Still Dropping
```bash
# Jalankan stability fix
wget https://raw.githubusercontent.com/putrinuroktavia234-max/TunnelingYouzinCrabz/main/fix-ping-loss.sh
chmod +x fix-ping-loss.sh
./fix-ping-loss.sh
```

### Port Already Used
```bash
netstat -tulpn | grep :443
fuser -k 443/tcp
systemctl restart xray
```

---

## 📚 Documentation

- **Full README**: [README.md](https://github.com/putrinuroktavia234-max/TunnelingYouzinCrabz/blob/main/README.md)
- **Stability Guide**: [VPN-STABILITY-GUIDE.md](https://github.com/putrinuroktavia234-max/TunnelingYouzinCrabz/blob/main/VPN-STABILITY-GUIDE.md)
- **Quick Reference**: [QUICK-REFERENCE.md](https://github.com/putrinuroktavia234-max/TunnelingYouzinCrabz/blob/main/QUICK-REFERENCE.md)
- **Changelog**: [CHANGELOG.md](https://github.com/putrinuroktavia234-max/TunnelingYouzinCrabz/blob/main/CHANGELOG.md)

---

## 📞 Support

- **GitHub Issues**: [Report Bug](https://github.com/putrinuroktavia234-max/TunnelingYouzinCrabz/issues)
- **GitHub Discussions**: [Ask Questions](https://github.com/putrinuroktavia234-max/TunnelingYouzinCrabz/discussions)

---

## ⭐ Show Your Support

Jika script ini membantu:
- ⭐ Star repository ini
- 🍴 Fork untuk development
- 📢 Share ke teman-teman

---

**Repository**: https://github.com/putrinuroktavia234-max/TunnelingYouzinCrabz

**Made with ❤️ by The Proffessor Squad**
