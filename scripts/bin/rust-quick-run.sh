#!/bin/sh

# Compiles and run a single rust file while keeping a clean directory

if [ ! -e "$1" ]; then
    echo "'$1': No such file or directory"
else
    rustc $1 -o a.out
    if [ $? == 0 ]; then
        ./a.out 
        rm a.out
    fi
fi
