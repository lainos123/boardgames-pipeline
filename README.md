# Data Cleaning Pipeline with Shell

A data processing pipeline built using Unix shell tools to clean and analyse [data](https://www.kaggle.com/datasets/andrewmvd/board-games) from BoardGameGeek.  
Created as part of CITS4407 (Open Source Tools and Scripting) at the University of Western Australia.

---
### Tools Used
- `awk`, `tr`, `cut`, `sort`, `uniq`, `paste`, `sed`
- Bash scripting
- Git for version control

### Skills Demonstrated
- Data cleaning and preprocessing of raw `.csv`-like files
- Command-line data wrangling using UNIX utilities
- Handling missing and malformed data
- Text parsing and format normalization
- Exploratory data analysis (EDA)
- Correlation analysis (Pearson coefficient)
- Writing modular, reusable shell scripts

### Structure
```
data-cleaning-eda-shell/
├── scripts/           # All shell scripts
├── data/              # Provided raw data files
├── output/            # Cleaned data and analysis outputs
├── README.md
└── .gitignore
```
### How to Run

1. Place all given raw data files inside the `data/` directory.
2. Run the pipeline from the root folder:
   ```bash
   bash scripts/run_pipeline.sh
   ```
3.	Output files will be saved to the output/ folder.


---
**Author: Laine Mulvay**  – [LinkedIn](https://www.linkedin.com/in/lainemulvay/)