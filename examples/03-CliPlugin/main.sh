#!/usr/bin/env bash.origin

# Source https://github.com/cadorn/bash.origin
if [ -z "${BO_LOADED}" ]; then
		. "../../bash.origin"
fi
function init {
	eval BO_SELF_BASH_SOURCE="$BO_READ_SELF_BASH_SOURCE"
	BO_deriveSelfDir ___TMP___ "$BO_SELF_BASH_SOURCE"
	local __BO_DIR__="$___TMP___"


	BO_sourcePrototype "$__BO_DIR__/bin/plugin" "ARG-1" "--switch1 ARG-2" --switch2 "ARG-3"
}
init
