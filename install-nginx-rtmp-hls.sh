#!/bin/bash
# Script modified for /tmp/hls path
# Description: Installs NGINX + RTMP on Ubuntu with HLS on /tmp/hls

set -e # Exit on error

echo "🔧 Updating system..."
sudo apt update && sudo apt upgrade -y

echo "📦 Installing dependencies..."
sudo apt install build-essential libpcre3 libpcre3-dev libssl-dev zlib1g zlib1g-dev git wget -y

echo "📥 Downloading NGINX source..."
NGINX_VERSION="1.24.0"
wget http://nginx.org/download/nginx-$NGINX_VERSION.tar.gz
tar -zxvf nginx-$NGINX_VERSION.tar.gz
cd nginx-$NGINX_VERSION

echo "📁 Cloning nginx-rtmp-module..."
git clone https://github.com/arut/nginx-rtmp-module.git ../nginx-rtmp-module

echo "⚙️ Configuring and compiling NGINX..."
./configure --with-http_ssl_module --add-module=../nginx-rtmp-module
make && sudo make install

echo "📁 Creating HLS directory in /tmp..."
# We create it now, but note that /tmp clears on reboot
sudo mkdir -p /tmp/hls
sudo chmod -R 777 /tmp/hls

echo "📝 Writing nginx.conf..."
cat <<EOF | sudo tee /usr/local/nginx/conf/nginx.conf
worker_processes 1;

events {
    worker_connections 1024;
}

rtmp {
    server {
        listen 1935;
        chunk_size 4096;

        application live {
            live on;
            record off;
        }

        application hls {
            live on;
            hls on;
            hls_path /tmp/hls;
            hls_fragment 3;
            hls_playlist_length 60;
            
            # This prevents old fragments from clogging up /tmp
            hls_cleanup on; 
        }
    }
}

http {
    include mime.types;
    default_type application/octet-stream;
    sendfile on;
    keepalive_timeout 65;

    server {
        listen 80;
        server_name localhost;

        location / {
            root html;
            index index.html index.htm;
        }

        # HLS delivery point
        location /hls {
            types {
                application/vnd.apple.mpegurl m3u8;
                video/mp2t ts;
            }
            alias /tmp/hls;
            add_header Cache-Control no-cache;
            add_header 'Access-Control-Allow-Origin' '*'; # Allow web players to play the stream
        }
    }
}
EOF

echo "🚀 Setting up NGINX Service..."
# Create a modern systemd service instead of the old init.d script
cat <<EOF | sudo tee /etc/systemd/system/nginx.service
[Unit]
Description=The NGINX HTTP and reverse proxy server
After=syslog.target network-online.target remote-fs.target nss-lookup.target
Wants=network-online.target

[Service]
Type=forking
PIDFile=/usr/local/nginx/logs/nginx.pid
ExecStartPre=/usr/bin/mkdir -p /tmp/hls
ExecStartPre=/usr/bin/chmod 777 /tmp/hls
ExecStartPre=/usr/local/nginx/sbin/nginx -t
ExecStart=/usr/local/nginx/sbin/nginx
ExecReload=/usr/local/nginx/sbin/nginx -s reload
ExecStop=/bin/kill -s QUIT \$MAINPID
PrivateTmp=false

[Install]
WantedBy=multi-user.target
EOF

sudo systemctl daemon-reload
sudo systemctl enable nginx
sudo systemctl start nginx

echo "✅ Setup complete!"
echo "🔗 RTMP URL: rtmp://your-server-ip:1935/hls/stream_name"
echo "🌐 HLS Playlist: http://your-server-ip/hls/stream_name.m3u8"
