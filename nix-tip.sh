#!/usr/bin/env bash

TYPE=$1
CONFIG_FILE=$2
TIP_FILE=$3

TEXT=$(nix-instantiate --show-trace --eval nix-tip.nix --argstr "tipsPath" $(realpath $TIP_FILE) --argstr "confPath" $(realpath $CONFIG_FILE) --argstr "type" "home")

TEXT=${TEXT#\"}
TEXT=${TEXT%\"}

printf "$TEXT"
