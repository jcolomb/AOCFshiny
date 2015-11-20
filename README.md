# Viewer-file-concatenator
What is this?
===========

The Viewer3-concatenator is a shiny app, i.e. an application which will open in your browser and which is based on some R code. Its goal is to **check the quality** and **concatenate** files exported from the **Viewer 3** software mainly used to track rodents during behavioral tests. A different app will be deveolp to then analyse the data from different behavioral tests recorded via the viewer.

This app will allow you to choose a folder on your computer (or a server you have access to), it will then look for excel files in this folder (and folders in this folder) and return their name.
You can then choose some files by adding elements which need or are "forbiden"" to be in the file name. You can concatenate single animal and plugin derived data, while the data check works only for single animal excel export. 

This works only with .xls export at the moment, but could be easily modified to accept .csv exports.

Install
=======

You need to install R on your computer: https://cran.r-project.org/

On the R console, copy and paste this code:

    install.packages(c("shiny","dplyr","readxl","shinyFiles"))

Run
===

Please install R and run the command:

    library(shiny)
    shiny::runGitHub('Viewer-file-concatenator', 'jcolomb') 

This app will be copied on your computer and run locally. Since it is based on shinyFiles, it must be run on the computer which can read the data files.