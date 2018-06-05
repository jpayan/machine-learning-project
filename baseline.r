df <- read.table("data/train.csv", sep=',', header=T)
store_item_nbrs <- read.table("model/store_item_nbrs.csv", sep=',', header=T)
df$log1p <- log1p(df$units)
origin <- as.integer(floor(julian(as.POSIXlt('2012-01-01'))))
df$date2j <- as.integer(floor(julian((as.POSIXlt(df$date))))) - origin
date_excl <- as.integer(floor(julian(as.POSIXlt('2013-12-25')))) - origin
df <- df[df$date2j != date_excl, ]
df_fitted <- data.frame(date2j=c(), sno=c(), ino=c())
rng <- 1:nrow(store_item_nbrs)
for (i in rng) {
  ino <- store_item_nbrs[i, "item_nbr"]
  sno <- store_item_nbrs[i, "store_nbr"]
  df0 <- subset(df, store_nbr == sno & item_nbr == ino)
  df0.ppr <- ppr(log1p ~ date2j, data = df0, nterms=3, max.terms=5)
  df1 <- data.frame(date2j=0:1034, store_nbr=sno, item_nbr=ino)
  df1$ppr_fitted <- predict(df0.ppr, df1)
  df_fitted <- rbind(df_fitted, df1)
}
write.table(df_fitted, "model/baseline.csv", quote=F, col.names=T, append=F, sep=",", row.names=F)
q("no")
