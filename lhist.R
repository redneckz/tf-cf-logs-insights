lhist <- function(data, buckets, ...) {
  data.hist <- hist(data, breaks=buckets, plot=FALSE)
  data.bars <- barplot(data.hist$count, log="y", col="white", names.arg=buckets[-1], ...)
  text(data.bars, data.hist$counts, labels=data.hist$counts, pos=1)
}