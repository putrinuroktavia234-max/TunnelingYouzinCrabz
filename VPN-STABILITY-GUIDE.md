# 🔧 VPN STABILITY OPTIMIZATION GUIDE
## Mengatasi Masalah Disconnect / Tidak Stabil

### 📌 PENYEBAB UTAMA VPN DISCONNECT:

1. **TCP Keep-Alive tidak dikonfigurasi**
2. **BBR Congestion Control belum aktif**
3. **Buffer size terlalu kecil**
4. **Connection timeout terlalu pendek**
5. **MTU size tidak optimal**
6. **Firewall yang terlalu ketat**

---

## ✅ SOLUSI LENGKAP - COPY & PASTE

### 1. AKTIFKAN BBR CONGESTION CONTROL

```bash
cat >> /etc/sysctl.conf <<EOF
# BBR Congestion Control
net.core.default_qdisc=fq
net.ipv4.tcp_congestion_control=bbr

# TCP Keep-Alive Settings
net.ipv4.tcp_keepalive_time=600
net.ipv4.tcp_keepalive_intvl=60
net.ipv4.tcp_keepalive_probes=5

# TCP Optimization
net.ipv4.tcp_fin_timeout=30
net.ipv4.tcp_tw_reuse=1
net.ipv4.tcp_max_syn_backlog=8192
net.ipv4.tcp_max_tw_buckets=5000

# Buffer Sizes (penting untuk stabilitas!)
net.core.rmem_max=134217728
net.core.wmem_max=134217728
net.ipv4.tcp_rmem=4096 87380 67108864
net.ipv4.tcp_wmem=4096 65536 67108864
net.core.netdev_max_backlog=250000

# Connection Tracking
net.netfilter.nf_conntrack_max=1000000
net.netfilter.nf_conntrack_tcp_timeout_established=7200
EOF

# Apply changes
sysctl -p

# Load BBR module
modprobe tcp_bbr
echo "tcp_bbr" >> /etc/modules-load.d/modules.conf
```

### 2. INCREASE FILE DESCRIPTORS

```bash
cat >> /etc/security/limits.conf <<EOF
* soft nofile 65536
* hard nofile 65536
* soft nproc 65536
* hard nproc 65536
EOF
```

### 3. OPTIMASI XRAY CONFIG

Edit `/usr/local/etc/xray/config.json` dan tambahkan ke setiap inbound:

```json
"streamSettings": {
  "sockopt": {
    "tcpKeepAliveInterval": 30
  }
},
"sniffing": {
  "enabled": true,
  "destOverride": ["http", "tls"]
}
```

Dan tambahkan di root level config:

```json
"policy": {
  "levels": {
    "0": {
      "handshake": 4,
      "connIdle": 300,
      "uplinkOnly": 2,
      "downlinkOnly": 5,
      "bufferSize": 10240
    }
  }
}
```

### 4. RESTART SERVICES

```bash
systemctl restart xray
systemctl restart nginx
systemctl restart haproxy
```

---

## 🎯 QUICK FIX SCRIPT (JALANKAN INI DULU!)

Buat file `fix-vpn-stability.sh`:

```bash
#!/bin/bash

echo "🔧 Fixing VPN Stability..."

# 1. BBR
echo "Enabling BBR..."
echo "net.core.default_qdisc=fq" >> /etc/sysctl.conf
echo "net.ipv4.tcp_congestion_control=bbr" >> /etc/sysctl.conf
sysctl -p

modprobe tcp_bbr
echo "tcp_bbr" >> /etc/modules-load.d/modules.conf

# 2. TCP Tuning
cat >> /etc/sysctl.conf <<EOF
net.ipv4.tcp_keepalive_time=600
net.ipv4.tcp_keepalive_intvl=60
net.ipv4.tcp_keepalive_probes=5
net.ipv4.tcp_fin_timeout=30
net.ipv4.tcp_tw_reuse=1
net.core.rmem_max=134217728
net.core.wmem_max=134217728
net.ipv4.tcp_rmem=4096 87380 67108864
net.ipv4.tcp_wmem=4096 65536 67108864
net.netfilter.nf_conntrack_max=1000000
EOF

sysctl -p

# 3. File Limits
cat >> /etc/security/limits.conf <<EOF
* soft nofile 65536
* hard nofile 65536
EOF

# 4. Restart Services
systemctl restart xray
systemctl restart nginx

echo "✅ VPN Stability Optimizations Applied!"
echo "Please test your connection now."
```

Jalankan:
```bash
chmod +x fix-vpn-stability.sh
./fix-vpn-stability.sh
```

---

## 🧪 TESTING SETELAH OPTIMASI

### 1. Cek BBR Aktif:
```bash
sysctl net.ipv4.tcp_congestion_control
# Output harus: net.ipv4.tcp_congestion_control = bbr
```

### 2. Cek Xray Running:
```bash
systemctl status xray
```

### 3. Test Connection dari Client:
- Connect ke VPN
- Buka YouTube/Streaming selama 30 menit
- Jangan disconnect = SUKSES!

---

## 🔍 TROUBLESHOOTING

### Masih Disconnect?

#### Check 1: MTU Size
```bash
# Di client V2RayN/NekoBox, set MTU = 1280
# Atau di server:
ip link set dev eth0 mtu 1280
```

#### Check 2: Firewall
```bash
# Pastikan port tidak diblock
ufw allow 443/tcp
ufw allow 80/tcp
ufw allow 8080/tcp
ufw allow 8443/tcp
```

#### Check 3: DNS
```bash
# Di client, gunakan DNS:
# 1.1.1.1 atau 8.8.8.8
```

#### Check 4: Xray Logs
```bash
tail -f /var/log/xray/error.log
# Lihat ada error apa
```

---

## 📊 MONITORING CONNECTION

### Monitor Active Connections:
```bash
netstat -an | grep :443 | wc -l
```

### Monitor Xray Performance:
```bash
journalctl -u xray -f
```

### Check Memory Usage:
```bash
free -h
```

---

## ⚡ OPTIMASI TAMBAHAN (OPSIONAL)

### 1. Disable Transparent Huge Pages
```bash
echo never > /sys/kernel/mm/transparent_hugepage/enabled
```

### 2. Set TCP Fast Open
```bash
echo "net.ipv4.tcp_fastopen=3" >> /etc/sysctl.conf
sysctl -p
```

### 3. Adjust Swappiness
```bash
echo "vm.swappiness=10" >> /etc/sysctl.conf
sysctl -p
```

---

## 🎯 HASIL YANG DIHARAPKAN

Setelah optimasi:
✅ Koneksi tidak disconnect tiba-tiba
✅ Streaming lancar tanpa buffering
✅ Download speed stabil
✅ Ping lebih rendah
✅ Bisa connect 24/7 tanpa masalah

---

## 📝 CATATAN PENTING

1. **BBR** adalah yang paling penting - pastikan aktif!
2. **Keep-Alive** mencegah connection timeout
3. **Buffer Size** besar = smooth untuk streaming
4. **Connection Tracking** tinggi = banyak user simultaneous

---

## 🆘 MASIH BERMASALAH?

### Cek Provider:
Beberapa provider ISP melimit/block VPN. Solusi:
- Gunakan port non-standard (2087, 2096, dst)
- Gunakan CDN (Cloudflare)
- Ubah ke gRPC protocol

### Cek Server Resource:
```bash
htop
# Jika CPU > 80% atau RAM habis, upgrade VPS
```

---

## 🔄 AUTO-RESTART SCRIPT (JIKA PERLU)

Buat cronjob untuk auto-restart jika xray mati:

```bash
crontab -e
```

Tambahkan:
```
*/5 * * * * systemctl is-active --quiet xray || systemctl restart xray
```

---

## ✅ CHECKLIST AKHIR

- [ ] BBR aktif (`sysctl net.ipv4.tcp_congestion_control`)
- [ ] TCP keep-alive dikonfigurasi
- [ ] Buffer size ditingkatkan
- [ ] File descriptors ditingkatkan
- [ ] Xray config sudah optimal
- [ ] Semua service running
- [ ] Firewall allow ports
- [ ] Test connection 30 menit stabil

---

**JIKA SUDAH SEMUA DICOBA TAPI MASIH DISCONNECT:**

Kemungkinan masalah di:
1. ISP user (bukan server)
2. Routing network bermasalah
3. VPS provider limit bandwidth

Solusi terakhir: ganti VPS provider atau gunakan CDN.

---

Made with ❤️ by The Proffessor Squad
