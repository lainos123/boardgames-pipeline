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

# check if file has semicolon separators
if ! grep -q ";" "$filename"; then
    echo "Error: File does not contain semicolon separators!"
    exit 1
fi

# convert the semicolon separated file to a tab separated file
sed 's/;/	/g' "$filename" > "${filename%.txt}_tab.txt"
echo "File converted to tab separated format: ${filename%.txt}_tab.txt"

# check if file has Microsoft line endings (\r\n) and convert only if needed
if grep -q $'\r' "${filename%.txt}_tab.txt"; then
    # convert the Microsoft line endings to Unix line endings (remove \r)
    sed -i 's/\r$//' "${filename%.txt}_tab.txt"
    echo "File converted to Unix line endings: ${filename%.txt}_tab.txt"
else
    echo "File already has Unix line endings, no conversion needed."
fi
