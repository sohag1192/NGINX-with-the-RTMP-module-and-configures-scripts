#!/bin/bash

# RTMP Streaming Server Setup Script for Ubuntu 22.04
# Author: Md. Sohag Rana (adapted from HowtoForge)

set -e

echo "🔧 Updating system..."
sudo apt update && sudo apt upgrade -y

echo "🌐 Installing Nginx and RTMP module..."
sudo apt install nginx libnginx-mod-rtmp ffmpeg python3-pip -y

echo "📁 Configuring Nginx for RTMP..."
sudo tee -a /etc/nginx/nginx.conf > /dev/null <<EOF

rtmp {
    server {
        listen 1935;
        chunk_size 4096;

        application live {
            live on;
            record off;
        }
    }
}
EOF

echo "🔍 Testing Nginx config..."
sudo nginx -t

echo "🔄 Restarting Nginx..."
sudo systemctl restart nginx

echo "📦 Installing youtube-dl..."
pip3 install youtube-dl

echo "📊 Setting up RTMP stats page..."
sudo mkdir -p /var/www/html/rtmp
sudo cp /usr/share/doc/libnginx-mod-rtmp/examples/stat.xsl /var/www/html/rtmp/stat.xsl

echo "📝 Configuring Nginx stats virtual host..."
sudo tee /etc/nginx/sites-available/default > /dev/null <<EOF
server {
    listen 8080;
    server_name _;

    location /stat {
        rtmp_stat all;
        rtmp_stat_stylesheet stat.xsl;
    }

    location /stat.xsl {
        root /var/www/html/rtmp;
    }

    location /control {
        rtmp_control all;
    }
}
EOF

echo "🔄 Restarting Nginx again..."
sudo systemctl restart nginx

echo "✅ Setup complete!"
echo "🎥 To stream: ffmpeg -re -i input.mp4 -c:v copy -c:a aac -f flv rtmp://<your-ip>/live/stream"
echo "📺 To view stats: http://<your-ip>:8080/stat"
