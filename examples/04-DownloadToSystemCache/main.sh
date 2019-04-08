#!/usr/bin/env bash.origin

eval BO_SELF_BASH_SOURCE="$BO_READ_SELF_BASH_SOURCE"
BO_deriveSelfDir ___TMP___ "$BO_SELF_BASH_SOURCE"
local __BO_DIR__="$___TMP___"


BO_ALLOW_DOWNLOADS=1
BO_ensureInSystemCache "DOWNLOADED_PATH" "github.com/sindresorhus/escape-string-regexp" "1.0.5" "https://github.com/sindresorhus/escape-string-regexp/archive/v1.0.5.zip"

echo "DOWNLOADED_PATH: $DOWNLOADED_PATH"