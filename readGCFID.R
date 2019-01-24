### parse GC-FID ASCII file ###
# complicated by the fact that data lines have a tab at the end of the line!!! #

 library(tidyverse)

 readGCFID <- function(asciifile, ncompounds) {
  flines <- readLines(asciifile)
  # first remove those tabs at the end #
  flines <- str_remove(flines, "\\t$")
  
  n <- as.integer(grep("[Header]", flines, fixed = TRUE) %>% length()) # number of runs 
  skip <- seq(8, length.out = n, by = ncompounds + 9) # tell which lines are just before the data
  
  # subset data only, first get indices of data lines
  dataidxs <- lapply(1:ncompounds, function(i) {x <- skip + i})
  # then make one vector of indices and use it to subset the lines
  dataidx <- c(do.call(rbind, dataidxs))
  df <- read.table(text = flines[dataidx], 
             sep = "\t", 
             col.names = unlist(str_split(flines[8], pattern = "\t"))) # the column names lines have one tab less than the data lines!
  
  #names
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


