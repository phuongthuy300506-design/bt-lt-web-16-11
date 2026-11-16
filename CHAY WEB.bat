@echo off
title Khoi dong Tomcat 11 - HCMUTE Web Video & OTP Authentication
echo ========================================================
echo       KHOI DONG TOMCAT 11 - HCMUTE WEB VIDEO & OTP
echo ========================================================
set "JAVA_HOME=C:\Program Files\Java\jdk-21"
set "CATALINA_HOME=D:\lt web\apache-tomcat-11.0.27-windows-x64\apache-tomcat-11.0.27"

echo 1. Dang kiem tra va dung cac tien trinh cu tren cong 8080...
for /f "tokens=5" %%a in ('netstat -aon ^| findstr ":8080" ^| findstr "LISTENING"') do taskkill /f /pid %%a >nul 2>&1
timeout /t 1 /nobreak >nul

echo.
echo 2. Dang build du an Maven (JPA Hibernate 6.6)...
cd /d "%~dp0"
call "D:\apache-maven-3.9.9\bin\mvn.cmd" clean package -DskipTests

echo.
echo 3. Dang don dep va cap nhat file WAR vao Tomcat...
rmdir /s /q "%CATALINA_HOME%\webapps\ROOT" >nul 2>&1
rmdir /s /q "%CATALINA_HOME%\webapps\CRUD_JPA_Category" >nul 2>&1
rmdir /s /q "%CATALINA_HOME%\work\Catalina" >nul 2>&1
del /f /q "%CATALINA_HOME%\temp\*" >nul 2>&1

copy /y "%~dp0target\CRUD_JPA_Category.war" "%CATALINA_HOME%\webapps\ROOT.war" >nul
copy /y "%~dp0target\CRUD_JPA_Category.war" "%CATALINA_HOME%\webapps\CRUD_JPA_Category.war" >nul

echo.
echo 4. Dang khoi dong Apache Tomcat 11...
cd /d "%CATALINA_HOME%\bin"
call startup.bat

echo.
echo 5. Dang cho server san sang...
set /a count=0

:WAIT_LOOP
timeout /t 2 /nobreak >nul
set /a count+=2
curl.exe -s -o nul "http://localhost:8080/home"
if %errorlevel% equ 0 goto READY
if %count% geq 25 goto READY
echo    Dang khoi dong... (%count%s)
goto WAIT_LOOP

:READY
echo.
echo ========================================================
echo [THANH CONG] He thong da hoan tat va san sang!
echo URL Trang Chu:      http://localhost:8080/home
echo URL Video:          http://localhost:8080/video
echo URL Dang Nhap:      http://localhost:8080/login
echo URL Admin Videos:   http://localhost:8080/admin/videos
echo URL Admin Category: http://localhost:8080/admin/categories
echo ========================================================
start http://localhost:8080/home
pause
