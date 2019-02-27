#' readGC
#' 
#' Parser for Shimadzu GCsolution and GCMSsolution data
#' 
#' @param file a text file, exported from the Shimadzu GCsolution or GCMS solution. 
#' Only the "Compound Quantitative Result" must be clicked when exporting.
#  @param ncompounds Integer. Number of compounds, as defined in the compound table. Future versions will 
#  detect this automatically.
#' @param writexl logical: write the resulting tibble to xlsx?
#' 
#' @usage readGC(file, writexl = FALSE)
#' 
#' @return A tibble containing all the information from the exported file.
#' The \code{sample} variable contains sample names, generated from the file names 
#' (matches word/dot/dash/space from the end of file name and removes the .gcd or .qgd extension). 
#' The function tries to detect the number of samples and compounds and prints this information. If the \code{writexl} 
#' argument is \code{TRUE}, then an excel file with the data is written to the current directory.
#' 
#' @importFrom stringr str_extract str_remove str_split str_detect
#' @importFrom dplyr as_tibble '%>%'
#' @importFrom utils read.table
#' @importFrom crayon '%+%'
#' 
#' @author Angel Angelov
#' 
#' @export

 #library(tidyverse)

 readGC <- function(file, writexl = FALSE) {
  flines <- readLines(file)
  # first remove those tabs at the end #
  flines <- str_remove(flines, "\\t$")
  
  #### detect number of samples ####
  n <- as.integer(grep("[Header]", flines, fixed = TRUE) %>% length()) # number of runs 
  cat(crayon::blue$bgWhite(crayon::bold(n), " samples were detected", "\n"))
  ####
  
  # test if I can detect ncompounds
  nIDs <- flines %>% 
    str_detect(pattern = "# of IDs") %>% 
    subset(flines, subset = .) %>% 
    str_split(pattern = "\t") %>% 
    do.call(rbind, .) %>% .[ , 2] %>% as.numeric()
  
  if(length(unique(nIDs)) != 1) {
    stop("All samples must have equal number of compounds! Check your batch processing...")
  }
  
  ncompounds2 <- nIDs[1]
  cat(crayon::blue$bgWhite(crayon::bold(ncompounds2), " compounds per sample were detected", "\n"))
  
  if(length(nIDs) != n) {
    stop("Something went wrong, check that your exported file has the same structure as the examples.")
  }
  ###################
  
  ### define 
  skip <- seq(8, length.out = n, by = ncompounds2 + 9) # tell which lines are just before the data
  
  # subset data only, first get indices of data lines
  dataidxs <- lapply(1:ncompounds2, function(i) {skip + i})
  # then make one vector of indices and use it to subset the lines
  dataidx <- c(do.call(rbind, dataidxs))
  
  df <- read.table(text = flines[dataidx], 
             sep = "\t", 
             col.names = unlist(str_split(flines[8], pattern = "\t"))) # the column names lines have one tab less than the data lines!
  
  #sample names
  names <- flines[grep("Data File Name", flines)] %>%
           # match word or dot or dash or space!, positive lookahead end of line
           str_extract(pattern = "([ \\w.-]+)(?=$)") %>%
           # remove file extensions
           str_remove(pattern = "(.gcd|.qgd)") %>%
           # repeat for each compound, note the "each" argument
           rep(each = ncompounds2)
           
  
  #check before adding to df
    if(length(names) != nrow(df)) {
      stop("Wrong numbers of compounds or samples!")
    }
  
  df[["sample"]] <- names
  
  #### write xlsx if required ####
  if(isTRUE(writexl)){
      if(!requireNamespace(package = "writexl", quietly = TRUE)) {
      stop("Please install \"writexl\" in order to write xlsx files. You can do it with install.packages(\"writexl\")")
      }
    basefilename <- basename(file) %>% str_split(pattern = "\\.") %>% unlist() %>% .[1]
    writexl::write_xlsx(df, path = paste0(basefilename, ".xlsx"))
    cat(crayon::red$bgWhite(basefilename, ".xlsx", sep = "") %+% 
        crayon::blue$bgWhite(" was written to current directory", "\n"))
  }
  
  return(as_tibble(df))
 }
