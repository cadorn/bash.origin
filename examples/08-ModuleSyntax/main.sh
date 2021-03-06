#!/usr/bin/env bash.origin

eval BO_SELF_BASH_SOURCE="$BO_READ_SELF_BASH_SOURCE"
BO_deriveSelfDir ___TMP___ "$BO_SELF_BASH_SOURCE"
local __BO_DIR__="$___TMP___"


pushd "$__BO_DIR__" > /dev/null

	# NOTE: For full test suite see 'bash.origin.modules'

	echo "TEST_MATCH_IGNORE>>>"
	BO_requireModule "./module.bo.sh" as "module"
	echo "<<<TEST_MATCH_IGNORE"

	module run "from main"

	./script.bo.sh

popd > /dev/null
