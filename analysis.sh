#!/bin/bash

# This script analyses a tab-separated board game dataset (output from `preprocess.sh`) to answer three research questions:
# 1. What are the most frequently occurring game mechanics and domains across all games?
# 2. Is there a correlation between a game's publication year and its average rating?
# 3. Is there a correlation between a game's complexity rating and its average rating?
# The script processes the data and outputs statistical results for each question to the terminal.

# usage: ./analysis.sh <filename>
# eg: ./analysis.sh bgg_dataset_cleaned.tsv

# Check if argument is provided
if [ $# -ne 1 ]; then
    echo "Error: Missing or wrong number of arguments"
    echo "Usage: $0 <filename>"
    echo "Example: $0 bgg_dataset_cleaned.tsv"
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

# Check if the file is tab-separated
if ! file "$filename" | grep -q "tab-separated"; then
    echo "Error: File must be tab-separated"
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
echo ""
rm mechanics.tmp domains.tmp

# correlation function
correlation() {
    # Calculate Pearson correlation between two columns
    gawk -F'\t' -v col1="$1" -v col2="$2" '
    NR > 1 {
        x[NR] = $col1
        y[NR] = $col2
        sum_x += $col1
        sum_y += $col2
        n++
    }
    END {
        mean_x = sum_x / n
        mean_y = sum_y / n
        
        for (i = 2; i <= NR; i++) {
            sum_xy += (x[i] - mean_x) * (y[i] - mean_y)
            sum_xx += (x[i] - mean_x) * (x[i] - mean_x)
            sum_yy += (y[i] - mean_y) * (y[i] - mean_y)
        }
        
        r = sum_xy / sqrt(sum_xx * sum_yy)
        printf "%.9f", r
    }' "$filename"
}


# find correlation between publication year and average rating 
echo "Testing correlation between the year of publication and the average rating is $(printf "%.3f" $(correlation 3 9))"

# find correlation between game complexity and average rating 
echo "Testing correlation between the game complexity and the average rating is $(printf "%.3f" $(correlation 11 9))"