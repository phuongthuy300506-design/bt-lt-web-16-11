@echo off
title Chay Test JPA - HCMUTE
echo ========================================================
echo       CHAY TEST 2 YEU CAU JPA - HCMUTE
echo ========================================================
set "JAVA_HOME=C:\Program Files\Java\jdk-21"

cd /d "%~dp0"

echo.
echo ========================================================
echo [YEU CAU 1] CHAY TEST CAU HINH JPA (vn.iotstar.config.Test)
echo ========================================================
call "D:\apache-maven-3.9.9\bin\mvn.cmd" compile exec:java "-Dexec.mainClass=vn.iotstar.config.Test"

echo.
echo ========================================================
echo [YEU CAU 2] CHAY TEST TOAN DIEN CRUD (vn.iotstar.config.TestCrudCategory)
echo ========================================================
call "D:\apache-maven-3.9.9\bin\mvn.cmd" compile exec:java "-Dexec.mainClass=vn.iotstar.config.TestCrudCategory"

echo.
echo ========================================================
echo HOAN TAT KIEM THU!
echo ========================================================
pause

