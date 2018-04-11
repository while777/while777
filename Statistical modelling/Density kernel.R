library(MASS)


zip<-read.table("zip.train", sep="", header=F)
zipp<-read.table("zip.test", sep="", header=F)


for(i in 20)
{
  d1<-density(zip$V2[zip$V1==0],kernel="gaussian", width = i, n=7291)
  d2<-density(zip$V2[zip$V1==1],kernel="gaussian", width = i, n=7291)
  d3<-density(zip$V2[zip$V1==2],kernel="gaussian", width = i, n=7291)
  d4<-density(zip$V2[zip$V1==3],kernel="gaussian", width = i, n=7291)
  d5<-density(zip$V2[zip$V1==4],kernel="gaussian", width = i, n=7291)
  d6<-density(zip$V2[zip$V1==5],kernel="gaussian", width = i, n=7291)
  d7<-density(zip$V2[zip$V1==6],kernel="gaussian", width = i, n=7291)
  d8<-density(zip$V2[zip$V1==7],kernel="gaussian", width = i, n=7291)
  d9<-density(zip$V2[zip$V1==8],kernel="gaussian", width = i, n=7291)
  d10<-density(zip$V2[zip$V1==9],kernel="gaussian", width = i, n=7291)
  
  
  post<-sum(zip$V1==0)*d1$y+sum(zip$V1==1)*d2$y+sum(zip$V1==2)*d3$y+sum(zip$V1==3)*d4$y+sum(zip$V1==4)*d5$y+sum(zip$V1==5)*d6$y+sum(zip$V1==6)*d7$y+sum(zip$V1==7)*d8$y+sum(zip$V1==8)*d9$y+sum(zip$V1==9)*d10$y
  post0<-sum(zip$V1==0)*d1$y/post
  post1<-sum(zip$V1==1)*d2$y/post
  post2<-sum(zip$V1==2)*d3$y/post
  post3<-sum(zip$V1==3)*d4$y/post
  post4<-sum(zip$V1==4)*d5$y/post
  post5<-sum(zip$V1==5)*d6$y/post
  post6<-sum(zip$V1==6)*d7$y/post
  post7<-sum(zip$V1==7)*d8$y/post
  post8<-sum(zip$V1==8)*d9$y/post
  post9<-sum(zip$V1==9)*d10$y/post
  
  result<-c()
  for (i in 1:7291)
  {
    
    result[i]<-post1[i]+2*post2[i]+3*post3[i]+4*post4[i]+5*post5[i]+6*post6[i]+7*post7[i]+8*post8[i]+9*post9[i]
  }
  result000<-c()
  for (i in 1:7291)
  {
    
    result000[i]<-(zip$V1[i]-result[i])^2
    
  }
  
  result111<-colMeans(data.frame(result000))
  
}



for(i in 20)
{
  d1<-density(zipp$V2[zip$V1==0],kernel="gaussian", width = i, n=2007)
  d2<-density(zip$V2[zip$V1==1],kernel="gaussian", width = i, n=2007)
  d3<-density(zip$V2[zip$V1==2],kernel="gaussian", width = i, n=2007)
  d4<-density(zip$V2[zip$V1==3],kernel="gaussian", width = i, n=2007)
  d5<-density(zip$V2[zip$V1==4],kernel="gaussian", width = i, n=2007)
  d6<-density(zip$V2[zip$V1==5],kernel="gaussian", width = i, n=2007)
  d7<-density(zip$V2[zip$V1==6],kernel="gaussian", width = i, n=2007)
  d8<-density(zip$V2[zip$V1==7],kernel="gaussian", width = i, n=2007)
  d9<-density(zip$V2[zip$V1==8],kernel="gaussian", width = i, n=2007)
  d10<-density(zip$V2[zip$V1==9],kernel="gaussian", width = i, n=2007)
  
  
  post<-sum(zipp$V1==0)*d1$y+sum(zipp$V1==1)*d2$y+sum(zipp$V1==2)*d3$y+sum(zipp$V1==3)*d4$y+sum(zipp$V1==4)*d5$y+sum(zipp$V1==5)*d6$y+sum(zipp$V1==6)*d7$y+sum(zipp$V1==7)*d8$y+sum(zipp$V1==8)*d9$y+sum(zipp$V1==9)*d10$y
  post0<-sum(zipp$V1==0)*d1$y/post
  post1<-sum(zipp$V1==1)*d2$y/post
  post2<-sum(zipp$V1==2)*d3$y/post
  post3<-sum(zipp$V1==3)*d4$y/post
  post4<-sum(zipp$V1==4)*d5$y/post
  post5<-sum(zipp$V1==5)*d6$y/post
  post6<-sum(zipp$V1==6)*d7$y/post
  post7<-sum(zipp$V1==7)*d8$y/post
  post8<-sum(zipp$V1==8)*d9$y/post
  post9<-sum(zipp$V1==9)*d10$y/post
  
  
  outcome<-c()
  for (i in 1:2007)
  {
    
    outcome[i]<-post1[i]+2*post2[i]+3*post3[i]+4*post4[i]+5*post5[i]+6*post6[i]+7*post7[i]+8*post8[i]+9*post9[i]
  }
  outcome000<-c()
  for (i in 1:2007)
  {
    
    outcome000[i]<-(zipp$V1[i]-outcome[i])^2
      
  }
  
  outcome111<-colMeans(data.frame(outcome000))
 

  
}





#prior = c(post0, post1, post2, post3, post4, post5, post6, post7, post8, post9)
#r <- lda(formula = zip$V1~., data = zip, prior = c(post0, post1, post2, post3, post4, post5, post6, post7, post8, post9), CV=TRUE)


#SA<-read.table('SA.txt',sep=",",header=T)
#d1<-density(sbp[chd==1],kernel="gaussian",n=300,from=101,to=218)
#d2<-density(sbp[chd==0],kernel="gaussian",n=300,from=101,to=218)
#post<-sum(chd==1)*d1$y+sum(chd==0)*d2$y
#post<-sum(chd==1)*d1$y/post


