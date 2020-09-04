#!/usr/bin/env bash

RED='\033[1;31m'
GREEN='\033[1;32m'
NC='\033[0m'

type=
config=
tip=
extraFlags=
attr=" "
colored=false

showSyntax() {
    echo "Usage: $0 --tip <tips.nix> --type <TYPE> --config <config.nix>"
    echo
    echo "Options"
    echo
    echo "  -A, --attr ATTRIBUTE      Optional attribute that selects a configuration"
    echo "                      expression in the config file"
    echo "  --color                   Color code the output"
    echo "  -C, --config FILE         Config files to generate recommendations on"
    echo "  -H, --help                Print this help."
    echo "      --show-trace          Sent to the call to nix-instantiate, useful for"
    echo "                      debugging"
    echo "  -T, --tip FILE            File containing tips to generate recommendations with"
    echo "  --type                    The type of config file that is being used"
    exit 0
}

while [ "$#" -gt 0 ]; do
    i="$1"; shift 1
    case "$i" in
        --help|-h|-H)
            showSyntax
            ;;
        --tip|-T)
            tip="$1"; shift 1
            ;;
        --show-trace)
            extraFlags+="--show-trace"
            ;;
        --attr|-A)
            attr="$1"; shift 1
            ;;
        --config|-C)
            config="$1"; shift 1
            ;;
        --type)
            type="$1"; shift 1
            ;;
        --color)
            colored="true"
            ;;
        *)
            echo "unknown option: \`$i'"
            exit 1
        ;;
    esac
done

TEXT=$(nix-instantiate $extraFlags --eval nix-tip.nix --argstr "tipsPath" $(realpath $tip) --argstr "confPath" $(realpath $config) --argstr "type" $type --argstr "confAttr" "$attr")

TEXT=${TEXT#\"}
TEXT=${TEXT%\"}

printf "$TEXT" | while read line ; do
    if [ $colored == "true" ]; then
        if [[ "$line" == "Recommended:"* ]];
        then
            line=${GREEN}${line}
        else
            line=${RED}${line}
        fi
        line+=$NC
    fi
    printf "$line\n"
done
