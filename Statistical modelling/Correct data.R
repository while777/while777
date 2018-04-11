
con <- file("D:\\RStudio\\daltons.txt", "r", blocking = FALSE)
txt<-readLines(con)
I <- grepl("^%", txt)
# and throw them out
(dat <- txt[!I])
fieldList <- strsplit(dat, split = ",")

assignFields <- function(x){
  out <- character(3)
  # get names
  i <- grepl("[[:alpha:]]",x)
  out[1] <- x[i]
  # get birth date (if any)
  i <- which(as.numeric(x) < 1890)
  out[2] <- ifelse(length(i)>0, x[i], NA)
  # get death date (if any)
  i <- which(as.numeric(x) > 1890)
  out[3] <- ifelse(length(i)>0, x[i], NA)
  out
}
standardFields <- lapply(fieldList, assignFields)

#library(parallel)
#cluster <- makeCluster(4)
#standardFields <- parLapply(cl=cluster, fieldList, assignFields)
#stopCluster(cl)
M <- matrix(
  unlist(standardFields)
  , nrow=length(standardFields)
  , byrow=TRUE)
colnames(M) <- c("name","birth","death")
daltons <- as.data.frame(M, stringsAsFactors=FALSE)
daltons$birth <- as.numeric(daltons$birth)
daltons$death <- as.numeric(daltons$death)
#daltons = transform( daltons, birth = as.numeric(birth), death = as.numeric(death))

