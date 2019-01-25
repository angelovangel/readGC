# readGC
Parser for Shimadzu GCsolution and GCMSsolution data.

## Background
When doing quantitative analysis on Shimadzu GC-FID or GC-MS, the software does not support export of the data in a usable format. During processing of the data, the user can select "ASCII convert" and export the data to a text file (click the "Compound Quantitative Result" checkbox before export). 

## Usage
The `readGC()` function reads these files and extracts the information in a dataframe.
In your `R` session, source the `readGC.R` file like this: `source("https://raw.githubusercontent.com/angelovangel/readGC-Shimadzu/master/readGC.R")` and then use the function: `readGC(file, ncompunds)`.
A `tibble` with the data is returned. 
