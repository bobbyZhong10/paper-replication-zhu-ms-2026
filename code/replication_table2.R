# Replication of Table 2 in Zhu, Shi and Banerjee (2025):
# giveaways listed by publishers before and after the January 2018 fee.
# Open paper-replication-zhu-ms-2026.Rproj first, so that paths start at the repository root.

library(data.table)
library(lfe)

# Giveaways with the publisher and Big 5 status of each book
books <- fread("data/supply/book_3participation_supply_selfControl.csv.bz2",
               select = c("id", "cleanPublisher", "big5Publishing"))
giveaways <- fread("data/supply/giveaways_3participation_supply_selfControl.csv",
                   select = c("book_id", "giveaway_year_month"))
giveaways <- merge(giveaways, books, by.x = "book_id", by.y = "id")
giveaways[, giveaway_year_month_date := as.Date(paste0(giveaway_year_month, "-01"))]

# Sample: publishers with a giveaway from 2016 on, observed monthly in 2015-2018
publishers <- unique(giveaways[giveaway_year_month_date >= as.Date("2016-01-01"), .(cleanPublisher, big5Publishing)])
panel <- giveaways[cleanPublisher %in% publishers$cleanPublisher, .(ncount = .N),
                   by = .(cleanPublisher, giveaway_year_month_date)]
panel <- panel[CJ(cleanPublisher = unique(cleanPublisher), giveaway_year_month_date = unique(giveaway_year_month_date)),
               on = .(cleanPublisher, giveaway_year_month_date)]
panel[is.na(ncount), ncount := 0]
panel <- merge(panel, publishers, by = "cleanPublisher")
panel[, month := format(giveaway_year_month_date, "%m")]

# Outcome (2): monthly giveaways relative to the publisher's total before the fee
panel[, nPre := sum(ncount[giveaway_year_month_date < as.Date("2018-01-01")]), by = cleanPublisher]
panel[, proportion := ncount / nPre]

# treated: the 2017-2018 pair, which contains the fee ("Post Monetization" in the paper); 2015-2016 is the control pair
# after: the second year of each pair (2016 and 2018)
panel[, treated := as.numeric(giveaway_year_month_date >= as.Date("2017-01-01"))]
panel[, after := as.numeric(year(giveaway_year_month_date) %in% c(2016, 2018))]
panel[, cleanPublisherAfter := paste(cleanPublisher, treated, sep = "_")]   # publisher fixed effect within each pair

# ncount_pt = b1 * treated_t * after_t + b2 * treated_t * after_t * big5Publishing_p + a_(p,pair) + m_month + e_pt
# As in the paper, after enters only through the interactions.
# To add it, append "+ after + after:big5Publishing" to the regressors.
# felm syntax: y ~ regressors | fixed effects | instruments (none) | cluster
m1 <- felm(ncount ~ treated:after + treated:after:big5Publishing | month + cleanPublisherAfter | 0 | cleanPublisher,
           data = panel)
m2 <- felm(proportion ~ treated:after + treated:after:big5Publishing | month + cleanPublisherAfter | 0 | cleanPublisher,
           data = panel[is.finite(proportion)])

# Save results
dir.create("results/replication_table2", recursive = TRUE, showWarnings = FALSE)
c1 <- coef(summary(m1))
c2 <- coef(summary(m2))
fwrite(rbind(data.table(model = "(1) No. of Giveaways", term = rownames(c1), c1, N = m1$N, R2 = summary(m1)$r.squared),
             data.table(model = "(2) Proportion", term = rownames(c2), c2, N = m2$N, R2 = summary(m2)$r.squared)),
       "results/replication_table2/table2.csv")

a <- "treated:after"
b <- "treated:after:big5Publishing"
writeLines(c(
  "# Table 2: Impact on Books Published by Different Types of Publishers",
  "",
  "| | (1) No. of Giveaways | (2) Proportion |",
  "|:--|:-:|:-:|",
  sprintf("| Post Monetization x After | %.4f (%.4f) | %.4f (%.4f) |", c1[a, 1], c1[a, 2], c2[a, 1], c2[a, 2]),
  sprintf("| Post Monetization x After x Big 5 Publishers | %.4f (%.4f) | %.4f (%.4f) |", c1[b, 1], c1[b, 2], c2[b, 1], c2[b, 2]),
  "| Month fixed effect | Yes | Yes |",
  "| Publisher fixed effect | Yes | Yes |",
  sprintf("| Observations | %s | %s |", format(m1$N, big.mark = ","), format(m2$N, big.mark = ",")),
  sprintf("| R2 | %.3f | %.3f |", summary(m1)$r.squared, summary(m2)$r.squared),
  "",
  "Standard errors clustered by publisher in parentheses."
), "results/replication_table2/table2.md")
