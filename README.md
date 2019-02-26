# readGC
Parser for Shimadzu GCsolution and GCMSsolution data.   

## Background
When doing quantitative analysis on Shimadzu GC-FID or GC-MS, the software does not support export of the data in a usable format. During processing of the data, the user can select "ASCII convert" and export the data of a batch run to a text file (click the "Compound Quantitative Result" checkbox before export). This text file contains information about the samples of the batch and about the measured compounds. However, extracting this data for downstream processing can be tedious and involves a lot of manual copying.  

## Installation adn usage
The `readGC()` function reads these files and extracts the information in a dataframe. If needed, an excel file can also
be generated (requires the `writexl` package).
You can install it from Github:   
`devtools::install_github("angelovangel/readGC")`   
and then use the function:   
`readGC(file)`

You just pass the `file` argument (path to exported file name, use quotes) and (optionally) `writexl = TRUE` if you want to save the data as an excel file.
The `readGC()` function returns a `tibble` with the data and additional information is printed to the console. 
I have tested it with GC-FID and with GS-MS data exported from the Shimadzu GC(MS)solution software (test files can be downloaded from the `example-data` folder) , it is important that when exporting only the "Compound Quantitative Result" checkbox is selected. 

