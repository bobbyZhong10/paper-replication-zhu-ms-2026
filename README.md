# paper-replication-zhu-ms-2026

This repository replicates Tables 2 and 3 and the review-volume column of Table 4 of:

Kai Zhu, Qiaoni Shi, Shrabastee Banerjee (2025) Monetizing Platforms: An Empirical Analysis of Supply and Demand Responses to Entry Costs in Two-Sided Markets. Management Science 72(3):2380-2397. https://doi.org/10.1287/mnsc.2023.01390

The paper studies the Goodreads Giveaways program, which began to charge authors and publishers a fee in January 2018. Table 2 shows the change in participation by publisher type, Table 3 shows the change in genre shares, and Table 4 shows the effect of a giveaway on review volume before and after the fee.

## Structure

```
paper/     the published article (PDF)
data/      data from the authors' replication package
code/      one R script per table, plus install_packages.R
results/   one folder per table, each with a CSV and a Markdown table
```

The variable names in `code/` follow the authors' data and code, for example `treated`, `after` and `cleanPublisherAfter` in Table 2. Each script states its regression equation in a comment above the model.

## Data

All data come from the authors' replication package. It is part of the Supplemental Material at https://pubsonline.informs.org/doi/suppl/10.1287/mnsc.2023.01390. Only the files needed for the three tables are included. See [`data/README.md`](data/README.md).

## How to run

1. Open `paper-replication-zhu-ms-2026.Rproj` in RStudio. This sets the working directory to the repository root.
2. Run `code/install_packages.R` once. It installs `data.table`, `lfe` and `R.utils` if they are missing.
3. Open a script in `code/` and click Source. Each script runs on its own and writes its results to `results/`.

From a terminal, run `Rscript code/replication_table2.R` (and the same for Tables 3 and 4) in the repository root.

The scripts were run with R 4.5.3, data.table 1.18.2.1, lfe 3.1.1 and R.utils 2.13.0. Table 4 loads about 12.6 million rows and needs a few GB of memory.

## Results

| Script | Output | Table |
|---|---|---|
| `code/replication_table2.R` | `results/replication_table2/` | Table 2 |
| `code/replication_table3.R` | `results/replication_table3/` | Table 3 |
| `code/replication_table4.R` | `results/replication_table4/` | Table 4, review-volume column |

All coefficients, standard errors and numbers of observations match the published tables. The rating column of Table 4 is not replicated because the replication package does not include the ratings data.

## License

The code is under the MIT License in `LICENSE`. The data belong to the original authors and are not covered by this license.

The article in `paper/` is "Management Science. Copyright © 2025 The Author(s). https://doi.org/10.1287/mnsc.2023.01390, used under a Creative Commons Attribution License: https://creativecommons.org/licenses/by-sa/4.0/."
