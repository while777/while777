
library(foreach)
library(splines)

library(gam)
require(ggplot2)

SA<-read.table('SA.txt', sep=",", header=T, row.names=1)

#1
SAGam <- gam(chd ~ s(sbp,4) + s(tobacco,4) + s(ldl,4) + s(adiposity, 4) + s(typea, 4) +
               s(obesity, 4) + s(alcohol, 4) + s(age, 4) + famhist,data=SA,family=binomial)
par(mfrow=c(3,3))
plot(SAGam)


###2
###Q6.2
###For fast programming we rely on the cv.glm function in the
###boot library.

library(boot)

df <- seq(1,3,by=0.1)

#Using cross-validation to select the df-parameter. The conclusion is  
#dependent upon the run (and random devisions of the dataset), but in a couple of runs 
#it seems to be df in the range 3-5

SAGamCv <- numeric(length(df))

for(i in seq(along=df))
{
  formGam <- as.formula(paste("chd~famhist+", paste("s(",names(SA[1,1:9])[-5], ",df=", df[i], ")",sep="",collapse="+")))
  SAGam <- gam(formGam,family=binomial,data=SA)
  tmp  <- cv.glm(SA,SAGam, zeroOneCost,7)
  set.seed(tmp$seed)
  SAGamCv[i] <- tmp$delta[1]
}

qplot(df,SAGamCv,geom="line")


###For a comparision, we can also use a (pseudo) AIC criteria. It is pseudo because
###there is a smoother involved and we use the effective degrees of freedom

SAGamAic <- numeric(length(df))
for(i in seq(along=df)){
  formGam <- as.formula(paste("chd~famhist+",paste("s(",names(SA[1,1:9])[-5], ",df=", df[i], ")",sep="",collapse="+")))
  SAGam <- gam(formGam,family=binomial,data=SA)
  SAGamAic[i]  <- SAGam$aic
}

qplot(df,SAGamAic,geom="line")

###Q6.3


for(i in seq(along=df)){
  formGam <- as.formula(paste("chd~famhist+",paste("s(",names(SA[1,1:9])[-5], ",df=", df[i], ")",sep="",collapse="+")))
  SAGam <- gam(formGam,family=binomial,data=SA)
  tmp  <- cv.glm(SA,SAGam,likelihoodCost,7)
  set.seed(tmp$seed)
  SAGamCv[i] <- tmp$delta[1]
}

qplot(df,SAGamCv,geom="line")


