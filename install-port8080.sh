#!/bin/sh

exec > /var/log/nginx-rtmp-setup.log 2>&1

echo "🔧 Updating system..."
sleep 1
sudo apt update && sudo apt upgrade -y

echo "📦 Installing dependencies..."
sleep 1
sudo apt install build-essential libpcre3 libpcre3-dev libssl-dev zlib1g zlib1g-dev git wget -y

echo "📥 Downloading NGINX source..."
sleep 1
wget http://nginx.org/download/nginx-1.24.0.tar.gz
tar -zxvf nginx-1.24.0.tar.gz
cd nginx-1.24.0

echo "📁 Cloning nginx-rtmp-module..."
sleep 1
git clone https://github.com/arut/nginx-rtmp-module.git ../nginx-rtmp-module

echo "🛠️ Configuring and compiling NGINX..."
sleep 1
./configure --with-http_ssl_module --add-module=../nginx-rtmp-module
make && sudo make install

echo "⚙️ Setting up nginx.conf with RTMP block..."
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
            record off;
        }
    }
}

http {
    include       mime.types;
    default_type  application/octet-stream;

    sendfile        on;
    keepalive_timeout  65;

    server {
        listen       8080;
        server_name  localhost;

        location / {
            root   html;
            index  index.html index.htm;
        }
    }
}
EOF

echo "🚀 Enabling auto-start using init script..."
sleep 1
wget https://raw.github.com/JasonGiedymin/nginx-init-ubuntu/master/nginx -O /etc/init.d/nginx
chmod +x /etc/init.d/nginx
update-rc.d nginx defaults

echo "▶️ Starting nginx..."
sleep 1
service nginx start
echo "✅ NGINX started successfully"
