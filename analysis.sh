#!/bin/bash

# This script analyses a TSV file of board game data to answer research questions
# usage: ./analysis.sh <filename>
# eg: ./analysis.sh bgg_dataset_cleaned.tsv

if [ $# -ne 1 ]; then
    echo "Usage: $0 <filename>"
    exit 1
fi

filename=$1

# Check if file exists
if [ ! -f "$filename" ]; then
    echo "File not found: $filename"
    exit 1
fi

# Check if the file is empty
if [ ! -s "$filename" ]; then
    echo "File is empty!"
    exit 1
fi


# find and print the most popular mechanics and domains
tail -n +2 "$filename" | cut -f13 > mechanics.tmp
tail -n +2 "$filename" | cut -f14 > domains.tmp

most_popular_mechanics=$(tr ',' '\n' < mechanics.tmp | sed 's/^ *//;s/ *$//;s/"//g' | grep -v '^$' | sort | uniq -c | sort -nr | head -n1)
most_popular_domain=$(tr ',' '\n' < domains.tmp | sed 's/^ *//;s/ *$//;s/"//g' | grep -v '^$' | sort | uniq -c | sort -nr | head -n1)

mechanics_count=$(echo "$most_popular_mechanics" | gawk '{print $1}')
mechanics_name=$(echo "$most_popular_mechanics" | gawk '{$1=""; print substr($0,2)}')
domain_count=$(echo "$most_popular_domain" | gawk '{print $1}')
domain_name=$(echo "$most_popular_domain" | gawk '{$1=""; print substr($0,2)}')

echo "The most popular game mechanics is $mechanics_name found in $mechanics_count games"
echo "The most popular game domain is $domain_name found in $domain_count games"
rm mechanics.tmp domains.tmp
