library(shiny)
library(dplyr)
library(readxl)
library(shinyFiles)

shinyServer(function(input, output, session) {
  q <- observe({
    # Stop the app when the quit button is clicked
    if (input$quit == 1) stopApp()
  })
  
  volumes <- getVolumes() #c('R Installation'=R.home())
 # shinyFileChoose(input, 'file', roots=volumes, session=session, restrictions=system.file(package='base'))
  shinyDirChoose(input, 'directory', roots=volumes, session=session, restrictions=system.file(package='base'))
  #shinyFileSave(input, 'save', roots=volumes, session=session, restrictions=system.file(package='base'))
  #output$filepaths <- renderPrint({parseFilePaths(volumes, input$file)})
  
  fileInput <- reactive({
    filepath= (parseDirPath(volumes, input$directory))
    filepath
    #bla="animal"
    
    
    })
  
  filenames <- reactive({
    filepath= fileInput()
    Filesname=list.files(path = filepath, pattern = NULL, all.files = FALSE,
                         full.names = FALSE, recursive = TRUE,
                         ignore.case = FALSE, include.dirs = FALSE, no.. = FALSE)
    
    Filesname
  })
  
  filechoosen<- reactive({
    Filesname= filenames()
    END=input$datatype
    NECESSARY=input$necessary_text
    NEVERTHERE=input$notpresent_text
    #Firstlinedata="Interval summary"
    #lastlinedata="Sum"
    
    #source("R_files/filechooser.r", local = TRUE)
    #Filesname = Filesname[END == substrRight(Filesname, 4) ]
    substrRight <- function(x, n){
      substr(x, nchar(x)-n+1, nchar(x))
    }
    Filesname = Filesname[END == substrRight(Filesname, 4) ]
    
    if (NEVERTHERE != ""){Filesname = Filesname[!grepl(NEVERTHERE,Filesname)]}
    
    Filesname = Filesname[grepl(NECESSARY,Filesname)]
    
    filechoosen=Filesname
    
    filechoosen
  })
  
  dataInput <- reactive({
    Firstlinedata =input$Firstlinedata
    lastlinedata =input$lastlinedata
    animalID1= input$col_animalID1
    filepath= fileInput()
    
    Filesname= filechoosen()
    #bla="animal"
    source("R_files/conc.r", local = TRUE)
    concdata
  })
  
  datacheck <- reactive({
    
      
    animalID1= input$col_animalID1
    animalID2= input$col_animalID2
    Firstlinedata =input$Firstlinedata
    lastlinedata =input$lastlinedata
    filepath= fileInput()
    
    Filesname= filechoosen()
    capture.output(source("R_files/datacheck.r", local = TRUE))
    
  })
  
  output$directorypath <- renderPrint({
    filechoosen()
    
  })
  output$testtable <- renderDataTable({
    filepath= fileInput()
    inFile=paste0(filepath,"/",filechoosen()[1])
    
         if (is.null(inFile)) {
           return(NULL)
         } else {
           return(readxl::read_excel(inFile, sheet = 1, col_names =FALSE))
               
       }
    
  })
  
   output$datachecks <- renderPrint({datacheck()
 })
  
  output$datacheckdwn <- downloadHandler(
    filename = function() { 
      paste("datacheck_",Sys.Date(), ".csv", sep='') 
    },
    content = function(file) {
      write.csv(datacheck(), file)
    },
    contentType = "text/csv"
  )
  
  output$downloadData <- downloadHandler(
         filename = function() { 
           paste("concatenated", ".csv", sep='') 
         },
         content = function(file) {
           write.csv(dataInput(), file, dec= ".")
         },
         contentType = "text/csv"
       )
  
#   output$resulttable <- renderDataTable({
#     
#     inFile=dataInput()
#     
#     if (is.null(inFile)) {
#       return(NULL)
#     } else {
#       return(inFile)
#       
#     }
#     
#   })
  #output$savefile <- renderPrint({parseSavePath(volumes, input$save)})
})



# shinyServer(function(input, output, session) {
#   shinyDirChoose(input, 'directory', roots=volumes, session=session, restrictions=system.file(package='base'))
#   
#   output$sourced <- renderDataTable({
#     
#     inFile <- input$file1
#     if (is.null(inFile)) {
#       return(NULL)
#     } else {
#       inFile %>%
#         rowwise() %>%
#         do({
#           X=read.csv(.$datapath, sep=";")
#           Initiation_form = as.data.frame(t(X[-1]))
#           names(Initiation_form)= X[,1]
#           D=dir(Initiation_form$path)
#           data.frame(D)
#         })
#     }
#   }) 
#   output$downloadData <- downloadHandler(
#     filename = function() { 
#       paste("test", '.csv', sep='') 
#     },
#     content = function(file) {
#       write.csv(Initiation_form$path, file)
#     }
#   )
  
  
#   output$path =renderDataTable({
#     if (is.null(inFile)) {
#       return(NULL)
#     } else {
#     dir(Initiation_form$path)
#     }  
#   })
# })   