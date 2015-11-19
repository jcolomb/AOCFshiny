#install.packages("shiny")


library(shiny)
library(shinyFiles)


shinyUI(
  fluidPage(
    shinyDirButton('directory', 'Folder select', 'Please select a folder'),
    
    #dataTableOutput('directorypath'),
    textInput("necessary_text", label = ("text that must be in the file"), 
              value = "animal"),
    textInput("notpresent_text", label = ("text that must not be in the file"), 
              value = ""),
    
    radioButtons("datatype", 
                 label = ("type of file to upload (only xls working at this time)"),
                          choices=c(".xls file" = ".xls")),
    verbatimTextOutput('directorypath'),
    "<c>
indicate here information about the data structure.
    
    </c>",
    textInput("lastlinedata", label = ("Give the text of the first column of the last data line"), 
              value = "Sum"),
    textInput("Firstlinedata", label = ("Give the text of the first column of the first of the two headers lines"), 
              value = "Interval summary"),
    downloadButton('downloadData', 'Concatenate files and download result table'),
    downloadButton('datacheckdwn', 'Test data quality and download result'),
    
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