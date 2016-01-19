
TESTING= T
groupingspec = 3 ##1:KI only, 2: KO only somehting else: all

group1 =ifelse(groupingspec ==1, "KI", "")
group1 =ifelse(groupingspec ==2, "KO", group1)
group1

if(TESTING){
  library(dplyr)
  library(ggplot2)
  datapath="Y:/AOCF-User Projects/1412_Rosenmund_VGlut1-KI"
  tmazerawdatalink= "datafortest/20150701_TMaze-rm/20150701_Rosenmund_VGlut1-KI_TMaze.csv"
  tmazerawdatalink= paste(datapath,"/6. Data from Behavioral Tests/Tmaze-rm/,datafortest/20150701_TMaze-rm/20151028_Rosenmund_VGlut1-KI_TMaze-rm.csv")
  
  #IF = read.csv2("datafortest/initial_form.csv")
  #Initiation_form = as.data.frame(t(IF[-1]))
  #names(Initiation_form)= IF[,1]
  
  
  
}
tmazerawdir= paste0(datapath,"/6. Data from Behavioral Tests/")
INT=dir(tmazerawdir)
INT = INT[grepl("TMaze",INT)]

Tmazedata=c()
tmazemeta=c()
for (i in c(1: length(INT))){
  INT2=dir(paste0(tmazerawdir,"/",INT[i]))
  INT2 = INT2[grepl(".csv",INT2)]
  tmazerawdatalink=paste0(tmazerawdir,"/",INT[i],"/",INT2)
  tmazeraw= read.csv(tmazerawdatalink, sep= ";",skip = 6, header = T)
  tmazerawmeta= read.csv(tmazerawdatalink, sep= ";",skip = 2 ,nrows = 1, header = T)
  #tmazerawmeta
  tmazeraw = data.frame(unclass (tmazeraw))
  tmazerawmeta = data.frame(unclass (tmazerawmeta))
  
  tmazeraw$Date= as.Date(tmazeraw$Date,"%d.%m.%Y" )
  tmazeraw$animal.ID = as.factor(tmazeraw$animal.ID)
  
  tmazeraw$habituationtime=difftime(strptime(tmazeraw$Start.Time ,"%H:%M"),strptime(tmazeraw$habituation,"%H:%M"), units = "mins")
  tmazeraw$agegroup=i
  Tmazedata= rbind(Tmazedata,tmazeraw)
  #tmazemeta=rbind(tmazemeta,tmazerawmeta)
}


tmazeraw=Tmazedata     





projectlagesoID= tmazerawmeta$ProjectID..lageso.


## get group name (work only if grouped by strain)
grouping =as.character(tmazeraw$animal.ID)
for (i in c(1: length(grouping))){
  grouping [i]= as.character(animalsproj$strain [animalsproj$animal.ID== grouping [i]])
}
tmazeraw$group= factor(grouping)

##special
# separating the data in the groups set earlier

tmazeraw = 
  tmazeraw %>% 
    filter (grepl(group1, group))%>%
    droplevels()
  


## calculate scores

Ntrials= (tmazerawmeta$number.of.trials-1)  

DATA = select(tmazeraw,
              num_range("Trial.", 1:Ntrials) ) 
for (i in c(1:Ntrials)){
    name=c(names(DATA),paste0("success.",i))
    DATA[,Ntrials+i]= (DATA[,i]+DATA[,i+1])-2*DATA[,i]*DATA[,i+1]
    names(DATA)=name
    
}

DATA=DATA %>%
  mutate(Successrate = (rowSums(.[Ntrials:(2*Ntrials)]))/Ntrials*100)

SCORE= DATA[-(1:Ntrials)]

#adding scores data to tmazeraw
tmazeraw= cbind(tmazeraw,SCORE)




#plotting data
plotdata= tmazeraw
ylab = "success rate [%]"
title= paste0("Succes rate in the Tmaze test with ",Ntrials+1," trials")
analysis= aes(x=agegroup,y= Successrate, fill= group)

plotdatag =group_by(plotdata, group,agegroup)
n = summarise(plotdatag,
              count = n())

p=ggplot(plotdata, analysis)
plot=p+ geom_boxplot()+ labs(x="genotype",y=ylab, title=title)+
  ylim(-10, 100)+
  #scale_fill_grey(start = 0.9, end = 0.9)+ ##allow good bw prints
  
  
  geom_text(aes(y= -5,label=paste("n =", count)), data=n, size=5) 

boxpl_OF(plotdata,aes(x=factor(agegroup),y= Successrate, fill= group),"success rate [%]",paste0("Succes rate in the Tmaze test with ",Ntrials+1," trials") )

p=ggplot(plotdata, aes(x=factor(agegroup),y= Successrate, fill= group))

p+

#boxpl_OF(OFdata,aes(x=exptype ,y= distancetraveled, fill=group),"distance traveled",paste0("locomotor activity"))

#wilcox.test(y~x)
#t.test(ytest~x)
