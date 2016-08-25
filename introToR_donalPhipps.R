# Basics
	# Creating variables
	x<-"hello, world!"
	x
	print(x)

	# Working directory
	getwd()
	setwd("/Users/donalp/Dropbox/3-Work/Training/Software stuff/Coding/R/JLRDX GA/Introduction to R")
	list.files()
  
  # Data types
    # Numeric data types  
    test<-1
    test2<-c(1,2,3,4,5,6,7)
    mean(test2)
    median(test2)
    test3<-c(1:7)
    test2==test3
    test2*test3

    # Character class
      x<-c("hello","world")
      class(x)
      x[1]
      paste(x[1], x[2], "from London.")

    # Booleans / logicals
    bool<-c(TRUE,FALSE,FALSE,TRUE,FALSE,FALSE,TRUE)
    bool

    # Matrix
    mat<-matrix(1:100, ncol=10, nrow=10)
    mat
    
    mat[ 1, ]
    mat[ , 1 ]

    # Data frames
      # Recall our test2 vector of numbers, and our bool vector of Booleans
      test2
      bool
      test2[bool]
      
      comb<-data.frame(test2,bool)
      mat.frame<-data.frame(mat)
      mat.frame$X1
      mat.frame$X4
      
      # combining data types, not possible in matrices
      mat.frame<-cbind(mat.frame,c("one","two","three","four","five","six","seven","eight","nine","ten"))
      names(mat.frame)<-c("ones","tens","twenties","thirties","fourties","fifties","sixties","seventies","eighties","nineties", "words")
      #accessing dataframe columns by colnames
      mat.frame$twenties
      mat.frame[1:3,"thirties"]
      # simple arithmetic
      mat.frame$tens * mat.frame$twenties
      
      # Lots of data
      biggie1<-rnorm(100000, 5, 5)
      biggie2<-rnorm(100000, 5, 100)
      mean(biggie1)
      big.frame<-data.frame(cbind(biggie1,biggie2))
      ggplot(big.frame,aes(x=biggie1,y=biggie2)) + geom_point(alpha=0.04)

  # Reading data
    GAreport<-read.csv("data/masterTable.csv", stringsAsFactors=FALSE) # reads in some example data from the GA API
    head(GAreport)

    # Removing unwanted columns
    GAreport<-GAreport[, -(1:2)]
    
    # Simple data examinations made easy
    summary(GAreport)
    quantile(GAreport$sessions)
    str(GAreport)

    plot(GAreport$sessions, GAreport$ratio)
        
    hist(GAreport$sessions, main="Histogram of all sessions", xlab="Sessions")
    abline(v=mean(GAreport$sessions), col="blue")
    abline(v=median(GAreport$sessions),col="red")
  
  # nicer reports
  library(ggplot2)
  qplot(GAreport$sessions, main="Histogram of all sessions", xlab="Sessions")
  
  # glimpse at improved statistical power
  # first - refresher on data types (exaplained verbally)
  library(dplyr)
  library(plyr)
  GAreport2<-filter(GAreport, country=="BranX: China")
  

  g<-ggplot(GAreport2, aes(x=date, y=sessions)) + geom_line() + ggtitle("Land Rover China sessions by date")
  g
  g + geom_smooth()
  
  # Super-simple regression model - do sessions increase over time?
  quickModel<-lm(sessions ~ date, GAreport2)
  summary(quickModel)
  # Plotting a linear model
  g + geom_smooth(method = "lm", se = FALSE)
  
