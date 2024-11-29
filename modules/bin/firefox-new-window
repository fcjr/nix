#!/usr/bin/env bash

pid=$(ps aux | grep '[F]irefox Developer Edition.app' | awk '/firefox$/ {print $2}')
if [ -z "$pid" ]; then
  open -n -a "Firefox Developer Edition"
else
  /Applications/Firefox\ Developer\ Edition.app/Contents/MacOS/firefox -new-window
fi
