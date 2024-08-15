# Functions
# Function that takes a quarter and calculates the mutation in that quarter. 
def_prev_kwartaal <- function(x) {
  kwartaal <- unlist(strsplit(x[2], split = "Q"))
  if (kwartaal[2] %in% c(2,3,4)){
    
    result <- paste(kwartaal[1],strtoi(kwartaal[2]) -1, sep="Q")
  }
  else {
    result <- paste(strtoi(kwartaal[1])-1, "4", sep="Q")
  }
  
  return (result)
}

# Look up function for previous cpi value for the correct category.
def_find_cpi_prev_kwartaal <- function (x, data){
  df1 <- subset(data,data$Bestedingscategorieen == x[1] & data$Kwartaal==x[4])
  return(df1$CPI_Kwartaal)
}