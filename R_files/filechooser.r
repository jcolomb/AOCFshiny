## chose only file ending with "xls"
substrRight <- function(x, n){
  substr(x, nchar(x)-n+1, nchar(x))
}

#Filesname = Filesname[END == substrRight(Filesname, 4) ]
Filesname = Filesname[!grepl(NEVERTHERE,Filesname)]

Filesname = Filesname[grepl(NECESSARY,Filesname)]

filechoosen=Filesname