# Replication of Table 3 in Zhu, Shi and Banerjee (2025):
# monthly genre shares of giveaway books before and after the January 2018 fee.
# Open paper-replication-zhu-ms-2026.Rproj first, so that paths start at the repository root.

library(data.table)
library(lfe)

genre <- fread("data/genre/giveaway_genre_proportion_long.csv")

# post2 = 1 from April 2018 and 0 before 2018; January to March 2018 are dropped
genre[, post2 := fcase(giveaway_year_month >= "2018-04", 1,
                       giveaway_year_month <= "2017-12", 0)]

# Popular genres are in the top quartile of the pre-fee share, niche genres in the bottom quartile
genre[, above_q75 := as.numeric(above_q75)]
genre[, below_q25 := as.numeric(!above_q25)]

# Outcome (2): share relative to the genre's mean share before the fee
genre[, proportion_normalized := proportion / mean_pre_proportion]

# proportion_gt = b1 * post2_t * above_q75_g + b2 * post2_t * below_q25_g + a_g + m_month + e_gt
# Middle genres are the reference group. Standard errors are clustered by calendar month.
# felm syntax: y ~ regressors | fixed effects | instruments (none) | cluster
m1 <- felm(proportion ~ post2:above_q75 + post2:below_q25 | genre + month | 0 | month, data = genre)
m2 <- felm(proportion_normalized ~ post2:above_q75 + post2:below_q25 | genre + month | 0 | month, data = genre)

# Save results
dir.create("results/replication_table3", recursive = TRUE, showWarnings = FALSE)
c1 <- coef(summary(m1))
c2 <- coef(summary(m2))
fwrite(rbind(data.table(model = "(1) Raw proportion", term = rownames(c1), c1, N = m1$N, R2 = summary(m1)$r.squared),
             data.table(model = "(2) Percentage change", term = rownames(c2), c2, N = m2$N, R2 = summary(m2)$r.squared)),
       "results/replication_table3/table3.csv")

a <- "post2:above_q75"
b <- "post2:below_q25"
writeLines(c(
  "# Table 3: Impact on Genre Proportion",
  "",
  "| | (1) Raw proportion | (2) Percentage change |",
  "|:--|:-:|:-:|",
  sprintf("| Post monetization x top 25%% genre | %.4f (%.4f) | %.4f (%.4f) |", c1[a, 1], c1[a, 2], c2[a, 1], c2[a, 2]),
  sprintf("| Post monetization x bottom 25%% genre | %.4f (%.4f) | %.4f (%.4f) |", c1[b, 1], c1[b, 2], c2[b, 1], c2[b, 2]),
  "| Month fixed effect | Yes | Yes |",
  "| Genre fixed effect | Yes | Yes |",
  sprintf("| Observations | %s | %s |", format(m1$N, big.mark = ","), format(m2$N, big.mark = ",")),
  sprintf("| R2 | %.3f | %.3f |", summary(m1)$r.squared, summary(m2)$r.squared),
  "",
  "Standard errors clustered by calendar month in parentheses."
), "results/replication_table3/table3.md")
