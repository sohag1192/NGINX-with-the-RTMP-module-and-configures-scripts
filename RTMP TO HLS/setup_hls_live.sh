#!/bin/bash
# Script by @Sohag1192
# Description: Installs NGINX + RTMP on Ubuntu 20.04 with HLS on port 8080

# Log everything to file
exec > >(tee -i /var/log/nginx-rtmp-setup.log)
exec 2>&1

echo "🔧 Updating system..."
sleep 1
sudo apt update && sudo apt upgrade -y

echo "📦 Installing required packages..."
sleep 1
sudo apt install build-essential libpcre3 libpcre3-dev libssl-dev zlib1g zlib1g-dev git wget -y

echo "📥 Downloading NGINX source..."
wget http://nginx.org/download/nginx-1.24.0.tar.gz
tar -zxvf nginx-1.24.0.tar.gz
cd nginx-1.24.0

echo "📁 Cloning nginx-rtmp-module..."
git clone https://github.com/arut/nginx-rtmp-module.git ../nginx-rtmp-module

echo "⚙️ Compiling NGINX with RTMP module..."
./configure --with-http_ssl_module --add-module=../nginx-rtmp-module
make && sudo make install

echo "📂 Creating HLS output directories..."
sudo mkdir -p /usr/local/nginx/html/live
sudo mkdir -p /usr/local/nginx/html/hls
sudo chmod -R 755 /usr/local/nginx/html

echo "📝 Writing nginx.conf with RTMP (live + hls) and HTTP config..."
cat <<EOF | sudo tee /usr/local/nginx/conf/nginx.conf
worker_processes  1;

events {
    worker_connections  1024;
}

rtmp {
    server {
        listen 1935;
        chunk_size 4096;

        application live {
            live on;
            hls on;
            hls_path /usr/local/nginx/html/live;
            hls_fragment 3;
            hls_playlist_length 60;
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
    include       mime.types;
    default_type  application/octet-stream;
    sendfile        on;
    keepalive_timeout  65;

    server {
        listen 80;
        server_name localhost;

        location / {
            root html;
            index index.html index.htm;
        }

        location /live {
            types {
                application/vnd.apple.mpegurl m3u8;
                video/mp2t ts;
            }
            root /usr/local/nginx/html;
            add_header Cache-Control no-cache;
        }

        location /hls {
            types {
                application/vnd.apple.mpegurl m3u8;
                video/mp2t ts;
            }
            root /usr/local/nginx/html;
            add_header Cache-Control no-cache;
        }
    }
}
EOF

echo "🚀 Installing init script for NGINX auto-start..."
wget https://raw.github.com/JasonGiedymin/nginx-init-ubuntu/master/nginx -O /etc/init.d/nginx
chmod +x /etc/init.d/nginx
sudo update-rc.d nginx defaults

echo "▶️ Starting NGINX..."
sudo service nginx start

echo "✅ Setup Complete!"
echo "🎬 RTMP Push URLs:"
echo "  - rtmp://your-server-ip:1935/live/stream"
echo "  - rtmp://your-server-ip:1935/hls/stream"
echo "🌐 HLS Playback URLs:"
echo "  - http://your-server-ip/live/stream.m3u8"
echo "  - http://your-server-ip/hls/stream.m3u8"