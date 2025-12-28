@echo off
REM ============================================
REM  sohag1192/NGINX-with-the-RTMP-module-and-configures-scripts NGINX RTMP + HLS Upload Script
REM ============================================

cd /d "C:\Users\sohag\Downloads\NGINX-with-the-RTMP-module-and-configures-scripts-main"

REM Initialize repo if not already
IF NOT EXIST ".git" (
    echo Initializing new Git repository...
    git init
    git remote add origin https://github.com/sohag1192/NGINX-with-the-RTMP-module-and-configures-scripts.git
    git branch -M main
)

REM Pull latest changes from GitHub before committing
echo Pulling latest changes from remote...
git pull origin main --rebase

REM Stage all changes
git add .

REM Commit with timestamp message
set CURRDATE=%date% %time%
git commit -m "Auto commit on %CURRDATE% with RTMP + HLS updates"

REM Push to GitHub main branch
git push origin main

echo.
echo ============================================
echo   Upload Completed Successfully to GitHub
echo ============================================
pause