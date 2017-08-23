load_spam_data <- function(trainingScale=TRUE,responseScale=TRUE){ 
  #
  # R code to load in the spam data set from the book ESLII
  #
  # Output:
  #
  # res: list of data frames XT
  #
  # 
  # Please send comments and especially bug reports to the
  # above email address.
  # 
  #-----

  X      = read.table("spam.data")
  tt     = read.table("spam.traintest")

  # separate into training/testing sets
  # (ESLII on epage 319 says that we have 3065 training instances)
  # 
  XTraining = subset( X, tt==0 )
  p = dim(XTraining)[2]-1
  
  XTesting  = subset( X, tt==1 ) # (ESLII on epage 319 says that we have 1536 testing instances)

  #
  # Sometime data is processed and stored in a certain order.  When doing cross validation
  # on such data sets we don't want to bias our results if we grab the first or the last samples.
  # Thus we randomize the order of the rows in the Training data frame to make sure that each
  # cross validation training/testing set is as random as possible.
  # 
  if( FALSE ){
    nSamples = dim(XTraining)[1] 
    inds = sample( 1:nSamples, nSamples )
    XTraining = XTraining[inds,]
  }

  #
  # In reality we have to estimate everything based on the training data only
  # Thus here we estimate the predictor statistics using the training set
  # and then scale the testing set by the same statistics
  # 
  if( trainingScale ){
    X = XTraining 
    if( responseScale ){
      meanV58 = mean(X$V58) 
      v58 = X$V58 - meanV58 
    }else{
      v58 = X$V58 
    }
    X$V58 = NULL
    X = scale(X, TRUE, TRUE)
    means = attr(X,"scaled:center")
    stds = attr(X,"scaled:scale")
    Xf = data.frame(X)
    Xf$V58 = v58
    XTraining = Xf

    # scale the testing predictors by the same amounts:
    # 
    DCVTest  = XTesting
    if( responseScale ){
      v58Test = DCVTest$V58 - meanV58
    }else{
      v58Test = DCVTest$V58 # in physical units (not mean adjusted)
    }
    DCVTest$V58 = NULL 
    DCVTest  = t( apply( DCVTest, 1, '-', means ) ) 
    DCVTest  = t( apply( DCVTest, 1, '/', stds ) ) 
    DCVTestb = cbind( DCVTest, v58Test ) # append back on the response
    DCVTestf = data.frame( DCVTestb ) # a data frame containing all scaled variables of interest
    names(DCVTestf)[p+1] = "V58" # fix the name of the response
    XTesting = DCVTestf
  }

  # Many algorithms wont do well if the data is presented all of one class and
  # then all of another class thus we permute our data frames :
  #
  XTraining = XTraining[sample(nrow(XTraining)),]
  XTesting  = XTesting[sample(nrow(XTesting)),]

  # Read in the list of s(pam)words (and delete garbage characters):
  # 
  spam_words = read.table("spambase.names",skip=33,sep=":",comment.char="|",stringsAsFactors=F)
  spam_words = spam_words[[1]]
  for( si in 1:length(spam_words) ){
    spam_words[si] = sub( "word_freq_", "", spam_words[si] )
    spam_words[si] = sub( "char_freq_", "", spam_words[si] )
  }

  return( list( XTraining, XTesting, spam_words ) ) 
}

