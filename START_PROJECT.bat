@echo off
echo ========================================
echo   FOOD DELIVERY APP - AUTO LAUNCHER
echo ========================================
echo.

REM Change to project directory
cd /d "%~dp0"

echo [1/5] Initializing Database...
cd backend
python init_db.py
if %errorlevel% neq 0 (
    echo ERROR: Database initialization failed!
    pause
    exit /b 1
)
echo Database initialized successfully!
echo.

echo [2/5] Starting Flask Backend Server...
start "Flask Backend" cmd /k "cd /d %~dp0backend && python app.py"
echo Backend server starting on http://localhost:5000
echo.

echo [3/5] Installing Frontend Dependencies (if needed)...
cd ..\frontend
if not exist "node_modules\" (
    echo Installing npm packages...
    call npm install
) else (
    echo Dependencies already installed!
)
echo.

echo [4/5] Starting React Frontend...
start "React Frontend" cmd /k "cd /d %~dp0frontend && npm start"
echo Frontend will open at http://localhost:3001
echo.

echo [5/5] Opening Demo Pages...
timeout /t 5 /nobreak >nul
start "" "REVIEW_2_DEMO.html"
timeout /t 2 /nobreak >nul
start "" "REVIEW_4_DEMO.html"
echo.

echo ========================================
echo   ALL SERVICES STARTED SUCCESSFULLY!
echo ========================================
echo.
echo Backend API: http://localhost:5000
echo Frontend App: http://localhost:3001
echo Review 2 Demo: Opened in browser
echo Review 4 Demo: Opened in browser
echo.
echo Press any key to open the main app in browser...
pause >nul
start http://localhost:3001
echo.
echo To stop all services, close the terminal windows.
echo.
pause
