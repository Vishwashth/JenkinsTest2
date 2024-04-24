#!/bin/bash
# axe DevTools Linter pre-commit
# This script will setup the environment variables needed for axe-linter-connector
# and execute axe-linter-connector. The output file will be reviewed and call back with exit codes:
## 0 - No Accessibility Defects
## 1 - axe DevTools Linter Detected Accessibility Defects
## 2 - Execution problem, or axe DevTools Linter unavailable.
 
echo "axe DevTools Linter Starting $(date)"
 
# Setup variables for axe DevTools Linter
export AXE_LINTER_SERVER_URL=https://axe-linter.deque.com/
export AXE_LINTER_API_KEY="b03fd0f0-d990-4bdf-8eeb-4bda0577fdfb"
AXE_CONNECTOR_PATH="bin/axe-linter-connector-win"

StatusCode=0

if [[ -z "${AXE_LINTER_API_KEY}" ]]; then
   echo "AXE_LINTER_API_KEY must be set"
   sleep 4
   exit 2
fi
# Configure verbose output.
VerboseOutput="false"
# Configure outfile: output in Generic Issue Import Format for in execution directory.
OutFile="axe-linter-report.json"
for i in $(git status --porcelain | sed s/^...//); do
   rm -f $OutFile
   TempCode=0
   shopt -s nocasematch;
   if [[ $i == *.html ]] || [[ $i == *.js ]] || [[ $i == *.jsx ]]|| [[ $i == *.ts ]]|| [[ $i == *.tsx ]]|| [[ $i == *.vue ]]|| [[ $i == *.htm ]]|| [[ $i == *.md ]]|| [[ $i == *.markdown ]];
   then
      if $VerboseOutput; then
         echo "Accessibility check: file: $i"
      fi
      # execute axe DevTools Linter Connector
      "$AXE_CONNECTOR_PATH" -s $i -d . --api-key $AXE_LINTER_API_KEY --url $AXE_LINTER_SERVER_URL

      if [ ! -f "$OutFile" ];then
         echo "$OutFile Does Not Exist"
         sleep 4
         exit 2
      elif cat "$OutFile" | grep -q "BUG"; then
         if $VerboseOutput; then
            cat $OutFile
         fi
         echo "**axe DevTools Linter Accessibility Issues Detected: $i"
         TempCode=1
      else
         echo "No axe DevTools Linter Connector Issues Detected in: $i"
      fi
      if [ "$TempCode" != "0" ]; then
         StatusCode=1
      fi
      rm $OutFile
   fi
done
 
if [ "$StatusCode" != "0" ]; then
   echo "Commit Failed due to Accessibility Issues"
fi
sleep 4
exit $StatusCode