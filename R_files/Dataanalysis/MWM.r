## this code is analysing MWM data, works if the platform is on the SW quadrant

##get mouse data
testing=T
datapath="Y:/AOCF-User Projects/1412_Rosenmund_VGlut1-KI"

if (testing){
  library(xtable)
  options(xtable.comment = FALSE)
  library(rmarkdown)
  source("Rfiles/FUNCTIONs.R")
  
  userprojectfolder=datapath
  IF <- read.csv(paste(userprojectfolder,"8_computerisable_files/initial_form.csv", sep="/"), sep=";",colClasses=c(NA, NA, "NULL"))
  Initiation_form = as.data.frame(t(IF[-1]))
  names(Initiation_form)= IF[,1]
  Initiation_form$projectlagesoid
  
  source("Rfiles/get_mouse_data.R")
  
}

data= read.csv("C:/Users/AG_Winter/Desktop/20150706_MWM/concenatedfile_onlysum.csv", sep=";")

##
#get group data in the data file
grouping =as.character(data$animalID)

for (i in c(1: length(grouping))){
  grouping [i]= as.character(animalsproj$strain [animalsproj$animal.ID== grouping [i]])
}
data$group= factor(grouping)

###data analysis:

###latency to the platform
data$latency= data$Zone..Target.Visit.latency..s.
data$Zone..Target.Duration..s. == 0
data$latency[data$latency == 0 & data$Zone..Target.Duration..s. == 0]= NA
#add one second between mouse on water and click start
data$latency =data$latency+1

###latency to the quadrant
data$latencyQ= data$Zone..SW.Visit.latency..s.
#get NA when never reached
data$latencyQ[data$latencyQ == 0 & data$Zone..SW.Duration..s.==0]= NA
# get latency to target zone if smaller#
for (i in c(1: nrow(data))){
  data$latencyQ[i]= min (data$latencyQ[i],data$latency[i], na.rm=TRUE)
}


###proportion time spent in the target quadrant
data$SWQtime = data$Zone..SW.Duration..s.+data$Zone..Target.Duration..s.
data$propright = 100*data$SWQtime/(data$SWQtime+data$Zone..SE.Duration..s.+data$Zone..NW.Duration..s.+data$Zone..NE.Duration..s.)


###Start plotting

#subset training data
dataori=data
data = dataori[grepl("training",dataori$Short.description),]

boxpl_OF(data,aes(x=Short.description ,y= latency, fill=group),"latency to enter platform [s]",paste0("latency to platform"))
boxpl_OF(data,aes(x=Short.description ,y= latencyQ, fill=group),"latency to enter quadrant [s]",paste0("latency to quadrant"))
boxpl_OF(data,aes(x=Short.description ,y= propright, fill=group),"proportion of time in SW quadrant",paste0("time on right quadrant"))

data = dataori[grepl("test",dataori$Short.description),]

boxpl_OF(data,aes(x=Short.description ,y= latency, fill=group),"latency to enter platform [s]",paste0("latency to platform"))
boxpl_OF(data,aes(x=Short.description ,y= latencyQ, fill=group),"latency to enter quadrant [s]",paste0("latency to quadrant"))
boxpl_OF(data,aes(x=Short.description ,y= propright, fill=group),"proportion of time in SW quadrant",paste0("time on right quadrant"))
