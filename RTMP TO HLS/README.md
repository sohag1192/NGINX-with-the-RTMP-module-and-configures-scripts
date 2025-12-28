
### 1. The NGINX Configuration Block

Add this inside the `rtmp { server { ... } }` section of your configuration.

```nginx
rtmp {
    server {
        listen 1935;
        chunk_size 4096;

        # The 'hls' application block
        application hls {
            live on;
            hls on;
            hls_path /tmp/hls;         # Location of .m3u8 and .ts files
            hls_fragment 3;            # 3-second segments for lower latency
            hls_playlist_length 60;    # Keeps 60 seconds of video in the list
            hls_cleanup on;            # Deletes old segments automatically
            
            # Use this to name your segments
            hls_fragment_naming simple;
        }
    }
}

```

### 2. The URLs (Input and Output)

To generate the `.m3u8` file, follow these steps:

#### **Step A: Send the stream (RTMP)**

In your streaming software (like OBS), use these settings:

* **Server URL:** `rtmp://your-server-ip:1935/hls`
* **Stream Key:** `mystream`

#### **Step B: Access the output (.m3u8)**

Once you click "Start Streaming" in OBS, NGINX will create a file named `mystream.m3u8` inside `/tmp/hls/`. You can access it via your web browser or VLC at:

> **URL:** `http://your-server-ip/hls/mystream.m3u8`

---

### 3. Verify the Output

If you want to check if the files are being generated correctly via the command line, run:

```bash
ls -lh /tmp/hls/

```

**You should see:**

* `mystream.m3u8` (The index file)
* `mystream0.ts`, `mystream1.ts`, etc. (The actual video chunks)

### 🚀 Troubleshooting Tip

If the `.m3u8` doesn't load in a web player, ensure your **HTTP block** has the correct headers:

```nginx
location /hls {
    alias /tmp/hls;
    add_header Cache-Control no-cache;
    add_header 'Access-Control-Allow-Origin' '*' always; # Crucial for .m3u8 playback
}

```

Would you like me to help you configure **FFmpeg** to automatically push a video file to this RTMP link?