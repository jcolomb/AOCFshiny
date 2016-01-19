# testing EZM data
testing =F
if (testing){
  concdata = read.csv("D:/Development_r/automaticreport.1/datafortest/EZM.csv")
  takeonlysum = "Sum"
  library(chron)
}

if (testing){
  datapath="Y:/AOCF-User Projects/1412_Rosenmund_VGlut1-KI"
  
  source("Rfiles/FUNCTIONs.R")
  
  userprojectfolder=datapath
  IF <- read.csv(paste(userprojectfolder,"8_computerisable_files/initial_form.csv", sep="/"), sep=";",colClasses=c(NA, NA, "NULL"))
  Initiation_form = as.data.frame(t(IF[-1]))
  names(Initiation_form)= IF[,1]
  Initiation_form$projectlagesoid
  
  source("Rfiles/get_mouse_data.R")
  
}

if (testing){
data= concdata[concdata$Interval.summary_No. == takeonlysum,]
data$exp_day=data$Interval.summary_Date

data=addanimalinfotodata(data)
}

data$Interval.summary_Run.time=times(as.character(data$Interval.summary_Run.time))


#calculate percent time in open arms
TimeOpen= (data$Zone..Open.W_Duration..s.+ data$Zone..Open.E_Duration..s.)
TIMEClose=(data$Zone..Closed.S_Duration..s.+ data$Zone..Closed.N_Duration..s.)
TimeOpen+ TIMEClose
data$percentopen= 100*TimeOpen/ (TimeOpen+ TIMEClose)

#length of trial in minutes
LOT= minutes(data$Interval.summary_Run.time)

#total distance traveled per min
data$Dist_trav_permin=  data$Interval.summary_Track.length..cm./LOT

#number of entries in open arm, per min
data$Entriesinopen_permin=(data$Zone..Open.E_Visits+data$Zone..Open.W_Visits)/LOT

##plot results
data$x=data$genotype
data$fill= data$agecat
boxpl_OF(data,aes(x=x ,y= 100-percentopen, fill=fill),"Percentage time in the closed part",paste0("Elevated zero maze: anxiety score"),ymin=100)
boxpl_OF(data,aes(x=x ,y= Entriesinopen_permin, fill=fill),"Number of entries in open arm per minute",paste0("Elevated zero maze: courage score"))
boxpl_OF(data,aes(x=x ,y= Dist_trav_permin, fill=fill),"Distance traveled per minutes in the whole maze",paste0("Elevated zero maze: acticvity"))
