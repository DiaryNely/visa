@echo off
REM Script de démarrage pour l'application Vue.js

echo.
echo ====================================
echo Demarrage de l'application Vue.js
echo ====================================
echo.

REM Vérifie si node_modules existe
if not exist node_modules (
    echo Installation des dependances...
    call npm install
    if %ERRORLEVEL% neq 0 (
        echo Erreur lors de l'installation des dependances
        exit /b 1
    )
)

echo.
echo Demarrage du serveur de developpement...
echo L'application s'ouvrira automatiquement sur http://localhost:3000
echo.
echo Appuyez sur Ctrl+C pour arreter le serveur
echo.

call npm run dev
