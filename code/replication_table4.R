# Replication of Table 4 (review-volume column) in Zhu, Shi and Banerjee (2025):
# monthly ratings of a book after its giveaway, before and after the January 2018 fee.
# Open paper-replication-zhu-ms-2026.Rproj first, so that paths start at the repository root.

library(data.table)
library(lfe)

# Book-month panel of the number of ratings N, 12 months before and after the giveaway
reviews <- readRDS("data/demand/review_vol_yearmon.Rds")
reviews <- reviews[abs(diff_month) <= 12]

# post_giveaway = 1 in the months after the book's giveaway
# post_mon = 1 if the giveaway took place after the fee (from January 2018)
# N_it = b1 * post_giveaway_it + b2 * post_giveaway_it * post_mon_i + a_i + m_yearmon + e_it
# felm syntax: y ~ regressors | fixed effects | instruments (none) | cluster
m1 <- felm(N ~ post_giveaway + post_giveaway:post_mon | book_id + yearmon | 0 | book_id, data = reviews)
m2 <- felm(N ~ post_giveaway | book_id + yearmon | 0 | book_id, data = reviews)

# Save results
dir.create("results/replication_table4", recursive = TRUE, showWarnings = FALSE)
c1 <- coef(summary(m1))
c2 <- coef(summary(m2))
fwrite(rbind(data.table(model = "(1)", term = rownames(c1), c1, N = m1$N, adj_R2 = summary(m1)$adj.r.squared),
             data.table(model = "(2)", term = rownames(c2), c2, N = m2$N, adj_R2 = summary(m2)$adj.r.squared)),
       "results/replication_table4/table4.csv")

a <- "post_giveaway"
b <- "post_giveaway:post_mon"
writeLines(c(
  "# Table 4: Effect of Giveaway and Monetization on Review Volume",
  "",
  "Dependent variable: number of ratings per book and month, 12 months before and after the giveaway.",
  "",
  "| | (1) | (2) |",
  "|:--|:-:|:-:|",
  sprintf("| Post Giveaway | %.3f (%.3f) | %.3f (%.3f) |", c1[a, 1], c1[a, 2], c2[a, 1], c2[a, 2]),
  sprintf("| Post Giveaway x Post Monetization | %.3f (%.3f) | |", c1[b, 1], c1[b, 2]),
  sprintf("| Number of books | %s | %s |", format(uniqueN(reviews$book_id), big.mark = ","), format(uniqueN(reviews$book_id), big.mark = ",")),
  sprintf("| Mean rating count | %.2f | %.2f |", mean(reviews$N), mean(reviews$N)),
  "| Book fixed effects | Yes | Yes |",
  "| Year-month fixed effects | Yes | Yes |",
  sprintf("| Observations | %s | %s |", format(m1$N, big.mark = ","), format(m2$N, big.mark = ",")),
  sprintf("| Adjusted R2 | %.3f | %.3f |", summary(m1)$adj.r.squared, summary(m2)$adj.r.squared),
  "",
  "Standard errors clustered by book in parentheses."
), "results/replication_table4/table4.md")
