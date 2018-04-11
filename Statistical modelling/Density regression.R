pima <- read.table('pama.txt',sep = "", header=T)
summary(pima)
sort(pima$blood)
#NA: not aavailable, NAN:not a number,null:empty
pima$blood[pima$blood == 0] <- NA
# set zero values in the variable blood to "NA", where
# "==" means "equal" in R
pima$glucose[pima$glucose == 0] <- NA
# set zero values in the variable glucose to "NA"
pima$triceps[pima$triceps == 0] <- NA
# set zero values in the variable triceps to "NA"
pima$insulin[pima$insulin == 0] <- NA
# set zero values in the variable insulin to "NA"
pima$bmi[pima$bmi == 0] <- NA
# set zero values in the variable bmi to "NA"

pima$test <- factor(pima$test)
#summary(pima$test)
levels(pima$test)
levels(pima$test) <- c("negative", "positiv")
#levels(pima$test)

plot(density(pima$blood, na.rm=TRUE))
plot(sort(pima$blood), pch=".")

par(mfrow = c(1, 3)) 
hist(pima$blood)
plot(density(pima$blood, na.rm=TRUE))
plot(sort(pima$blood), pch=".")
par(mfrow = c(1, 1)) 

plot(pedigree ~ blood, pima)
plot(pedigree ~ test, pima)

