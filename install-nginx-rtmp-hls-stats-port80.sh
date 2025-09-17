#!/bin/bash

# Author: Md. Sohag Rana
# Description: RTMP + HLS + Stats Monitoring on port 80 using NGINX on Ubuntu 22.04

set -e

echo "🔧 Updating system..."
sudo apt update && sudo apt upgrade -y

echo "📦 Installing build tools and dependencies..."
sudo apt install build-essential libpcre3 libpcre3-dev libssl-dev zlib1g zlib1g-dev git wget ffmpeg -y

echo "📥 Downloading NGINX source..."
wget http://nginx.org/download/nginx-1.24.0.tar.gz
tar -zxvf nginx-1.24.0.tar.gz
cd nginx-1.24.0

echo "📁 Cloning nginx-rtmp-module..."
git clone https://github.com/arut/nginx-rtmp-module.git ../nginx-rtmp-module

echo "⚙️ Configuring and compiling NGINX with RTMP..."
./configure --with-http_ssl_module --add-module=../nginx-rtmp-module
make && sudo make install

echo "📁 Creating HLS and stats directories..."
sudo mkdir -p /usr/local/nginx/html/hls
sudo mkdir -p /usr/local/nginx/html/stat
sudo chmod -R 755 /usr/local/nginx/html

echo "📄 Copying stat.xsl stylesheet..."
sudo cp ../nginx-rtmp-module/stat.xsl /usr/local/nginx/html/stat/stat.xsl

echo "📝 Writing nginx.conf with RTMP + HLS + Stats on port 80..."
sudo tee /usr/local/nginx/conf/nginx.conf > /dev/null <<EOF
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
            hls_path /usr/local/nginx/html/hls;
            hls_fragment 3;
            hls_playlist_length 60;
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

        location /hls {
            types {
                application/vnd.apple.mpegurl m3u8;
                video/mp2t ts;
            }
            root /usr/local/nginx/html;
            add_header Cache-Control no-cache;
        }

        location /stat {
            rtmp_stat all;
            rtmp_stat_stylesheet stat.xsl;
        }

        location /stat.xsl {
            root /usr/local/nginx/html/stat;
        }
    }
}
EOF

echo "🚀 Enabling NGINX auto-start..."
wget https://raw.github.com/JasonGiedymin/nginx-init-ubuntu/master/nginx -O /etc/init.d/nginx
chmod +x /etc/init.d/nginx
sudo update-rc.d nginx defaults

echo "▶️ Starting NGINX service..."
sudo service nginx start

echo "✅ Setup complete!"
echo "🎥 RTMP Push URL: rtmp://your-server-ip:1935/hls/stream"
echo "🌐 HLS Playlist: http://your-server-ip/hls/stream.m3u8"
echo "📊 RTMP Stats Page: http://your-server-ip/stat"
