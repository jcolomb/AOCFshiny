#install.packages("shiny")


library(shiny)
library(shinyFiles)


shinyUI(
  fluidPage(
    tags$h2("Viewer3-concatenator and data quality check", align = "center"),
    
    tags$p(shinyDirButton('directory', 'Push to select the data folder on your computer, the programm can access data in subfolders.', 'Please select a folder'), align= "center"),

    tags$hr(),
    tags$p("In the two boxes here, try to select only the file you are interested in", align= "center"), 
    
    radioButtons("datatype", 
                 label = ("type of file to upload (only xls working at this time)"),
                 choices=c(".xls file" = ".xls")),    
    #dataTableOutput('directorypath'),
    tags$div(
      textInput("necessary_text", label = ("text that must be in the file"), 
              value = "animal") ,
      textInput("notpresent_text", label = ("text that must not be in the file"), 
              value = "")
    ),
    
    
    verbatimTextOutput('directorypath'),
    tags$hr(),
    tags$p("indicate here information about the data structure. Refer to the data seen below (first xls file read).", align= "center"),
    textInput("lastlinedata", label = ("Give the text of the first column of the last data line"), 
              value = "Sum"),
    textInput("Firstlinedata", label = ("Give the text of the first column of the first of the two headers lines"), 
              value = "Interval summary"),
    tags$p("indicate here the columns where the animal ID was entered, put twice the same column if you entered the ID only once.).", align= "center"),
    textInput("col_animalID1", label = ("Columns for animal ID number"), 
              value = "Animal No.:"),
    textInput("col_animalID2", label = ("Columns for animal ID number"), 
              value = "Animal No.:"),
tags$hr(),
tags$p("Choose your outputs: result of the data check or concatenate the data. Concatenation may not work if there are errors in the data check.", align= "center"),
  downloadButton('datacheckdwn', 'Test data quality and download result'),
  downloadButton('downloadData', 'Concatenate files and download result table'),
    
    
#     fileInput("file1",
#               "Choose CSV files from directory",
#               multiple = TRUE,
#               accept=c('text/csv', 
#                        'text/comma-separated-values,text/plain', 
#                        '.csv')),
#     downloadButton('downloadData', 'Download'),
     dataTableOutput("testtable"),
#dataTableOutput("resulttable")
     textOutput("datachecks")
  ))