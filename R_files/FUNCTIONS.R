# DEPENDENCY
library(pander)
library(chron) #for analysis of data (get length of experiment)
library(dplyr)
library(ggplot2)
library(xtable)
options(xtable.comment = FALSE)
library(rmarkdown)
library(readxl) ## reading mouse book
# INTERNAL DEPENDENCY .rmd
#prereport.rmd
########################################################################################################


writeprereport <- function (userprojectfolder) {
  
  #IF = read.csv2("datafortest/initial_form.csv")
  IF <- read.csv(paste(userprojectfolder,"8_computerisable_files/initial_form.csv", sep="/"), sep=";",colClasses=c(NA, NA, "NULL"))
  children <- paste(userprojectfolder,"8_computerisable_files/commentpremeeting.Rdm", sep="/")
  children = ifelse (file.exists(children), children, "empty.Rmd" )
  Initiation_form = as.data.frame(t(IF[-1]))
  names(Initiation_form)= IF[,1]
  
  
  TMAZE=F
  INITIATION = T
  Num_lines_in_init_form_table =24
  t=rmarkdown::render("prereport.Rmd")
  
  #rmarkdown::render("main.Rmd")
  t_classed=paste(userprojectfolder,"/1. Project Initiation/",Initiation_form$Projectname,"_prereport.pdf", sep ="")
  file.copy(t,t_classed , overwrite= TRUE)
}
########################################################################################################
writemiddlereport <- function (userprojectfolder) {
  
  #IF = read.csv2("datafortest/initial_form.csv")
  IF <- read.csv(paste(userprojectfolder,"8_computerisable_files/initial_form.csv", sep="/"), sep=";",colClasses=c(NA, NA, "NULL"))
  children <- paste(userprojectfolder,"8_computerisable_files/initialmeetingresult.Rmd", sep="/")
  children = ifelse (file.exists(children), children, "empty.Rmd" )
  Initiation_form = as.data.frame(t(IF[-1]))
  names(Initiation_form)= IF[,1]
  
  
  TMAZE=F
  INITIATION = F
  Num_lines_in_init_form_table =24
  t=rmarkdown::render("middlereport.Rmd")
  
  #rmarkdown::render("main.Rmd")
  t_classed=paste(userprojectfolder,"/1. Project Initiation/",Initiation_form$Projectname,"_middlereport.pdf", sep ="")
  file.copy(t,t_classed , overwrite= TRUE)
}
########################################################################################################
writepreexperimentreport <- function (userprojectfolder) {
  
  #IF = read.csv2("datafortest/initial_form.csv")
  IF <- read.csv(paste(userprojectfolder,"8_computerisable_files/initial_form.csv", sep="/"), sep=";",colClasses=c(NA, NA, "NULL"))
  children <- paste(userprojectfolder,"8_computerisable_files/Experimentalplan.Rmd", sep="/")
  children = ifelse (file.exists(children), children, "empty.Rmd" )
  Initiation_form = as.data.frame(t(IF[-1]))
  names(Initiation_form)= IF[,1]
  
  
  TMAZE=F
  INITIATION = F
  Num_lines_in_init_form_table =24
  t=rmarkdown::render("middlereport.Rmd")
  
  #rmarkdown::render("main.Rmd")
  t_classed=paste(userprojectfolder,"/1. Project Initiation/",Initiation_form$Projectname,"_exp_report.pdf", sep ="")
  file.copy(t,t_classed , overwrite= TRUE)
}
########################################################################################################

read_excel_allsheets <- function(filename) {
  sheets <- readxl::excel_sheets(filename)
  x <-    lapply(sheets, function(X) readxl::read_excel(filename, sheet = X))
  names(x) <- sheets
  x
}
########################################################################################################
boxpl_OF <- function (plotdata, analysis, ylab, title, ymin= 0) {
  
  p=ggplot(plotdata, analysis)
  plot=p+ geom_boxplot(position=position_dodge(width=0.9))+ labs(x="experiment number",y=ylab, title=title)+
     expand_limits(y=ymin)+
    #scale_fill_grey(start = 0.9, end = 0.9)+ ##allow good bw prints
    stat_summary( fun.data = fun_length <- function(x){
      return(data.frame(y=-1,label= paste0("n=", length(x))))
    }, geom = "text", position=position_dodge(width=0.9))
  
  
  
  
  #geom_text(aes(x=group, fill=exptype,y= -5,label=paste("n =", count)), data=n, size=5) 
  plot
  
}
########################################################################################################
createIDandtime <- function (data) {
  if(is.null(data$animalID)){data$animalID=data$animal.ID}
  if(is.null(data$animalID)){stop("I could not find any animalID column in the data")}
  
  if(is.null(data$exp_day)){data$exp_day=data$Interval.summary_Date}
  if(is.null(data$exp_day)){data$exp_day=data$Date}
  if(is.null(data$exp_day)){stop("I could not find any date column in the data")}
  return(data)
}

########################################################################################################

addanimalinfotodata <- function ( data, TD=T_D,  Grouptable=Group_table) {
  number_agegroups= TD$age.categories[1]
  
  ##add group and age in the data from the grouptable 
  grouping =as.character(data$animalID)
  age =as.character(data$animalID)
  
  for (i in c(1: length(grouping))){
    
    #age=date of experiment - birth date
    age [i]=(
      (chron(as.character(data$exp_day[i]), format = c(dates = "y-m-d")))-
        dates(as.chron	(Grouptable$birth[Grouptable$ID== grouping [i]]))
    )
    #grouping by genotype
    grouping [i]= as.character(Grouptable$genotype [Grouptable$ID== grouping [i]])
    
  }
  data$genotype= factor(grouping)
  
  ##check that it is correct with the testsdone table
  if (length(levels(data$genotype))!= TD$genotype[1]){
    stop("The number of genotype does not correspond to the forseen one, there is probably an error in the mouse book:",paste0(levels(data$genotype))) 
  }
  
  
  data$group=data$genotype ## for compatibility issues
  data$age= as.numeric(age)/7
  
  ### making 2 groups if 2 age groups
  if (number_agegroups>1){
    H=hist(data$age,breaks= (number_agegroups-1))
    if (length(H$counts) != (number_agegroups) ) {
      print("there is something wrong with the data splitting over age, do you have all the data?, setting the number of groups to 1")
      number_agegroups=1
    }
  }
  if (number_agegroups>1){
    data$agecat=NA
    for (k in c(1:number_agegroups)){
      #H$breaks[k]
      
      data$agecat= ifelse( ( sapply(H$breaks[k]<data$age,isTRUE) & sapply(data$age<H$breaks[k+1], isTRUE) ), k,data$agecat)
      
    }
    #naming the groups by age
    
    #data$agecat
  }else{data$agecat=1}
  
  #naming the groups by age
  for (k in c(1:number_agegroups)) {
    Name= range(data$age[data$agecat==k])
    #Names= paste0(as.integer(10*mean(Name[1], Name[2]))/10," +/- ", as.integer(10*(Name[2]-Name[1])/2 )/10, " weeks")
    
    Names= paste0(ifelse(as.integer(Name[1])<10,"0",""),as.integer(Name[1]),"-", as.integer(Name[2]), " weeks")
    data$agecat[data$agecat==k] = Names           
  }
  
  data$agecat=factor(data$agecat)
  return(data)
}


########################################################################################################
