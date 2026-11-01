@echo off
echo ===================================================
echo   Starting MinusCal Web Server (http://localhost:8080)
echo ===================================================
start http://localhost:8080
python -m http.server 8080 --directory build\web
pause
