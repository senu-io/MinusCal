@echo off
set PATH=%PATH%;D:\Other\Developer Tools\flutter\bin
echo ===================================================
echo   Building MinusCal Android APK (Release)
echo ===================================================
flutter build apk --release
echo.
echo If build succeeded, APK is located at:
echo build\app\outputs\flutter-apk\app-release.apk
pause
