#!/bin/bash

# this script converts a semicolon separated file to a tab separated file and outputs 

filename=$1

# check if the file exists
if [ ! -f "$filename" ]; then
    echo "File not found!"
    exit 1
fi 

# check if the file is empty
if [ ! -s "$filename" ]; then
    echo "File is empty!"
    exit 1
fi

# check if the separator is provided
if [ -z "$separator" ]; then
    echo "Separator not provided!"
    exit 1
fi

# check if the separator is a single character
if [ ${#separator} -ne 1 ]; then
    echo "Separator must be a single character!"
    exit 1
fi

# convert the file to a tab separated file using gawk