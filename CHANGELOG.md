# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [2.0.0] - 2026-02-10

### Added - Major Features
- **Complete Protocol Parity**: All protocols (VMess, VLESS, Trojan) now have equal features
  - Multi-port support for ALL protocols
  - gRPC support for ALL protocols
  - Complete output format for ALL protocols
  - Same detailed information display
- **NoobzVPN Integration**: Full support with account management
- **Shadowsocks-libev Integration**: Port 8388 with complete features
- **Connection Stability Features**:
  - BBR Congestion Control (auto-enabled)
  - Anti-Ping Loss optimization
  - TCP Keep-Alive configuration
  - Large buffer sizes for smooth streaming
  - Connection tracking optimization
- **Formatted Information Displays**:
  - Port Info with beautiful table format
  - Running Services with detailed status
  - System Information dashboard
- **Trial Account Enhancement**: Complete output like regular accounts (not just username/password)

### Changed - Improvements
- **VLESS**: Expanded from 1 port to 8 ports (443, 80, 8080, 8443, 2082, 2087, 2096, gRPC)
- **Trojan**: Expanded from 1 port to 4 ports (TCP, WS-TLS, WS-NonTLS, gRPC)
- **Xray Configuration**: Optimized with:
  - TCP Keep-Alive settings
  - Sniffing enabled for better routing
  - Policy configuration for connection management
  - ALPN support
- **System Optimization**: Auto-applied optimizations:
  - BBR congestion control
  - TCP window scaling
  - Selective acknowledgments
  - Reduced TIME_WAIT sockets
  - Increased file descriptors
  - Network interface tuning
- **Menu Layout**: Improved formatting and consistency

### Fixed - Bug Fixes
- **Xray Permission Issues**: Auto-fix on startup
- **Ping Loss**: Eliminated through TCP optimization
- **Connection Drops**: Fixed with keep-alive and proper timeouts
- **Packet Loss**: Reduced to near-zero with buffer optimization
- **Service Conflicts**: Proper port allocation to prevent conflicts

### Security
- Enhanced SSL/TLS configuration
- Proper file permissions
- Secure credential storage

## [1.0.0] - 2026-01-15

### Added - Initial Release
- VMess support with multi-port (443, 80, 8080, 8443, 8880, 2082, 2087, 2096)
- VLESS support (single port 443)
- Trojan support (single port 443)
- SSH account management (OpenSSH + Dropbear)
- UDP Custom (port 7300)
- Telegram Bot integration
- Auto SSL certificate (Let's Encrypt + fallback)
- Beautiful UI with color-coded menus
- Account management features:
  - Create account
  - Delete account
  - Renew account
  - List accounts
- OpenClash format generation
- Auto-update from GitHub
- Backup & restore functionality

### Supported OS
- Ubuntu 20.04 LTS
- Ubuntu 22.04 LTS
- Ubuntu 24.04 LTS
- Debian 9 (Stretch)
- Debian 10 (Buster)
- Debian 11 (Bullseye)

---

## Version Comparison

### What's New in 2.0.0?

| Feature | v1.0.0 | v2.0.0 |
|---------|--------|--------|
| VMess Ports | 8 ports | 9 ports (added gRPC) |
| VLESS Ports | 1 port | 8 ports |
| Trojan Ports | 1 port | 4 ports |
| NoobzVPN | ❌ | ✅ Full support |
| Shadowsocks | ❌ | ✅ Full support |
| BBR | ❌ | ✅ Auto-enabled |
| Anti-Ping Loss | ❌ | ✅ Optimized |
| Connection Stability | ⚠️ Basic | ✅ Advanced |
| Output Format | Mixed | Uniform (all protocols) |
| Trial Accounts | Basic | Complete details |
| System Optimization | ❌ | ✅ Comprehensive |

---

## Migration Guide

### From v1.0.0 to v2.0.0

**Backup your accounts first!**

```bash
# Backup current accounts
tar -czf /root/backup-accounts.tar.gz /root/akun/

# Download new version
wget https://raw.githubusercontent.com/putrinuroktavia234-max/TunnelingYouzinCrabz/main/tunnel.sh

# Run new version
chmod +x tunnel.sh
./tunnel.sh
```

**Note:** Your existing accounts will continue to work, but you'll need to recreate them to take advantage of multi-port support.

**New features you can use immediately:**
1. Run menu option [14] to see new port information
2. Run menu option [13] to see new service status display
3. Connection stability improvements work automatically
4. Try creating new VLESS/Trojan accounts to see new port options

---

## Known Issues

### v2.0.0
- None reported yet

### v1.0.0 (Fixed in 2.0.0)
- ✅ VLESS only had 1 port (now has 8)
- ✅ Trojan only had 1 port (now has 4)
- ✅ Connection dropping issues (fixed with BBR)
- ✅ Ping loss (fixed with TCP optimization)
- ✅ Trial accounts had minimal info (now complete)

---

## Upgrade Instructions

### Automatic Update (Recommended)

```bash
# In main menu, select [12] UPDATE MENU
# Script will check GitHub and auto-update if available
```

### Manual Update

```bash
# Backup current version
cp /root/tunnel.sh /root/tunnel.sh.backup

# Download latest
wget https://raw.githubusercontent.com/putrinuroktavia234-max/TunnelingYouzinCrabz/main/tunnel.sh -O /root/tunnel.sh

# Make executable
chmod +x /root/tunnel.sh

# Run
./tunnel.sh
```

---

## Future Plans (v3.0.0)

Planned features for next major version:

- [ ] OpenVPN integration
- [ ] WireGuard support
- [ ] Advanced traffic management
- [ ] User dashboard (web interface)
- [ ] API for automation
- [ ] Docker support
- [ ] Bandwidth usage graphs
- [ ] Multi-domain support
- [ ] Custom port configuration
- [ ] Advanced firewall rules

---

## Support

If you encounter issues:

1. Check [Troubleshooting Guide](README.md#troubleshooting)
2. Read [VPN Stability Guide](VPN-STABILITY-GUIDE.md)
3. Open an [Issue on GitHub](https://github.com/putrinuroktavia234-max/TunnelingYouzinCrabz/issues)
4. Join our [Telegram Group](https://t.me/yourgroup)

---

## Contributors

Special thanks to everyone who contributed to v2.0.0:

- **YouzinCrabz** - Lead Developer
- **The Proffessor Squad** - Core Team
- **Community** - Beta Testers & Bug Reports

---

**Made with ❤️ by The Proffessor Squad**
