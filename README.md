# paper-replication-zhu-ms-2026

This repository replicates Tables 2 and 3 and the review-volume columns (3) and (4) of Table 4 of:

Kai Zhu, Qiaoni Shi, Shrabastee Banerjee (2025) Monetizing Platforms: An Empirical Analysis of Supply and Demand Responses to Entry Costs in Two-Sided Markets. Management Science 72(3):2380-2397. https://doi.org/10.1287/mnsc.2023.01390

The paper studies the Goodreads Giveaways program, which began to charge authors and publishers a fee in January 2018. Table 2 shows the change in participation by publisher type, Table 3 shows the change in genre shares, and Table 4 shows the effect of a giveaway on review volume before and after the fee.

## Structure

```
paper/     the published paper (PDF)
data/      data from the authors' replication package
code/      one R Markdown file per table, plus install_packages.R
results/   one folder per table, each with a CSV and a Markdown table
slides/    Beamer slides of the replication
```

## Data

All data come from the authors' replication package. It is part of the Supplemental Material at https://pubsonline.informs.org/doi/suppl/10.1287/mnsc.2023.01390. Only the files needed for the three tables are included. See [`data/README.md`](data/README.md).

## How to run

1. Open `paper-replication-zhu-ms-2026.Rproj` in RStudio. This sets the working directory to the repository root.
2. Run `code/install_packages.R` once. It installs `data.table`, `lfe`, `R.utils` and `rmarkdown` if they are missing.
3. Open an `.Rmd` file in `code/` and click Knit. Each document runs on its own and writes its results to `results/`. The setup chunk of each document sets the working directory to the repository root, so the chunks can also be run one by one.

From a terminal, run in the repository root:

```
Rscript code/install_packages.R
Rscript -e 'rmarkdown::render("code/replication_table2.Rmd")'
Rscript -e 'rmarkdown::render("code/replication_table3.Rmd")'
Rscript -e 'rmarkdown::render("code/replication_table4.Rmd")'
```

Knitting needs pandoc. RStudio includes it; outside RStudio, install it from https://pandoc.org.

The documents were knitted with R 4.6.1, data.table 1.18.6.1, lfe 3.1.1, R.utils 2.13.0, rmarkdown 2.32 and pandoc 3.12.1. Table 4 loads about 12.6 million rows and needs a few GB of memory.

## Results

| Document | Output | Table |
|---|---|---|
| `code/replication_table2.Rmd` | `results/replication_table2/` | Table 2 |
| `code/replication_table3.Rmd` | `results/replication_table3/` | Table 3 |
| `code/replication_table4.Rmd` | `results/replication_table4/` | Table 4, columns (3) and (4) |

## License

The code is under the MIT License in `LICENSE`. The data belong to the original authors and are not covered by this license.

The paper in `paper/` is "Management Science. Copyright © 2025 The Author(s). https://doi.org/10.1287/mnsc.2023.01390, used under a Creative Commons Attribution License: https://creativecommons.org/licenses/by-sa/4.0/."
