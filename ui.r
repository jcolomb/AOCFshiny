#install.packages("shiny")


library(shiny)
library(shinyFiles)
shinyUI(bootstrapPage(
  
  
  titlePanel(p("Working with viewer3 data:from excel export to statistical analysis", align = "center"),
              windowTitle = "Viewer3 data analysis"
  ),
  
  sidebarPanel(
    
    #$helpText("Click here to update your results, you need to do this after you change the data, model, or setting"),
    #ubmitButton("Update View"),
    #br(),
    #helpText("Press Quit to exit the application"),
    
    tags$h4("For feedback (problems, feature request and thank-you message) please use ",tags$br(), tags$a(href="https://github.com/jcolomb/Viewer-file-concatenator/issues","the github issue tracker."))
    ,actionButton("quit", "Quit app")
    , width = 3),
  
  mainPanel(
    tabsetPanel(
      tabPanel("Concatenator",
      tags$h2("Viewer3-concatenator and data quality check", align = "center"),
      tags$hr(),
      
    
     tags$p(shinyDirButton('directory', 'Push to select the data folder on your computer, the programm can access data in subfolders.', 'Please select a folder'), align= "center"),

    #tags$hr(),
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
  ),
tabPanel("analysis",
            tags$p("testing")
)#endtab
) #end tabset
)#end main panel
)# end bootstrap
) #end ui