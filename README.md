
# NGINX RTMP + HLS Streaming Server (Memory Optimized)

![Nginx Version](https://img.shields.io/badge/Nginx-1.24.0-brightgreen)
![License](https://img.shields.io/badge/License-MIT-blue)
![Platform](https://img.shields.io/badge/Platform-Ubuntu%2020.04%20%7C%2022.04-orange)
![Badge](https://hitscounter.dev/api/hit?url=https%3A%2F%2Fgithub.com%2Fsohag1192%2FNGINX-with-the-RTMP-module-and-configures-scripts&label=&icon=github&color=%23198754&message=&style=flat&tz=UTC)

A shell script to automate the installation of NGINX with the `nginx-rtmp-module`. This setup is specifically optimized for HLS streaming by using `/tmp/hls` (RAM storage) to reduce disk I/O and improve performance.

# NGINX with the RTMP Module and Configuration Scripts

An automated, single-command bash script to compile and configure a self-hosted live video streaming server using **NGINX** and the **nginx-rtmp-module**. 

This script is designed to ingest live RTMP video streams (from software like OBS Studio) and repackage them on the fly into **HLS (HTTP Live Streaming)** format so they can be played directly in web browsers.

## 🚀 Features

* **Automated Compilation:** Downloads and compiles NGINX (v1.24.0) and the RTMP module from source with all required dependencies.
* **RAM-Based HLS Storage:** Configures `/tmp/hls` (a `tmpfs` RAM disk) to store temporary video fragments, significantly reducing read/write wear on your SSD/HDD.
* **Systemd Service Included:** Automatically recreates the temporary HLS directory on reboot using a custom systemd service (`hls-temp.service`).
* **CORS Configured:** Cross-Origin Resource Sharing (CORS) is enabled by default so web players on different domains can access the stream without security blockages.

---

## 🛠️ Installation

Run the following commands on your Linux server (Ubuntu/Debian recommended) as a user with `sudo` privileges:

```bash
# 1. Clone the repository
git clone [https://github.com/sohag1192/NGINX-with-the-RTMP-module-and-configures-scripts.git](https://github.com/sohag1192/NGINX-with-the-RTMP-module-and-configures-scripts.git)

# 2. Enter the directory
cd NGINX-with-the-RTMP-module-and-configures-scripts

# 3. Make the script executable
chmod +x setup.sh

# 4. Run the installation script
sudo ./setup.sh

```

---

## ⚙️ Configuration Details

The installation script writes a custom `nginx.conf` file to `/usr/local/nginx/conf/nginx.conf`.

### Ports and Paths

| Service | Port | Endpoint / Path |
| --- | --- | --- |
| **RTMP Ingest** | `1935` | `rtmp://<your-server-ip>:1935/hls` |
| **HLS Playback** | `80` | `http://<your-server-ip>/hls/<stream-key>.m3u8` |
| **Fragment Storage** | N/A | `/tmp/hls` |

### RTMP Settings

* **Chunk Size:** 4096
* **HLS Fragment Length:** 3 seconds
* **HLS Playlist Length:** 60 seconds (keeps the last 20 fragments)

---

## 🎥 How to Stream (OBS Studio)

1. Open OBS Studio.
2. Go to **Settings > Stream**.
3. Select **Custom** from the Service dropdown.
4. Set the **Server** to: `rtmp://<your-server-ip>:1935/hls`
5. Set the **Stream Key** to any name you want (e.g., `mystream`).
6. Click **Start Streaming**.

### How to Watch

You can now play the stream in any HLS-compatible web player (like Video.js, hls.js, or VLC Media Player) using the following URL:
`http://<your-server-ip>/hls/mystream.m3u8`

---

## 🛑 Useful Commands

If you need to restart, stop, or check the status of your NGINX server, use the standard systemctl commands:

```bash
sudo systemctl status nginx
sudo systemctl restart nginx
sudo systemctl stop nginx

```
---

## 🙋 Contributing

- Issues and pull requests are welcome.  
- If you find bugs or want to suggest improvements, please open an issue or PR.  

📬 **Contact via Mail:** [sohag1192@gmail.com](mailto:sohag1192@gmail.com)

📬 **Contact via Telegram:** [Md_Sohag_Rana](https://t.me/Md_Sohag_Rana)

---

## 🌟 Support

If you enjoy this project, please ⭐ it on GitHub — your support motivates future updates!

