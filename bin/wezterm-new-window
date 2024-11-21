#!/usr/bin/env bash

pid=$(ps aux | grep '[W]ezTerm.app' | awk '{print $2}')
if [ -z "$pid" ]; then
  open -a WezTerm.app
else
  wezterm cli spawn --new-window
fi
```
