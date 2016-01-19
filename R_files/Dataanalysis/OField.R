testing=T
if (testing){
  userprojectfolder=datapath
  IF <- read.csv(paste(userprojectfolder,"8_computerisable_files/initial_form.csv", sep="/"), sep=";",colClasses=c(NA, NA, "NULL"))
  Initiation_form = as.data.frame(t(IF[-1]))
  names(Initiation_form)= IF[,1]
  Initiation_form$projectlagesoid
  
  source("Rfiles/get_mouse_data.R")
  OFdata=alldatasum
}


##get data


## get group name (work only if grouped by strain)
grouping =as.character(OFdata$animalID)
# for (i in c(1: length(grouping))){
#   grouping [i]= as.character(animalsproj$strain [animalsproj$`animal-ID`== grouping [i]])
# }

for (i in c(1: length(grouping))){
  grouping [i]= as.character(animalsproj$strain [animalsproj$animal.ID== grouping [i]])
}
OFdata$group= factor(grouping)

## set variables
OFdata$distancetraveled=  OFdata$`Zone: Zone 2 Tracklength (cm)`+ OFdata$`Zone: Zone 1 Tracklength (cm)`
OFdata$exptype=factor(gsub("\\..*","",OFdata$`Experiment No.`))
OFdata$percentincenter=100*OFdata$`Zone: Zone 2 Duration (s)`/(OFdata$`Zone: Zone 2 Duration (s)`+OFdata$`Zone: Zone 1 Duration (s)`)
#correcting latency to NA if no entry
OFdata$`Zone: Zone 2 Visit latency (s)`= ifelse(OFdata$`Zone: Zone 2 Visits`<1,NA,OFdata$`Zone: Zone 2 Visit latency (s)`)


##start plotting
plotdata= OFdata
ylab = "distance traveled"
title= paste0("locomotor activity")

analysis= aes(x=exptype ,y= distancetraveled, fill=group)

# plotdatag =group_by(plotdata, group,exptype)
# n = summarise(plotdatag,
#               count = n())


boxpl_OF(OFdata,aes(x=exptype ,y= distancetraveled, fill=group),"distance traveled",paste0("locomotor activity"))
boxpl_OF(OFdata,aes(x=exptype ,y= percentincenter, fill=group),"Percent time in center",paste0("anxiety score in Open Field"))
boxpl_OF(OFdata,aes(x=exptype ,y= `Zone: Zone 2 Visits`, fill=group),"number of visits of center",paste0("anxiety score in Open Field 2"))
boxpl_OF(OFdata,aes(x=exptype ,y= `Zone: Zone 1 Visits`, fill=group),"number of visits of the periphery",paste0("anxiety score in Open Field 3"))
boxpl_OF(OFdata,aes(x=exptype ,y= `Zone: Zone 2 Visit latency (s)`, fill=group),"latency until first visit in center",paste0("anxiety score in Open Field 4"))


p=ggplot(plotdata, analysis)
plot=p+ geom_boxplot(position=position_dodge(width=0.9))+ labs(x="experiment number",y=ylab, title=title)+
  ylim(-60, 3000)+
  #scale_fill_grey(start = 0.9, end = 0.9)+ ##allow good bw prints
  stat_summary( fun.data = fun_length, geom = "text", position=position_dodge(width=0.9))

                
 
stat_summary(aes(x=factor(cyl), fill = factor(vs)), position=position_dodge(.9),
             fun.data = fun_length, geom = "text",
             vjust = +1, size = 4)
  #geom_text(aes(x=group, fill=exptype,y= -5,label=paste("n =", count)), data=n, size=5) 
plot
#class(OFdata$`Experiment No.`)
