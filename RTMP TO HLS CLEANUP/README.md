

## 📖 README Summary

### 🔹 Purpose
When NGINX RTMP generates HLS output, it creates many `.ts` segment files and `.m3u8` playlists. Over time these accumulate and consume disk space.  
The `hls_clean.sh` script is designed to:
- Periodically delete expired `.ts` segments.
- Remove old `.m3u8` playlists.
- Keep only the most recent files needed for active streams.

### 🔹 Features
- Simple bash script for cleanup.
- Can be scheduled with **cron** or **systemd timer**.
- Configurable path (e.g., `/var/www/html/hls`).
- Safe removal of only HLS files, leaving other web content intact.

### 🔹 Requirements
- Linux server with NGINX RTMP module.
- HLS output directory (default `/var/www/html/hls`).
- Root or appropriate permissions to delete files.

### 🔹 Installation
1. Clone the repo:
   ```bash
   git clone https://github.com/sohag1192/NGINX-with-the-RTMP-module-and-configures-scripts.git
   ```
2. Navigate to the cleanup folder:
   ```bash
   cd NGINX-with-the-RTMP-module-and-configures-scripts/RTMP\ TO\ HLS\ CLEANUP
   ```
3. Make the script executable:
   ```bash
   chmod +x hls_clean.sh
   ```

### 🔹 Usage
Run manually:
```bash
./hls_clean.sh
```

Or schedule with cron (every hour):
```bash
0 * * * * /path/to/hls_clean.sh
```

### ⚠️ Notes
- Adjust the script’s `HLS_DIR` variable to match your actual HLS output path.
- Be careful: it will delete `.ts` and `.m3u8` files in that directory.
- Recommended to run periodically to avoid disk space issues.

---
