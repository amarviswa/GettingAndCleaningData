##Getting and Cleaning Data

###Description

###Availability for Required Packages 
Check the availability for required packages. If not exists install and include.

###Downloading Data
Download the zip file from the given URL. After downloading the Zip file, extract the zip file into folder.

###File Preparation
Load the relevant files and assign column names. Use cbind() to append both the subject and activity  identifiers. Use rbind() to merge test and train data.

###Extract Mean & Standard Deviation Measurements
Apply the mean function to dataset using dcast function

###Tidy Data Output
Use write.table to write the data into txt file.

###Dependencies
run_analysis.R file will help you to install the dependencies automatically. It depends on reshape2 and data.table. 
