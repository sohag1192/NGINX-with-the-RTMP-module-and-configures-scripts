
Installing nginx with RTMP module and PHP on ubuntu

Basic Install [1]

		sudo apt-get update
		sudo apt-get install build-essential libpcre3 libpcre3-dev libssl-dev unzip

		wget http://nginx.org/download/nginx-1.21.3.tar.gz
		wget https://github.com/arut/nginx-rtmp-module/archive/master.zip

		tar -zxvf nginx-1.21.3.tar.gz
		unzip master.zip
		cd nginx-21.3

		./configure \
			--add-module=../nginx-rtmp-module-master  \
			--with-http_ssl_module  \
		   

		make
		sudo make install

			sudo /usr/local/nginx/sbin/nginx

			sudo nano /usr/local/nginx/conf/nginx.conf
Config nginx
Add the following at the very end of the file:

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
Restart nginx with:


			sudo /usr/local/nginx/sbin/nginx -s stop
			sudo /usr/local/nginx/sbin/nginx
Test
Streaming Service: Custom

Server: rtmp:///live

Play Path/Stream Key: test


		service nginx status  # to poll for current status
		service nginx stop    # to stop any servers if any
		service nginx start   # to start the server

# NGINX-with-the-RTMP-module-and-configures-scripts
# NGINX-with-the-RTMP-module-and-configures-scripts
