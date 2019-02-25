#' readGC
#' 
#' Parser for Shimadzu GCsolution and GCMSsolution data
#' 
#' @param file A text file, exported from the Shimadzu GCsolution or GCMS solution. 
#' Only the "Compound Quantitative Result" must be clicked when exporting.
#' @param ncompounds Integer. Number of compounds, as defined in the compound table. Future versions will 
#' detect this automatically.
#' 
#' @return A tibble containing all the information from the exported file.
#' The \code{sample} variable contains sample names, generated from the file names 
#' (matches word/dot/dash/space from the end of file name and removes the .gcd or .qgd extension).
#' 
#' @importFrom stringr str_extract str_remove str_split
#' @importFrom dplyr as_tibble '%>%'
#' @importFrom utils read.table
#' 
#' @author Angel Angelov
#' 
#' @export

 #library(tidyverse)

 readGC <- function(file, ncompounds) {
  flines <- readLines(file)
  # first remove those tabs at the end #
  flines <- str_remove(flines, "\\t$")
  
  n <- as.integer(grep("[Header]", flines, fixed = TRUE) %>% length()) # number of runs 
  cat(n, " samples were detected...", "\n")
  
  skip <- seq(8, length.out = n, by = ncompounds + 9) # tell which lines are just before the data
  
  # subset data only, first get indices of data lines
  dataidxs <- lapply(1:ncompounds, function(i) {skip + i})
  # then make one vector of indices and use it to subset the lines
  dataidx <- c(do.call(rbind, dataidxs))
  
  df <- read.table(text = flines[dataidx], 
             sep = "\t", 
             col.names = unlist(str_split(flines[8], pattern = "\t"))) # the column names lines have one tab less than the data lines!
  
  #sample names
  names <- flines[grep("Data File Name", flines)] %>%
           # match word or dot or dash or space!, positive lookahead end of line
           str_extract(pattern = "([ \\w.-]+)(?=$)") %>%
           # repeat for each compound, note the "each" argument
           rep(each = ncompounds)
           
  
  #check before adding to df
    if(length(names) != nrow(df)) {
      stop("Wrong numbers of compounds or samples!")
    }
  
  df[["sample"]] <- names
  return(as_tibble(df))
 }
