#/usr/bin/env bash

_nix-tip_complete ()
{
    local Options
    Options=( "-A" "--attr" "--color" "-C" "--config" "-H" "-h" "--help" "--show-trace" "-T" "--tip" "--type")
    
    local CurrentWord
    CurrentWord="${COMP_WORDS[$COMP_CWORD]}"

    local PreviousWord
    if [ "$COMP_CWORD" -ge 1 ]
    then
        PreviousWord="${COMP_WORDS[COMP_CWORD-1]}"
    else
        PreviousWord=""
    fi

    COMPREPLY=()

    case "$PreviousWord" in
        "-C"|"--config")
            COMPREPLY+=( $( compgen -o plusdirs -f -X '!*.nix' -- "$CurrentWord") )
            ;;
        "-T"|"--tip")
            COMPREPLY+=( $( compgen -o plusdirs -f -X '!*.nix' -- "$CurrentWord") )
            ;;
        "--type")
            COMPREPLY+=( $( compgen -W "home nixos" -- "$CurrentWord" ) )
            ;;
        *)
            COMPREPLY+=( $( compgen -W "${Options[*]}" -- "$CurrentWord" ) )
            ;;

    esac
}

complete -F _nix-tip_complete -o default nix-tip