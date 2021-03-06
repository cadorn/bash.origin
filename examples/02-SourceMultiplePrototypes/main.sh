#!/usr/bin/env bash.origin

eval BO_SELF_BASH_SOURCE="$BO_READ_SELF_BASH_SOURCE"
BO_deriveSelfDir ___TMP___ "$BO_SELF_BASH_SOURCE"
local __BO_DIR__="$___TMP___"


echo ">-- ROOT - $__BO_DIR__"
BO_isSourced ___TMP___
echo "| (root) BO_isSourced: $___TMP___"
echo "| Source ..."
BO_sourcePrototype $__BO_DIR__/sub1/main "|---"
hello "|"
BO_sourcePrototype $__BO_DIR__/sub2/main "|---"
hello "|"
BO_isSourced ___TMP___
echo "| (root) BO_isSourced: $___TMP___"
echo "| Run ..."
$__BO_DIR__/sub1/main "|---"
$__BO_DIR__/sub2/main "|---"
BO_isSourced ___TMP___
echo "| (root) BO_isSourced: $___TMP___"
echo "<-- ROOT - $__BO_DIR__"
