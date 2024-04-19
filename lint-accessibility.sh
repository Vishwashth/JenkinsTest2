#!/bin/bash
# axe-linter-jenkins-sonarqube.sh
# This script will setup the environment variables needed for axe-linter-connector
# and execute axe-linter-connector. The output file will be reviewed and call back with exit codes:
## 0 - No Accessibility Defects
## 1 - axe DevTools Linter Detected Accessibility Defects
## 2 - Execution problem, or axe DevTools Linter unavailable.

echo "axe DevTools Linter Jenkins SonarQube Starting $(date)"

# Path to axe-linter-connector executable
AXE_CONNECTOR_PATH="bin/axe-linter-connector-win"

# Configure outfile: output in Generic Issue Import Format for SonarQube in execution directory.
OutFile="axe-linter-report.json"

# Remove previous results
rm -f "$OutFile"

# execute axe-linter-connector
"$AXE_CONNECTOR_PATH" -s ./src -d . --api-key b03fd0f0-d990-4bdf-8eeb-4bda0577fdfb --url https://axe-linter.deque.com/

echo "Checking for Results $(date)"

if [ ! -f "$OutFile" ]; then
    echo "$OutFile Does Not Exist"
    exit 2
elif grep -q "BUG" "$OutFile"; then
    echo "axe DevTools Linter Accessibility Defect Detected"
    exit 1
else
    echo "No axe DevTools Linter Bugs Detected"
fi
exit 0
