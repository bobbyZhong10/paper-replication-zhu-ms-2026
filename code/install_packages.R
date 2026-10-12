# Install the packages used by the replication scripts. Run once.
# R.utils lets data.table::fread() read the compressed book file.
pkgs <- c("data.table", "lfe", "R.utils")
missing <- pkgs[!pkgs %in% rownames(installed.packages())]
if (length(missing) > 0) install.packages(missing)
