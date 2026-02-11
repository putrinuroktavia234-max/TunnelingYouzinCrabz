# ✅ PORT CONFIGURATION - CORRECT VERSION

## 🎯 **KONSEP UTAMA:**

Semua protocol Xray **SHARE port 443 dan 80**, dibedakan berdasarkan **PATH**, bukan port terpisah!

---

## 📊 **PORT YANG BENAR:**

### **Port 443 (TLS/HTTPS):**
- VMess WebSocket → Path: `/vmess`
- VMess gRPC → ServiceName: `vmess-grpc`
- VLESS WebSocket → Path: `/vless`
- VLESS gRPC → ServiceName: `vless-grpc`
- Trojan WebSocket → Path: `/trojan`
- Trojan gRPC → ServiceName: `trojan-grpc`
- Shadowsocks WebSocket → Path: `/shadowsocks`

### **Port 80 (Non-TLS/HTTP):**
- VMess WebSocket → Path: `/vmess`
- VLESS WebSocket → Path: `/vless`

---

## 🔧 **ARSITEKTUR:**

```
Client → HAProxy (Port 443/80) → Xray (Internal Ports)
```

**HAProxy Configuration:**
```
Port 443 (TLS) → Route by path → Xray internal ports
Port 80 (Non-TLS) → Route by path → Xray internal ports
```

**Xray Internal Ports:**
```
10001 → VMess WS TLS
10002 → VMess gRPC
10003 → VLESS WS TLS
10004 → VLESS gRPC
10005 → Trojan WS
10006 → Trojan gRPC
10007 → Shadowsocks WS
10011 → VMess WS Non-TLS
10012 → VLESS WS Non-TLS
```

---

## 📋 **INFO PORT YANG BENAR (Untuk Menu [14]):**

```
┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┓
┃          » INFORMATION PORT SERVICE «           ┃
┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┛
┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┓
┃  » Open SSH                   : 443, 80, 22     ┃
┃  » Dropbear                   : 443, 109, 143   ┃
┃  » Dropbear Websocket         : 443, 109        ┃
┃  » SSH Websocket SSL          : 443             ┃
┃  » SSH Websocket              : 80              ┃
┃  » SSH UDP                    : 1-65535         ┃
┃  » OpenVPN SSL                : 443             ┃
┃  » OpenVPN Websocket SSL      : 443             ┃
┃  » OpenVPN TCP                : 443, 1194       ┃
┃  » OpenVPN UDP                : 2200            ┃
┃  » Nginx Webserver            : 443, 80, 81     ┃
┃  » Haproxy Loadbalancer       : 443, 80         ┃
┃  » DNS Server                 : 443, 53         ┃
┃  » DNS Client                 : 443, 88         ┃
┃  » XRAY DNS (SLOWDNS)         : 443, 53         ┃
┃  » XRAY Vmess TLS             : 443             ┃
┃  » XRAY Vmess gRPC            : 443             ┃
┃  » XRAY Vmess None TLS        : 80              ┃
┃  » XRAY Vless TLS             : 443             ┃
┃  » XRAY Vless gRPC            : 443             ┃
┃  » XRAY Vless None TLS        : 80              ┃
┃  » Trojan gRPC                : 443             ┃
┃  » Trojan WS                  : 443             ┃
┃  » Shadowsocks WS             : 443             ┃
┃  » Shadowsocks Server         : 8388            ┃
┃  » NoobzVPN                   : 8080            ┃
┃  » BadVPN 1                   : 7100            ┃
┃  » BadVPN 2                   : 7200            ┃
┃  » BadVPN 3                   : 7300            ┃
┃                                                 ┃
┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┛
```

---

## 🎯 **CONTOH LINK YANG BENAR:**

### **VMess TLS (Port 443):**
```
vmess://base64({
  "v": "2",
  "ps": "username",
  "add": "domain.com",
  "port": "443",          ← Port 443
  "id": "uuid",
  "aid": "0",
  "net": "ws",
  "path": "/vmess",       ← Path /vmess
  "type": "none",
  "host": "domain.com",
  "tls": "tls"
})
```

### **VMess gRPC (Port 443):**
```
vmess://base64({
  "v": "2",
  "ps": "username-grpc",
  "add": "domain.com",
  "port": "443",          ← Port 443 juga!
  "id": "uuid",
  "aid": "0",
  "net": "grpc",
  "path": "vmess-grpc",   ← ServiceName
  "type": "none",
  "host": "domain.com",
  "tls": "tls"
})
```

### **VMess Non-TLS (Port 80):**
```
vmess://base64({
  "v": "2",
  "ps": "username-nontls",
  "add": "domain.com",
  "port": "80",           ← Port 80
  "id": "uuid",
  "aid": "0",
  "net": "ws",
  "path": "/vmess",       ← Path sama
  "type": "none",
  "host": "domain.com",
  "tls": "none"
})
```

### **VLESS TLS (Port 443):**
```
vless://uuid@domain.com:443?path=/vless&security=tls&encryption=none&type=ws&host=domain.com#username
```

### **VLESS gRPC (Port 443):**
```
vless://uuid@domain.com:443?security=tls&encryption=none&type=grpc&serviceName=vless-grpc&host=domain.com#username-grpc
```

### **Trojan WS (Port 443):**
```
trojan://password@domain.com:443?path=/trojan&security=tls&type=ws&host=domain.com#username
```

### **Trojan gRPC (Port 443):**
```
trojan://password@domain.com:443?security=tls&type=grpc&serviceName=trojan-grpc&host=domain.com#username-grpc
```

---

## ✅ **OUTPUT CREATE ACCOUNT YANG BENAR:**

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
Domain           : domain.com
User Quota       : 100 GB
User Ip          : 2 IP
Port TLS         : 443             ← HANYA 443
Port none TLS    : 80              ← HANYA 80
Port gRPC        : 443             ← gRPC juga 443
id               : uuid-here
alterId          : 0
Security         : auto
Network          : ws / grpc
Path WS          : /vmess
ServiceName gRPC : vmess-grpc
◇━━━━━━━━━━━━━━━━━◇
Link TLS (WS)    : vmess://base64...
◇━━━━━━━━━━━━━━━━━◇
Link none TLS    : vmess://base64...
◇━━━━━━━━━━━━━━━━━◇
Link gRPC        : vmess://base64...
◇━━━━━━━━━━━━━━━━━◇
Format OpenClash : https://domain.com:81/vmess-johndoe.txt
◇━━━━━━━━━━━━━━━━━◇
Aktif Selama     : 30 Hari
Dibuat Pada      : 10 Feb, 2026
Berakhir Pada    : 12 Mar, 2026
```

---

## 🔑 **PERBEDAAN:**

### **❌ SALAH (Yang lama):**
```
VMess TLS: 443, 8443, 2087, 2096      ← SALAH! Terlalu banyak port
VMess Non-TLS: 80, 8080, 8880, 2082   ← SALAH!
VLESS TLS: 443, 8443, 2087, 2096      ← SALAH!
Trojan TCP: 10445                     ← SALAH! Port terpisah
Trojan WS: 10446                      ← SALAH!
```

### **✅ BENAR (Yang baru):**
```
VMess TLS: 443                        ← BENAR! Satu port saja
VMess Non-TLS: 80                     ← BENAR!
VMess gRPC: 443                       ← BENAR! Sama dengan WS
VLESS TLS: 443                        ← BENAR!
VLESS Non-TLS: 80                     ← BENAR!
VLESS gRPC: 443                       ← BENAR!
Trojan WS: 443                        ← BENAR! Share port
Trojan gRPC: 443                      ← BENAR!
```

---

## 🎯 **KENAPA PAKAI PATH BUKAN PORT?**

1. **Port 443 terbatas** - Tidak bisa banyak service dengar port sama
2. **HAProxy routing** - HAProxy bisa route based on HTTP path
3. **CDN friendly** - Cloudflare bisa proxy semua di port 443
4. **Cleaner** - Semua protocol di satu port, mudah manage firewall

---

## 📝 **SUMMARY:**

**Public Ports (Yang user pakai):**
- Port 443 → Semua protocol TLS (dibedakan by path)
- Port 80 → Semua protocol Non-TLS (dibedakan by path)

**Internal Ports (Backend Xray):**
- 10001-10012 → Internal routing, user tidak perlu tahu

**User hanya perlu tahu:**
- TLS = Port 443
- Non-TLS = Port 80
- gRPC = Port 443 (sama dengan TLS)

Sederhana dan jelas! ✅
