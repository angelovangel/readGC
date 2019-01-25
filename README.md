# readGC
Parser for Shimadzu GCsolution and GCMSsolution data.

## Background
When doing quantitative analysis on Shimadzu GC-FID or GC-MS, the software does not support export of the data in a usable format. During processing of the data, the user can select "ASCII convert" and export the data of a batch run to a text file (click the "Compound Quantitative Result" checkbox before export). This text file contains information about the samples of the batch and about the measured compounds. However, extracting this data for downstream processing can be tedious and involves a lot of manual copying.  

## Usage
The `readGC()` function reads these files and extracts the information in a dataframe.
In your `R` session, source the `readGC.R` file like this:   
`source("https://raw.githubusercontent.com/angelovangel/readGC-Shimadzu/master/readGC.R")`    
and then use the function:    
`readGC(file, ncompunds)`.    
The two arguments are `file` (path to file name, use quotes) and `ncompounds` (integer, number of compounds in the data). 
A `tibble` with the data is returned and additional information is printed to the console. I have tested the script with GC-FID and with GS-MS data exported from the Shimadzu GC(MS)solution software (it is important that when exporting only the "Compound Quantitative Result" checkbox is selected). 

