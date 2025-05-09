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

#! /bin/bash

# given a text file version of a spreadsheet and the expected separator character, 
# returns via standard output a list of the column titles (taken 
# from the first line) the number of empty cells found in that column

# usage: empty_cells.sh <filename> <separator>
# example: empty_cells.sh bgg_dataset.txt ";"

# read the filename and separator from the command line
filename=$1
separator=$2
echo "separator: $separator"

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

# Extract the first line (column titles)
first_column=$(head -n 1 "$filename" | tr -d '\r') # remove carriage return characters
echo "Column titles: $first_column"

# ge tthe number of columns using gawk
num_columns=$(echo "$first_column" | gawk -F"$separator" '{print NF}')
echo "Number of columns: $num_columns"

# loop through each column
for ((i=1; i<=num_columns; i++)); do
    # get the column title
    column_title=$(echo "$first_column" | gawk -F"$separator" -v col=$i '{print $col}')
    
    # count the number of empty cells in that column
    empty_cells=$(tail -n +2 "$filename" | gawk -F"$separator" -v col=$i 'BEGIN {count = 0} {if ($col == "") count++} END {print count}')
    
    # print the column title and the number of empty cells
    echo "$column_title: $empty_cells"
done