

library(MASS)

st <- Boston


# a)

summary(lm(crim ~ zn, data = st) )
summary(lm(crim ~ indus, data = st))
summary(lm(crim ~ chas, data = st))
summary(lm(crim ~ nox, data = st))
summary(lm(crim ~ rm, data = st))
summary(lm(crim ~ age, data = st))
summary(lm(crim ~ dis, data = st))
summary(lm(crim ~ rad, data = st))
summary(lm(crim ~ tax, data =st))
summary(lm(crim ~ ptratio, data = st))
summary(lm(crim ~ black, data = st))
summary(lm(crim ~ lstat, data = st))
summary(lm(crim ~ medv, data = st))
plot(crim ~ . - crim, data = st)


# b)

summary(lm(crim ~ . - crim, data = st))




# c)
coff <- lm(crim ~ zn, data = st)$coefficients[2]
coff<- append(coff, lm(crim ~ indus, data = st)$coefficients[2])
coff <- append(coff, lm(crim ~ chas, data = st)$coefficients[2])
coff <- append(coff, lm(crim ~ nox, data = st)$coefficients[2])
coff <- append(coff, lm(crim ~ rm, data = st)$coefficients[2])
coff <- append(coff, lm(crim ~ age, data = st)$coefficients[2])
coff <- append(coff, lm(crim ~ dis, data = st)$coefficients[2])
coff <- append(coff, lm(crim ~ rad, data = st)$coefficients[2])
coff <- append(coff, lm(crim ~ tax, data = st)$coefficients[2])
coff <- append(coff, lm(crim ~ ptratio, data = st)$coefficients[2])
coff <- append(coff, lm(crim ~ black, data = st)$coefficients[2])
coff <- append(coff, lm(crim ~ lstat, data = st)$coefficients[2])
coff <- append(coff, lm(crim ~ medv, data = st)$coefficients[2])
coffss <- (lm(crim ~ . - crim, data = st))

coffss$coefficients[2:14]

plot(coff, coffss$coefficients[2:14], main = "Univariate vs. Multiple Regression Coefficients", xlab = "Univariate", ylab = "Multiple")


# d)

summary(lm(crim ~ poly(zn, 3, raw=TRUE), data = st ))
summary(lm(crim ~ poly(indus, 3, raw=TRUE), data = st ))
summary(lm(crim ~ poly(chas, 3, raw=TRUE), data = st ))
summary(lm(crim ~ poly(nox, 3, raw=TRUE), data = st ))
summary(lm(crim ~ poly(rm, 3, raw=TRUE), data = st ))
summary(lm(crim ~ poly(age, 3, raw=TRUE), data = st ))
summary(lm(crim ~ poly(dis, 3, raw=TRUE), data = st ))
summary(lm(crim ~ poly(rad, 3, raw=TRUE), data = st ))
summary(lm(crim ~ poly(tax, 3, raw=TRUE), data = st ))
summary(lm(crim ~ poly(ptratio, 3, raw=TRUE), data = st ))
summary(lm(crim ~ poly(black, 3, raw=TRUE), data = st ))
summary(lm(crim ~ poly(lstat, 3, raw=TRUE), data = st ))
summary(lm(crim ~ poly(medv, 3, raw=TRUE), data = st ))









