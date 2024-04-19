@echo off
rem axe-linter-jenkins-sonarqube.bat
rem This script will setup the environment variables needed for axe-linter-connector
rem and execute axe-linter-connector. The output file will be reviewed and call back with exit codes:
rem 0 - No Accessibility Defects
rem 1 - axe DevTools Linter Detected Accessibility Defects
rem 2 - Execution problem, or axe DevTools Linter unavailable.

echo axe DevTools Linter Jenkins SonarQube Starting %date%

rem Path to axe-linter-connector executable
set AXE_CONNECTOR_PATH="bin\axe-linter-connector-win.exe"

rem Configure outfile: output in Generic Issue Import Format for SonarQube in execution directory.
set OutFile=axe-linter-report.json

rem Remove previous results
del /q "%OutFile%"

rem execute axe-linter-connector
%AXE_CONNECTOR_PATH% -s .\src -d . --api-key b03fd0f0-d990-4bdf-8eeb-4bda0577fdfb --url https://axe-linter.deque.com/

echo Checking for Results %date%

if not exist "%OutFile%" (
    echo %OutFile% Does Not Exist
    exit /b 2
) else (
    findstr /C:"BUG" "%OutFile%" > nul
    if %errorlevel% equ 0 (
        echo axe DevTools Linter Accessibility Defect Detected
        exit /b 1
    ) else (
        echo No axe DevTools Linter Bugs Detected
        exit /b 0
    )
)
