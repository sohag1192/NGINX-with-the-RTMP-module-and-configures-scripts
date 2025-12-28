
# NGINX RTMP + HLS Streaming Server (Memory Optimized)

![Nginx Version](https://img.shields.io/badge/Nginx-1.24.0-brightgreen)
![License](https://img.shields.io/badge/License-MIT-blue)
![Platform](https://img.shields.io/badge/Platform-Ubuntu%2020.04%20%7C%2022.04-orange)

A shell script to automate the installation of NGINX with the `nginx-rtmp-module`. This setup is specifically optimized for HLS streaming by using `/tmp/hls` (RAM storage) to reduce disk I/O and improve performance.

## 📖 Description

This project provides an automated environment for live video streaming. It compiles NGINX from source to include the RTMP module, allowing you to:
1. **Ingest** live video via RTMP (e.g., from OBS Studio).
2. **Transmux** the live feed into HLS (HTTP Live Streaming) segments.
3. **Serve** the stream via HTTP (Port 80) using RAM-based temporary storage for low-latency and high durability of your SSD/HDD.

## 🚀 Features

* **Auto-Installation:** One-command setup for NGINX 1.24.0 and dependencies.
* **Memory Optimization:** HLS fragments are stored in `/tmp/hls` to prevent disk wear.
* **Systemd Integration:** Includes a service file that automatically manages the `/tmp/hls` folder on every boot.
* **CORS Enabled:** Cross-Origin Resource Sharing headers are pre-configured so web players (Video.js, hls.js) work out of the box.

## 🛠️ Installation

Clone the repository and run the setup script:

```bash
git clone [https://github.com/sohag1192/NGINX-with-the-RTMP-module-and-configures-scripts.git](https://github.com/sohag1192/NGINX-with-the-RTMP-module-and-configures-scripts.git)
cd NGINX-with-the-RTMP-module-and-configures-scripts
chmod +x setup.sh
sudo ./setup.sh

```

## ⚙️ NGINX Configuration Summary

The script configures `/usr/local/nginx/conf/nginx.conf` with the following key settings:

| Component | Port | Path / Detail |
| --- | --- | --- |
| **RTMP Ingest** | 1935 | `rtmp://your-ip:1935/hls` |
| **HLS Fragments** | - | `/tmp/hls` (Stored in RAM) |
| **HLS Playback** | 80 | `http://your-ip/hls/stream.m3u8` |
| **Segment Length** | - | 3 Seconds |

## 🎥 How to Use

### 1. Start Streaming (Encoder)

Open **OBS Studio** and go to Settings > Stream:

* **Service:** Custom
* **Server:** `rtmp://your-server-ip:1935/hls`
* **Stream Key:** `test` (This will be your filename)

### 2. Watch the Stream

Open **VLC Media Player** or a web player:

* **URL:** `http://your-server-ip/hls/test.m3u8`

## 📂 Project Structure

* `setup.sh` - The main installation script.
* `nginx.conf` - Optimized configuration for RTMP and HLS.
* `README.md` - Project documentation.

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](https://www.google.com/search?q=LICENSE) file for details.

## 👤 Author

Created by **[@Sohag1192](https://github.com/sohag1192)**



---

### Next Steps
1.  **Create the file:** In your local repository folder, run `nano README.md`.
2.  **Paste:** Paste the code above into the file.
3.  **Push to GitHub:**
    ```bash
    git add README.md
    git commit -m "Add professional README with HLS descriptions"
    git push origin main
    ```

Would you like me to help you create a simple **index.html** file with a video player so people can test the stream directly on your website?

https://github.com/sohag1192/Live-Tv-Server

---
## Based on your **Live-Tv-Server** repository and the NGINX configuration we built, here is a premium **index.html** demo.

This version is designed to work perfectly with your setup: it uses **HLS.js** (so it works in any browser), it's mobile-responsive, and it includes a modern "Live" UI similar to the iterations found in your GitHub projects.
---
### `index.html` - Premium Live Demo

```html
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Live TV Server | Dashboard</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <script src="https://cdn.jsdelivr.net/npm/hls.js@latest"></script>
    <style>
        body { background: #0f0f0f; color: #fff; font-family: 'Inter', sans-serif; }
        .player-container { max-width: 900px; margin: 50px auto; background: #1a1a1a; border-radius: 12px; overflow: hidden; box-shadow: 0 10px 30px rgba(0,0,0,0.5); }
        .video-wrapper { position: relative; width: 100%; padding-top: 56.25%; background: #000; }
        video { position: absolute; top: 0; left: 0; width: 100%; height: 100%; }
        .status-bar { padding: 15px 20px; display: flex; align-items: center; justify-content: space-between; border-top: 1px solid #333; }
        .live-indicator { background: #ff0000; color: white; padding: 2px 10px; border-radius: 4px; font-size: 12px; font-weight: bold; text-transform: uppercase; animation: blink 1.5s infinite; }
        @keyframes blink { 0% { opacity: 1; } 50% { opacity: 0.5; } 100% { opacity: 1; } }
        .server-info { font-size: 13px; color: #888; }
        .btn-github { background: #333; color: white; border: none; }
        .btn-github:hover { background: #444; color: #fff; }
    </style>
</head>
<body>

<div class="container">
    <div class="player-container">
        <div class="video-wrapper">
            <video id="video" controls autoplay muted></video>
        </div>

        <div class="status-bar">
            <div>
                <span class="live-indicator"><i class="fas fa-circle me-1"></i> Live</span>
                <span class="ms-3 fw-bold">Live Stream Demo</span>
            </div>
            <div class="server-info">
                <i class="fas fa-server me-1"></i> HLS via /tmp/hls
            </div>
        </div>

        <div class="p-4 text-center border-top border-secondary">
            <h5>Welcome to your Live TV Server</h5>
            <p class="text-secondary small">Stream to: <code>rtmp://YOUR_IP:1935/hls/test</code></p>
            <div class="d-flex justify-content-center gap-2">
                <a href="https://github.com/sohag1192/Live-Tv-Server" class="btn btn-github btn-sm">
                    <i class="fab fa-github me-1"></i> View on GitHub
                </a>
            </div>
        </div>
    </div>
</div>

<script>
    const video = document.getElementById('video');
    // Set your stream URL here
    const videoSrc = '/hls/test.m3u8'; 

    if (Hls.isSupported()) {
        const hls = new Hls();
        hls.loadSource(videoSrc);
        hls.attachMedia(video);
        hls.on(Hls.Events.MANIFEST_PARSED, function() {
            video.play();
        });
    }
    // For Safari (HLS native support)
    else if (video.canPlayType('application/vnd.apple.mpegurl')) {
        video.src = videoSrc;
        video.addEventListener('loadedmetadata', function() {
            video.play();
        });
    }
</script>

</body>
</html>

```

### 💡 Why this works for your repo:

1. **Lightweight:** It uses the **Hls.js CDN**, so you don't need to host heavy player files.
2. **Compatibility:** It detects if the user is on Safari (Native HLS) or Chrome/Firefox (Hls.js) and adjusts automatically.
3. **Low Latency:** Since your script uses `/tmp/hls`, this player will fetch segments instantly from RAM.
4. **Branding:** I included a link back to your **Live-Tv-Server** repo to help drive traffic and stars ⭐.

### How to apply:

Put this file in `/usr/local/nginx/html/index.html` on your server. When people visit your IP address, they will see the player immediately.
