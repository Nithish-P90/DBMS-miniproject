@echo off
echo ========================================
echo   GIT REPOSITORY SETUP
echo ========================================
echo.

REM Change to project directory
cd /d "%~dp0"

echo [1/7] Initializing Git repository...
git init
if %errorlevel% neq 0 (
    echo ERROR: Git initialization failed! Make sure Git is installed.
    pause
    exit /b 1
)
echo Git repository initialized!
echo.

echo [2/7] Adding all files to staging...
git add .
echo Files staged successfully!
echo.

echo [3/7] Commit 1: Initial project structure and documentation...
git commit -m "Initial commit: Project structure and documentation" -m "- Added README.md with setup instructions" -m "- Added ER_Diagram.md with entity-relationship documentation" -m "- Added User_Requirement_Spec.md with requirements" -m "- Added Deliverables_Checklist.md for project tracking"
echo.

echo [4/7] Commit 2: Database schema and SQL scripts...
git add sql/*
git commit -m "Add database schema and SQL scripts" -m "- schema.sql: 5 normalized tables with 4 triggers" -m "- seed_data.sql: Sample data for 6 restaurants, 64 menu items" -m "- procedures_functions.sql: 4 procedures, 4 functions, 4 complex queries" -m "- All foreign keys and constraints implemented"
echo.

echo [5/7] Commit 3: Backend Flask API...
git add backend/*
git commit -m "Add Flask backend REST API" -m "- app.py: 10 REST endpoints for full CRUD operations" -m "- init_db.py: Database initialization script" -m "- requirements.txt: Python dependencies (Flask, Flask-CORS)" -m "- Implements all triggers and database operations"
echo.

echo [6/7] Commit 4: Frontend React application...
git add frontend/*
git commit -m "Add React frontend application" -m "- App.js: 3-page SPA (Login, Home, My Orders)" -m "- index.css: Purple gradient theme with animations" -m "- package.json: Node.js dependencies" -m "- Full integration with backend API"
echo.

echo [7/7] Commit 5: Demo files and automation...
git add REVIEW_2_DEMO.html REVIEW_4_DEMO.html START_PROJECT.bat PROJECT_FEATURES.md PROJECT_SUMMARY.md
git commit -m "Add demo pages and automation scripts" -m "- REVIEW_2_DEMO.html: Database design demonstration" -m "- REVIEW_4_DEMO.html: Live functionality demonstration" -m "- START_PROJECT.bat: Auto-launch all services" -m "- PROJECT_FEATURES.md: Complete feature documentation" -m "- PROJECT_SUMMARY.md: Project overview"
echo.

echo ========================================
echo   GIT SETUP COMPLETE!
echo ========================================
echo.
echo Repository initialized with 5 organized commits:
echo 1. Documentation
echo 2. Database schema
echo 3. Backend API
echo 4. Frontend app
echo 5. Demo files
echo.
echo To view commit history: git log --oneline
echo To create remote repository:
echo   1. Create repo on GitHub
echo   2. git remote add origin YOUR_REPO_URL
echo   3. git push -u origin master
echo.
pause
