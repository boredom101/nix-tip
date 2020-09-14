#/usr/bin/env bash

_nix-learner_complete ()
{
    local Options
    Options=( "-H" "--help" "-I" "--input" "-O" "--output" "-T" "--thresh" )

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
        "-I"|"--input")
            COMPREPLY+=( $( compgen -o plusdirs -f -X '!*.txt' -- "$CurrentWord") )
            ;;
        "-O"|"--output")
            COMPREPLY+=( $( compgen -o plusdirs -f -X '!*.json' -- "$CurrentWord") )
            ;;
        *)
            COMPREPLY+=( $( compgen -W "${Options[*]}" -- "$CurrentWord" ) )
            ;;
    esac
}

complete -F _nix-learner_complete -o default nix-learner