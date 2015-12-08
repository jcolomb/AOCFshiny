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

Dirname=list.dirs(path = filepath,recursive = F, full.names=F)


## testing that the number of files is correct.

## TODO modify for other element than test (and training) in folder name

path2=paste0(Dirname[grepl("test" ,Dirname)],"/")
Filesname2= Filesname[grepl(path2 ,Filesname)]
Nanimals=length(Filesname2)/length(path2) 
if (!isTRUE(Nanimals %%1==0)){
  print("Warnings: the number of files in the different test folders is different. 
        Please exclude the files if one animal died during the experiment or add the missing file is you forgot to export the data.
        You will need to run the datacheck again to see if training folders are good.")
}else{
  path3=paste0(Dirname[!grepl("test" ,Dirname)],"/") 
  for ( j in c(1: length(path3))){
    Filesname3= Filesname[grepl(path3 ,Filesname)]
    Ntraining=length(Filesname3)/ Nanimals
    if (!isTRUE(Ntraining %%1==0)){
      print(paste0("the number of files in the folder ",path3, " may be incorrect, it this is a training folder."))
    }
    if (isTRUE(exists("overnt") && Ntraining != overnt )){
      print("the number of training between training directories (=directories wich name do not countain <test>) is inconsistent. Did you not forget to export some files? 
            Or maybe one test folder did not have <test> in its name?")
    }
    overnt=Ntraining
  }
}

## testing that filenames correspond to data inside and average speed is not 0

for(i in c(1:length(Filesname))){
  #print(i)
  
  filename= paste(filepath,"/", Filesname[i], sep="")
  testdata=t(readxl::read_excel(filename, sheet = 1, col_names =FALSE))
  Dstart=match(Firstlinedata , testdata[1,])
  Dend=match(lastlinedata , testdata[1,])
  
  testdata= as.data.frame(testdata)
  
  ## testing that filename and two animal ID columns are consistant
  a=testdata[-1,(testdata[1,]==animalID1 & !is.na(testdata[1,])) ]
  a2=ifelse(all(is.na(a)),NA,gsub("\\..*","",as.character(na.omit(a)) ))
  if(!isTRUE(grepl(a2,filename)) )  {print(paste0("In file:",filename,"animal ID in:",animalID1,"does not correspond to file name"))}
  
  b=testdata[-1,(testdata[1,]==animalID2 & !is.na(testdata[1,])) ]
  b2=ifelse(all(is.na(a)),NA,gsub("\\..*","",as.character(na.omit(b))))
  if(!isTRUE(grepl(b2,filename))){print(paste0("In file:",filename,"animal ID in:",animalID2,"does not correspond to file name"))}
  
  if ( !isTRUE(a2 == b2)) {print(paste0("In file:",filename,"animal ID in:",animalID1,"does not correspond to animal ID in:",animalID2))}
  
  ## testing that tracking was working: checking that aver. speed is not 0
  X <- testdata[match("Avg. velocity", as.character(testdata[,Dstart+1]) ) ,Dend]
  if (as.numeric(as.character(X))==0){print(paste0("The tracking of the animal ",filename," seems to be incorrect. Please check."))}
  
}

