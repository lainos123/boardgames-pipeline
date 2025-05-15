#!/bin/bash

# this script converts a semicolon separated file to a tab separated file and outputs 

# usage: ./preprocess.sh <filename>
# eg: ./preprocess.sh bgg_dataset.txt

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


# convert the semicolon separated file to a tab separated file
sed 's/;/	/g' "$filename" > "${filename%.txt}_tab.txt"
echo "File converted to tab separated format: ${filename%.txt}_tab.txt"
