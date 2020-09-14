#!/usr/bin/env bash

while read line; do
    path=$(realpath $line)
    echo $(nix-instantiate --eval learner/extract.nix --argstr conf $path)
done < $1