##concantenator
testing=F
if(testing){
  filepath="datafortest/20150710_Rosenmund_VGlut1-KO_MWM_-1d/"
  Filesname=list.files(path = filepath, pattern = NULL, all.files = FALSE,
                       full.names = FALSE, recursive = TRUE,
                       ignore.case = FALSE, include.dirs = FALSE, no.. = FALSE)
  
  
  Filesname
  substrRight <- function(x, n){
    substr(x, nchar(x)-n+1, nchar(x))
  }
  Filesname = Filesname["xls" == substrRight(Filesname, 3) ]
  Filesname = Filesname[!grepl("all",Filesname)]
  #length(Filesname)
  Filesname = Filesname[grepl("animal",Filesname)]
  Firstlinedata ="Interval summary"
  lastlinedata ="Sum"
  animalID1= "Animal name:"
  animalID2= "Animal No.:"
  animalID1= "Animal No.:"
}

alldata=c()

for(i in c(1:length(Filesname))){
  #print(i)
  filename= paste(filepath,"/", Filesname[i], sep="")
  #set metadata size
  testdata=t(readxl::read_excel(filename, sheet = 1, col_names =FALSE))
  Dstart=match(Firstlinedata , testdata[1,])
  
  # set data size
  Dend=min(match(lastlinedata , testdata[1,]))
  #print(Dend)
  Ldata=Dend-(Dstart+1)
  
  #get metadata:
  if (Dstart>2){
    metadata=testdata[c(1,3),c(1:(Dstart-2))]
    addcolumns= as.data.frame(t(matrix(rep(metadata[2,],Ldata),Dstart-2,Ldata)))
    
    names(addcolumns)=gsub("\\:*","",metadata[1,])
    addcolumns=addcolumns[,-match("Date/Time",names(addcolumns))]
  }else{addcolumns=NULL}
  
  
  
  #get animal ID, excluding the part after "." if it was entered as a number
  #animal_ID=gsub("\\..*","",as.character(readxl::read_excel(filename, sheet = 1, col_names =FALSE)[7,3]))
  
  #get only the data, read again to get date format correctly
  #data=readxl::read_excel(filename, sheet = 1, skip=(Dstart+1), col_names =FALSE)[1:Ldata,]
  data=readxl::read_excel(filename, sheet = 1, skip=(Dstart), col_names =TRUE)[1:Ldata,]
  #data=as.data.frame(t(testdata[,(Dstart+2):Dend]))
  
  # get right names
  zone=testdata[,Dstart]
  for (i in c(1:length(zone))){
    zone[i]=ifelse(is.na(zone[i]), zone[i-1], zone[i])
  }
  names(data)= paste(zone,testdata[,Dstart+1], sep= "_")
  
  
  
  ##put everything together and get out the empty row
  if (is.null(addcolumns)){
    data2= data.frame(data)
    data2$`Experiment_Time`=format(data2$`Experiment_Time`, format="%H:%M:%S")
  }else{
    data2= cbind(addcolumns,data)[-(Ldata-1),]
    # add data to the sum row (date-time)
    data2[(Ldata-1),]= ifelse(is.na(data2[(Ldata-1),]), data2[(Ldata-2),],data2[(Ldata-1),])
    data2$`Interval summary_Time`=format(data2$`Interval summary_Time`, format="%H:%M:%S")
    data2$`Interval summary_Run time`=format(data2$`Interval summary_Run time`, format="%H:%M:%S")
  }
    
  
  
  
  
  # debug if rbind is not working (add new columns with NAs to the small dataset)
  M=min(length(names(data2)),length(names(alldata)))
  L=ifelse(length(names(alldata))==0,0, length(names(data2))-length(names(alldata)))
  
  if (L>0 ){
    Nnames=names(merge(data2, alldata))
    alldata[,M+c(1:L)]=NA
    names(alldata)=Nnames
  }
  if (L<0 ){
    Nnames=names(merge(data2, alldata))
    data2[,M+c(1:(-L))]=NA
    names(data2)=Nnames
  }
  
  
  if(!all(names(data2)== names(alldata))){
    message("error")
    print(i)
  }  
  
  
  #concatenate
  alldata=rbind(alldata,data2)
  
}

concdata=alldata[rowSums(is.na(alldata)) < length(alldata), ]
#getting an animalID column
concdata$animalID =concdata[,names(concdata)==gsub("\\:*","",animalID1)]
#names(concdata)[names(concdata)==gsub("\\:*","",animalID1)] = "animalID"
# making column names usable
concdata=data.frame(concdata)
