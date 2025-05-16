# Board Games Data Processing Pipeline

A data processing pipeline built using Unix shell tools to clean and analyse [data](https://www.kaggle.com/datasets/andrewmvd/board-games) from BoardGameGeek.  
Created as part of CITS4407 (Open Source Tools and Scripting) at the University of Western Australia.

---
### Tools Used
- `awk`, `gawk`, `tr`, `cut`, `sort`, `uniq`, `paste`, `sed`, `grep`
- Bash scripting
- Git for version control

### Project Scripts

#### 1. `empty_cells.sh`
Identifies and reports empty cells in the dataset:
- Takes a filename and separator character as input
- Reports the number of empty cells in each column
- Helps identify data quality issues before processing

Usage:
```bash
./empty_cells.sh <filename> "<separator>"
# Example: ./empty_cells.sh bgg_dataset.txt ";"
```

#### 2. `preprocess.sh`
Cleans the raw data:
- Converts semicolon-separated files to tab-separated (TSV) format
- Normalises line endings (Windows to Unix)
- Converts decimal commas to decimal points in numeric columns
- Removes non-ASCII characters
- Adds unique IDs to rows with missing IDs
- Produces a clean TSV file ready for analysis

Usage:
```bash
./preprocess.sh <filename>
# Example: ./preprocess.sh bgg_dataset.txt
```

#### 3. `analysis.sh`
Analyses the cleaned data to answer research questions:
- Identifies the most popular game mechanics and domains
- Calculates correlation between publication year and average rating
- Calculates correlation between game complexity and average rating

Usage:
```bash
./analysis.sh <filename>
# Example: ./analysis.sh bgg_dataset_cleaned.tsv
```

### How to Run the Complete Pipeline

1. Check for data quality issues:
   ```bash
   ./empty_cells.sh bgg_dataset.txt ";"
   ```

2. Clean and preprocess the data:
   ```bash
   ./preprocess.sh bgg_dataset.txt
   ```

3. Analyse the cleaned data:
   ```bash
   ./analysis.sh bgg_dataset_cleaned.tsv
   ```

### Sample Output

When running the analysis on the sample dataset:
```
/ID: 16
Name: 0
Year Published: 1
Min Players: 0
Max Players: 0
Play Time: 0
Min Age: 0
Users Rated: 0
Rating Average: 0
BGG Rank: 0
Complexity Average: 0
Owned Users: 23
Mechanics: 1598
Domains: 10159

File converted to Unix line endings: bgg_dataset.tsv
Decimal commas converted to decimal points (except title column)
Non-ASCII characters removed from file
Added unique IDs to rows with empty IDs (starting from 331787)
Final output saved as bgg_dataset_cleaned.tsv

The most popular game mechanics is Dice Rolling found in 5672 games
The most popular game domain is Wargames found in 3316 games

Testing correlation between the year of publication and the average rating is 0.081
Testing correlation between the game complexity and the average rating is 0.481
```
---
**Author: Laine Mulvay**  – [LinkedIn](https://www.linkedin.com/in/lainemulvay/)