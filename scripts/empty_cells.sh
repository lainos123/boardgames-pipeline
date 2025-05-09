#! /bin/bash

# given a text file version of a spreadsheet and the expected separator character, 
# returns via standard output a list of the column titles (taken 
# from the first line) the number of empty cells found in that column

# usage: empty_cells.sh <filename> <separator>
# example: empty_cells.sh bgg_dataset.txt ";"

# read the filename and separator from the command line
filename=$1
separator=$2

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
