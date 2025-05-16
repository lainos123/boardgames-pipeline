#!/bin/bash

# This script preprocesses a semicolon-separated board game dataset by:
# 1. Converting semicolon separators to tab characters
# 2. Converting Microsoft line endings (\r\n) to Unix line endings (\n)
# 3. Converting decimal commas to decimal points in numeric columns
# 4. Removing non-ASCII characters from the output
# 5. Adding unique IDs to rows with missing IDs (starting from the highest existing ID)
# The processed file is saved with a .tsv extension and the suffix `_cleaned`

# usage: ./preprocess.sh <filename>
# eg: ./preprocess.sh bgg_dataset.txt

filename=$1

# Check if argument is provided
if [ $# -ne 1 ]; then
    echo "Error: Missing or wrong number of arguments"
    echo "Usage: $0 <filename>"
    exit 1
fi

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
if grep -q ";" "$filename"; then
    # convert the semicolon separated file to a tab separated file
    sed 's/;/	/g' "$filename" > "${filename%.txt}.tsv"
    filename="${filename%.txt}" # update filename to basename
else
    echo "Error: File does not contain semicolon separators!"
    exit 1
fi



# check if file has Microsoft line endings (\r\n) and convert only if needed
if grep -q $'\r' "${filename}.tsv"; then
    # convert the Microsoft line endings to Unix line endings (remove \r)
    sed -i 's/\r$//' "${filename}.tsv"
    echo "File converted to Unix line endings: ${filename}.tsv"
else
    echo "File already has Unix line endings, no conversion needed."
fi


# change floating point numbers to have , as decimal point (dont touch title column)
col=2 # title column

if cut -f1 "${filename}.tsv" | grep -qE '[0-9]+,[0-9]+' || \
   cut -f3- "${filename}.tsv" | grep -qE '[0-9]+,[0-9]+'; then

    # save title column
    cut -f$col "${filename}.tsv" > col2.tmp

    cut -f1-$(($col-1)) "${filename}.tsv" | sed 's/\([0-9]\+\),\([0-9]\+\)/\1.\2/g' > before.tmp
    cut -f$(($col+1))- "${filename}.tsv" | sed 's/\([0-9]\+\),\([0-9]\+\)/\1.\2/g' > after.tmp
    # recombine the columns
    paste before.tmp col2.tmp after.tmp > "${filename}.tsv"
    rm before.tmp col2.tmp after.tmp
    
    echo "Decimal commas converted to decimal points (except title column)"
else
    echo "No decimal commas found to convert in non-title columns"
fi


# check if file contains non-ASCII characters
if grep -q '[^\x00-\x7F]' "${filename}.tsv"; then
    # delete all non-ASCII characters
    tr -c '\0-\177' -d < "${filename}.tsv" > "${filename}_ascii.tsv" # decimal 0-127
    mv "${filename}_ascii.tsv" "${filename}.tsv"
    echo "Non-ASCII characters removed from file"
else
    echo "No non-ASCII characters found in file"
fi


# add new unique IDs for rows with empty IDs
max_id=$(gawk -F'\t' 'NR>1 && $1 ~ /^[0-9]+$/ {if($1 > max) max = $1} END {print max+0}' "${filename}.tsv")
empty_count=$(gawk -F'\t' 'NR>1 && ($1 == "" || $1 ~ /^[[:space:]]*$/) {count++} END {print count+0}' "${filename}.tsv")

if [ "$empty_count" -gt 0 ]; then
    gawk -F'\t' -v OFS='\t' -v max="$max_id" '
        NR == 1 { print; next }
        $1 == "" || $1 ~ /^[[:space:]]*$/ { $1 = ++max }
        { print }
    ' "${filename}.tsv" > "data_with_ids.tmp"
    echo "Added $empty_count unique IDs to rows with empty IDs (starting from $max_id)"
else
    echo "No empty IDs found"
fi

# Rename the final output file to have .tsv extension
mv "data_with_ids.tmp" "${filename}_cleaned.tsv"
echo "Final output saved as ${filename}_cleaned.tsv"
