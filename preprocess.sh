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


# change floating point numbers to have , as decimal point (dont touch title column)
col=2 # title column
# check for commas in columns before column 2
if cut -f1 "${filename%.txt}_tab.txt" | grep -qE '[0-9]+,[0-9]+' || \
   cut -f3- "${filename%.txt}_tab.txt" | grep -qE '[0-9]+,[0-9]+'; then

    # save title column
    cut -f$col "${filename%.txt}_tab.txt" > col2.tmp

    cut -f1-$(($col-1)) "${filename%.txt}_tab.txt" | sed 's/\([0-9]\+\),\([0-9]\+\)/\1.\2/g' > before.tmp
    cut -f$(($col+1))- "${filename%.txt}_tab.txt" | sed 's/\([0-9]\+\),\([0-9]\+\)/\1.\2/g' > after.tmp
    # recombine the columns
    paste before.tmp col2.tmp after.tmp > "${filename%.txt}_tab.txt"
    rm before.tmp col2.tmp after.tmp
    
    echo "Decimal commas converted to decimal points (except title column)"
else
    echo "No decimal commas found to convert in non-title columns"
fi


# delete all non-ASCII characters
tr -c '\0-\177' -d < "${filename%.txt}_tab.txt" > "${filename%.txt}_tab_ascii.txt" # decimal 0-127
mv "${filename%.txt}_tab_ascii.txt" "${filename%.txt}_tab.txt"
echo "Non-ASCII characters removed from file"

