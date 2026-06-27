
## 📖 README Summary

### 🔹 Purpose
Provide sample configuration and scripts that:
- Accept RTMP input streams.
- Output HLS segments and playlists.
- Enable **statistics endpoints** to monitor active streams, viewers, and bandwidth.

### 🔹 Features
- RTMP ingest block (`rtmp { server { ... } }`) for publishing streams.
- HLS output (`hls on; hls_path /var/www/html/hls;`).
- RTMP statistics module enabled (`rtmp_stat /usr/local/nginx/html/stat;`).
- Example `stat.xsl` file to render XML stats into a human‑readable web page.
- Ability to track:
  - Active publishers
  - Active subscribers
  - Stream keys in use
  - Bandwidth usage

### 🔹 Requirements
- NGINX compiled with the RTMP module.
- A Linux server (Ubuntu/Debian recommended).
- FFmpeg or OBS to push RTMP streams.
- Optional: `stat.xsl` stylesheet for pretty statistics output.

### 🔹 Installation
1. Clone the repository:
   ```bash
   git clone https://github.com/sohag1192/NGINX-with-the-RTMP-module-and-configures-scripts.git
   ```
2. Navigate to the RTMP TO HLS STATISTICS folder:
   ```bash
   cd NGINX-with-the-RTMP-module-and-configures-scripts/RTMP\ TO\ HLS\ STATISTICS
   ```
3. Copy the sample config into `/etc/nginx/nginx.conf`.

### 🔹 Usage
- Start NGINX:
  ```bash
  sudo systemctl start nginx
  ```
- Push a stream:
  ```bash
  ffmpeg -re -i input.mp4 -c copy -f flv rtmp://your-server-ip/live/streamkey
  ```
- Play via HLS:
  ```
  http://your-server-ip/hls/streamkey.m3u8
  ```
- View statistics:
  ```
  http://your-server-ip/stat
  ```
  (with `stat.xsl` applied, you’ll see a formatted dashboard of active streams).

### ⚠️ Notes
- Adjust `hls_path` and `rtmp_stat` paths to match your server setup.
- Ensure firewall allows RTMP (1935) and HTTP (80/443).
- Statistics are updated in real time but only show streams handled by NGINX RTMP.

---
