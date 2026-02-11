#!/bin/bash

#================================================
# ANTI-PING LOSS OPTIMIZATION
# Fix untuk hilang-hilang ping
#================================================

echo "🔧 Applying Anti-Ping Loss Optimization..."

# 1. QoS & Traffic Shaping
cat >> /etc/sysctl.conf <<EOF

#================================================
# ANTI-PING LOSS CONFIGURATION
#================================================

# TCP Window Scaling
net.ipv4.tcp_window_scaling=1

# Selective Acknowledgments
net.ipv4.tcp_sack=1

# TCP Timestamps
net.ipv4.tcp_timestamps=1

# Disable TCP Slow Start After Idle
net.ipv4.tcp_slow_start_after_idle=0

# Increase ARP cache
net.ipv4.neigh.default.gc_thresh1=1024
net.ipv4.neigh.default.gc_thresh2=2048
net.ipv4.neigh.default.gc_thresh3=4096

# Reduce packet loss
net.core.netdev_budget=50000
net.core.netdev_budget_usecs=5000

# TCP Fast Open
net.ipv4.tcp_fastopen=3

# Reduce TIME_WAIT sockets
net.ipv4.tcp_tw_reuse=1
net.ipv4.tcp_tw_recycle=0

# TCP Retries
net.ipv4.tcp_retries1=3
net.ipv4.tcp_retries2=5
net.ipv4.tcp_orphan_retries=1

# TCP SYN Retries
net.ipv4.tcp_syn_retries=3
net.ipv4.tcp_synack_retries=3

# Disable ICMP Redirect
net.ipv4.conf.all.accept_redirects=0
net.ipv4.conf.default.accept_redirects=0
net.ipv4.conf.all.secure_redirects=0

# Enable Path MTU Discovery
net.ipv4.ip_no_pmtu_disc=0

# Increase local port range
net.ipv4.ip_local_port_range=1024 65535

# TCP Memory
net.ipv4.tcp_mem=786432 1048576 26777216
net.ipv4.tcp_max_orphans=65536

# UDP Buffer
net.ipv4.udp_rmem_min=8192
net.ipv4.udp_wmem_min=8192

# Network Queue Length
net.core.somaxconn=65535
net.core.netdev_max_backlog=65536

# Explicit Congestion Notification
net.ipv4.tcp_ecn=0

EOF

# Apply all settings
sysctl -p

# 2. Configure Network Interface
IFACE=$(ip route | grep default | awk '{print $5}' | head -n1)

if [[ -n "$IFACE" ]]; then
    echo "Configuring interface: $IFACE"
    
    # Disable offloading (can cause packet loss)
    ethtool -K $IFACE gso off 2>/dev/null
    ethtool -K $IFACE tso off 2>/dev/null
    ethtool -K $IFACE gro off 2>/dev/null
    
    # Increase TX queue length
    ip link set dev $IFACE txqueuelen 10000
    
    # Set MTU
    ip link set dev $IFACE mtu 1500
fi

# 3. Create anti-ping-loss service
cat > /etc/systemd/system/anti-ping-loss.service <<SERVICE
[Unit]
Description=Anti-Ping Loss Optimization
After=network.target

[Service]
Type=oneshot
RemainAfterExit=yes
ExecStart=/bin/bash -c 'IFACE=\$(ip route | grep default | awk "{print \\\$5}" | head -n1); ip link set dev \$IFACE txqueuelen 10000; ip link set dev \$IFACE mtu 1500'

[Install]
WantedBy=multi-user.target
SERVICE

systemctl daemon-reload
systemctl enable anti-ping-loss
systemctl start anti-ping-loss

# 4. Configure Xray for better stability
if [[ -f /usr/local/etc/xray/config.json ]]; then
    echo "Optimizing Xray config..."
    
    # Backup
    cp /usr/local/etc/xray/config.json /usr/local/etc/xray/config.json.bak
    
    # Add mux configuration (reduces packet loss)
    # This will be done manually in the main script
fi

# 5. Install and configure WonderShaper (optional traffic shaping)
apt-get install -y wondershaper >/dev/null 2>&1

echo ""
echo "✅ Anti-Ping Loss Optimization Completed!"
echo ""
echo "📊 Testing ping stability:"
ping -c 10 8.8.8.8

echo ""
echo "🔄 Please restart services:"
echo "   systemctl restart xray"
echo "   systemctl restart nginx"
echo ""
echo "💡 Tips:"
echo "   - Set MTU=1400 di client (V2RayN/NekoBox)"
echo "   - Enable Mux di client settings"
echo "   - Gunakan DNS 1.1.1.1 atau 8.8.8.8"
