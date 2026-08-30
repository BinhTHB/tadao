@echo off
setlocal enabledelayedexpansion
title ENI-PERSONA and ENI-PERSON AUTO INSTALLER FOR ANTIGRAVITY
color 0b

echo =======================================================================
echo          ENI-PERSONA and ENI-PERSON AUTO INSTALLER FOR ANTIGRAVITY
echo =======================================================================
echo.

:: 1. Kiem tra Python
set "PY_CMD="
python --version >nul 2>&1
if %errorlevel% equ 0 (
    set "PY_CMD=python"
    goto :PYTHON_FOUND
)

py -3 --version >nul 2>&1
if %errorlevel% equ 0 (
    set "PY_CMD=py -3"
    goto :PYTHON_FOUND
)

python3 --version >nul 2>&1
if %errorlevel% equ 0 (
    set "PY_CMD=python3"
    goto :PYTHON_FOUND
)

:: Kiem tra trong LocalAppData neu chua add vao PATH
for /d %%i in ("%LOCALAPPDATA%\Programs\Python\Python*") do (
    if exist "%%i\python.exe" (
        set "PY_CMD=%%i\python.exe"
        goto :PYTHON_FOUND
    )
)

:: Kiem tra trong Program Files
for /d %%i in ("%PROGRAMFILES%\Python*") do (
    if exist "%%i\python.exe" (
        set "PY_CMD=%%i\python.exe"
        goto :PYTHON_FOUND
    )
)

:PYTHON_NOT_FOUND
echo [ERROR] Python chua duoc cai dat tren may hoac chua duoc them vao PATH!
echo.
echo Dang thu cai dat Python tu dong qua winget (neu he dieu hanh ho tro)...
winget install Python.Python.3.12 --silent --accept-source-agreements --accept-package-agreements >nul 2>&1
if %errorlevel% equ 0 (
    echo [OK] Da cai dat Python thanh cong! Vui long khoi dong lai file .bat nay.
    pause
    exit /b 0
)

echo Vui long truy cap https://www.python.org/downloads/ de tai va cai dat Python 3.
echo (Nho tick chon "Add Python to PATH" khi cai dat nhe).
echo.
pause
exit /b 1

:PYTHON_FOUND
echo [*] Tim thay Python: %PY_CMD%
echo.

:: 2. Tu dong kiem tra va cai dat thu vien bo tro (colorama)
echo [*] Dang kiem tra va tu dong cai dat thu vien can thiet...
%PY_CMD% -m pip install --quiet --disable-pip-version-check colorama >nul 2>&1

:: 3. Chay script Python chinh
echo [*] Dang chay script cai dat skill vao Antigravity va Antigravity IDE...
echo.
%PY_CMD% "%~dp0install_eni_persona.py"
set "EXIT_CODE=%errorlevel%"

echo.
if %EXIT_CODE% equ 0 (
    echo =======================================================================
    echo [SUCCESS] Hoan tat! Ban co the mo Antigravity va go /eni-persona hoac /eni-person
    echo =======================================================================
) else (
    echo [WARNING] Script ket thuc voi ma loi: %EXIT_CODE%
)

echo.
pause
