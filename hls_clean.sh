#!/bin/bash

# --- Configuration ---
LOG_DIR="/usr/local/nginx/logs"
HLS_DIR="/tmp/hls"

echo "-------------------------------------------"
echo "Starting Nginx Maintenance: $(date)"
echo "-------------------------------------------"

# 1. Clear Nginx Logs
# Using truncate sets file size to 0 without deleting the file or changing permissions
echo "[1/2] Clearing Nginx log files..."
for logfile in "$LOG_DIR/access.log" "$LOG_DIR/error.log" "$LOG_DIR/rtmp_error.log"; do
    if [ -f "$logfile" ]; then
        sudo truncate -s 0 "$logfile"
        echo "Cleared: $logfile"
    else
        echo "Skip: $logfile not found"
    fi
done

# 2. Clean HLS Path
# This removes all files and subfolders inside /tmp/hls but keeps the main directory
echo "[2/2] Cleaning HLS directory: $HLS_DIR"
if [ -d "$HLS_DIR" ]; then
    # -mindepth 1 ensures the /tmp/hls folder itself is NOT deleted
    sudo find "$HLS_DIR" -mindepth 1 -delete
    echo "HLS folder emptied successfully."
else
    echo "Skip: $HLS_DIR does not exist."
fi

echo "-------------------------------------------"
echo "Maintenance Complete!"
echo "-------------------------------------------"
