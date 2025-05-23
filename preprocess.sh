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
    sed 's/;/	/g' "$filename" > "${filename%.txt}_cleaned.tsv"
    filename="${filename%.txt}" # update filename to basename
else
    echo "Error: File does not contain semicolon separators!"
    exit 1
fi



# check if file has Microsoft line endings (\r\n) and convert only if needed
if grep -q $'\r' "${filename}_cleaned.tsv"; then
    # convert the Microsoft line endings to Unix line endings (remove \r)
    sed -i 's/\r$//' "${filename}_cleaned.tsv"
    echo "File converted to Unix line endings: ${filename}_cleaned.tsv"
else
    echo "File already has Unix line endings, no conversion needed."
fi


# Convert decimal commas to decimal points in columns 3-12 (excluding Mechanics and Domains columns)
if cut -f3-12 "${filename}_cleaned.tsv" | grep -qE '[0-9]+,[0-9]+'; then
    gawk -F'\t' -v OFS='\t' '
    {
        for(i=3; i<=12; i++) {
            gsub(/,/, ".", $i)
        }
        print
    }' "${filename}_cleaned.tsv" > "${filename}_cleaned.tsv.tmp"
    
    mv "${filename}_cleaned.tsv.tmp" "${filename}_cleaned.tsv"
    
    echo "Decimal commas converted to decimal points in columns 3-12"
else
    echo "No decimal commas found to convert in columns 3-12"
fi

# check if file contains non-ASCII characters
if grep -q '[^\x00-\x7F]' "${filename}_cleaned.tsv"; then
    # delete all non-ASCII characters
    tr -c '\0-\177' -d < "${filename}_cleaned.tsv" > "${filename}_ascii.tsv" # decimal 0-127
    mv "${filename}_ascii.tsv" "${filename}_cleaned.tsv"
    echo "Non-ASCII characters removed from file"
else
    echo "No non-ASCII characters found in file"
fi


# add new unique IDs for rows with empty IDs
max_id=$(gawk -F'\t' 'NR>1 && $1 ~ /^[0-9]+$/ {if($1 > max) max = $1} END {print max+0}' "${filename}_cleaned.tsv")
empty_count=$(gawk -F'\t' 'NR>1 && ($1 == "" || $1 ~ /^[[:space:]]*$/) {count++} END {print count+0}' "${filename}_cleaned.tsv")

if [ "$empty_count" -gt 0 ]; then
    gawk -F'\t' -v OFS='\t' -v max="$max_id" '
        NR == 1 { print; next }
        $1 == "" || $1 ~ /^[[:space:]]*$/ { $1 = ++max }
        { print }
    ' "${filename}_cleaned.tsv" > "data_with_ids.tmp"
    echo "Added $empty_count unique IDs to rows with empty IDs (starting from $max_id)"
else
    echo "No empty IDs found"
fi

# Rename the final output file to have .tsv extension
if [ -f "data_with_ids.tmp" ]; then
    mv "data_with_ids.tmp" "${filename}_cleaned.tsv"
else
    cp "${filename}.tsv" "${filename}_cleaned.tsv"
fi
rm -f "data_with_ids.tmp"
echo "Final output saved as ${filename}_cleaned.tsv"
