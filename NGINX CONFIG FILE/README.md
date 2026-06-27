
---

## 📖 README Summary

### 🔹 Project Purpose
Provide ready‑to‑use **NGINX configuration files** for live streaming setups using the RTMP module. This allows you to host and distribute live video streams (e.g., IPTV, YouTube relay, OBS output) through your own server.

### 🔹 Features
- Pre‑configured **RTMP block** for ingesting live streams.
- Support for **HLS (HTTP Live Streaming)** output.
- Example **DASH streaming** configuration.
- Logging and access control examples.
- Scripts to automate starting/stopping NGINX with RTMP.

### 🔹 Requirements
- **NGINX** compiled with the **RTMP module**.
- Linux server (Ubuntu/Debian recommended).
- FFmpeg (optional) for transcoding streams.

### 🔹 Installation
1. Clone the repository:
   ```bash
   git clone https://github.com/sohag1192/NGINX-with-the-RTMP-module-and-configures-scripts.git
   ```
2. Navigate to the config folder:
   ```bash
   cd NGINX-with-the-RTMP-module-and-configures-scripts/NGINX\ CONFIG\ FILE
   ```
3. Copy the sample config to your NGINX directory:
   ```bash
   cp nginx.conf /etc/nginx/nginx.conf
   ```

### 🔹 Usage
- Start NGINX:
  ```bash
  sudo systemctl start nginx
  ```
- Push a stream from OBS or FFmpeg:
  ```
  rtmp://your-server-ip/live/streamkey
  ```
- Play via HLS:
  ```
  http://your-server-ip/hls/streamkey.m3u8
  ```

### ⚠️ Notes
- Adjust paths (`/var/www/html/hls`) to match your server setup.
- Make sure firewall allows RTMP (default port 1935) and HTTP (80/443).
- For production, secure with SSL and proper user authentication.

---
