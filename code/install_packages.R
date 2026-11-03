# Install the packages used by the replication documents. Run once.
# R.utils lets data.table::fread() read the compressed book file.
# rmarkdown knits the .Rmd files.
pkgs <- c("data.table", "lfe", "R.utils", "rmarkdown")
missing <- pkgs[!pkgs %in% rownames(installed.packages())]
if (length(missing) > 0) install.packages(missing)
