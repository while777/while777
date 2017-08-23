kNN<-function(x,y,new,k){
	x<-as.matrix(x)
	new<-as.matrix(new)
	
	n<-nrow(x)
	p<-ncol(x)
	m<-nrow(new)
	
	predy<-integer(m)
	for (i in 1:m){
		 x0<-matrix(new[i,],nrow=n,ncol=p,byrow=T)
		 d<-rowSums((x0-x)^2)
		 d2<-sort(d,index.return=T)
		 AvgLabel<-mean(y[d2$ix[1:k]])
		 if (AvgLabel>=0.5)
		    predy[i]<-1
	}
	
	return(predy)
	
}