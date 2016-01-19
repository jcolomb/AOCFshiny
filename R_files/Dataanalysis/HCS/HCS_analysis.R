library(readxl)

## get the experiment plan description, export the path to the data, the ID of the mouse used
## faked results:
Mouse_used = data.frame (ID = c(13,21), Group= c("WT", "group1"))
datapath= ".\\testdata\\HCS\\"
testdata1="Pruess-HCS-271114-ID29-hour.xlsx"

#file.exists(paste(datapath,testdata1,sep=""))
#file.choose()


data=read_excel(paste(datapath,testdata1,sep=""), sheet = 1)
           