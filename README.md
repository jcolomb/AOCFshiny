# Viewer-file-concatenator
What is this?
===========

The Viewer3-concatenator is a shiny app, i.e. an application which will open in your browser and which is based on some R code. Its goal is to **check the quality** and **concatenate** files exported from the **Viewer 3** software mainly used to track rodents during behavioral tests. A different app will be deveolp to then analyse the data from different behavioral tests recorded via the viewer.

This app will allow you to choose a folder on your computer (or a server you have access to), it will then look for excel files in this folder (and folders in this folder) and return their name.
You can then choose some files by adding elements which need or are "forbiden"" to be in the file name. You can concatenate single animal and plugin derived data, while the data check works only for single animal excel export. 

This works only with .xls export at the moment, but could be easily modified to accept .csv exports.

Install
=======
To run the program, you first need to install one program (R) and some "packages". R is programming language, working similarly to the windows console.


In order to install R on your computer, follow the instructions here: https://cran.r-project.org/

Open the R application and copy and paste this code:

    install.packages(c("shiny","dplyr","readxl","shinyFiles","chron"))

Run
===

Open the R application and copy and paste this code:

    library(shiny)
    shiny::runGitHub('Viewer-file-concatenator', 'jcolomb') 

your browser should start, running the application. The app utilisation should be quite self-explanatory.