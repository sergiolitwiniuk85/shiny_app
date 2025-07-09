Here's a comprehensive `README.md` for your GitHub repository based on your Shiny app code:

```markdown
# IEDB Epitope Dashboard

![Shiny](https://img.shields.io/badge/shiny-%2325A162.svg?style=for-the-badge&logo=r&logoColor=white)
![R](https://img.shields.io/badge/r-%23276DC3.svg?style=for-the-badge&logo=r&logoColor=white)

An interactive dashboard for exploring epitope data from the Immune Epitope Database (IEDB), featuring dynamic visualizations and filtering capabilities.

## Features

- **Organism & MHC Allele Filtering**: Multi-select organisms and MHC alleles
- **Smart Visualization**: Dynamic bar plot that adapts to selected filters
- **Interactive Components**:
  - Summary bar plot with top MHC alleles or organisms
  - Heatmap visualization (currently placeholder)
  - Interactive data table with search and pagination
- **Responsive Design**: Clean layout with citation footer

## Installation

1. Clone the repository:
```bash
git clone https://github.com/yourusername/iedb-epitope-dashboard.git
cd iedb-epitope-dashboard
```

2. Install required R packages:
```R
install.packages(c("shiny", "tidyverse", "DT", "plotly", "lubridate"))
```

3. Place your epitope data CSV (`df_epitope_data.csv`) in the project root

## Usage

Run the app from R/RStudio:
```R
shiny::runApp()
```

### Interface Overview

- **Sidebar Panel**:
  - Select organisms (e.g., Influenza, HIV)
  - Select MHC alleles (e.g., HLA-A*02:01)
  - Click "Apply Filters" to update visualizations

- **Main Panel Tabs**:
  - **Summary**: 
    - Shows top 20 MHC alleles by default
    - Switches to top organisms when MHC alleles are selected without organisms
  - **Heatmap**: Placeholder for future development
  - **Table**: Interactive table with full dataset

## Data Source

Data comes from the [Immune Epitope Database (IEDB)](https://www.iedb.org/). 

**Required Citation**:  
Vita et al., *Nucleic Acids Research* (2019), **47**(D1): D339–D343.  
[https://doi.org/10.1093/nar/gky1006](https://doi.org/10.1093/nar/gky1006)

## Dynamic Visualization Logic

The summary plot intelligently adapts based on user selections:

```r
if (MHC allele selected AND no organism selected) {
  Show top organisms for selected MHC alleles
} else {
  Show top MHC alleles for selected organisms
}
```

## Dependencies

- R (>= 4.0.0)
- Packages:
  - `shiny`
  - `tidyverse` (dplyr, ggplot2, tidyr)
  - `DT`
  - `plotly`
  - `lubridate`

## File Structure

```
iedb-epitope-dashboard/
├── app.R                  # Main application code
├── df_epitope_data.csv    # Epitope dataset (not included in repo)
├── README.md              # This documentation
└── ...                    # Additional files as needed
```

## License

[MIT License](LICENSE)

Sergio Litwiniuk 2925
