# Install and load dependencies
if(!require('dplyr')) {
  install.packages('dplyr')
  library('dplyr')
}

if(!require('cbsodataR')) {
  install.packages('cbsodataR')
  library('cbsodataR')
}

if(!require('DBI')) {
  install.packages('DBI')
  library('DBI')
}

if(!require('RSQLite')) {
  install.packages('RSQLite')
  library('RSQLite')
}

if(!require('ggplot2')) {
  install.packages('ggplot2')
  library('ggplot2')
}



# Variables
# Chosen categories "011130 Brood" en "011470 Eieren"
categorieen = c("CPI011130", "CPI011470")
perioden_filter = "MM"
column_filter = c("Bestedingscategorieen", "Perioden", "CPI_1", "MaandmutatieCPI_3")
db_name = "cbs_casus.sqlite"

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

def_find_cpi_prev_kwartaal <- function (x, data){
  df1 <- subset(data,data$Bestedingscategorieen == x[1] & data$Kwartaal==x[4])
  return(df1$CPI_Kwartaal)
}

# Download the "Consumentenprijzenindex" table and filter with filters defined above
data <- cbs_get_data("83131NED" 
                     ,Bestedingscategorieen = categorieen
                     ,Perioden = has_substring(perioden_filter)
                     , select = column_filter)

# Create new column with quarterly values
data$Kwartaal <- gsub("MM01|MM02|MM03", "Q1"
                      , gsub("MM04|MM05|MM06", "Q2"
                      , gsub("MM07|MM08|MM09", "Q3"
                      , gsub("MM10|MM11|MM12", "Q4"
                      , data$Perioden))))

# Summarize data to get quarterly CPI
summarised_data <- data %>% group_by(Bestedingscategorieen, Kwartaal) %>% summarise(CPI_Kwartaal = mean(CPI_1))


# Calculate quartermutation and add values to "Kwartaalmutatie" column.
# To get the kwartaal mutatie. First the previous quarter is determined by the def_prev_kwartaal funcition
summarised_data$prev_kwartaal <- apply(summarised_data, 1, def_prev_kwartaal)
# lookup for the cpi of the previous quarter.
summarised_data$CPI_prev_kwartaal <- apply(summarised_data, 1, def_find_cpi_prev_kwartaal, data = summarised_data)
# Data with no prev quarter is removed 
summarised_data <- subset(summarised_data, CPI_prev_kwartaal > 0 )
# Kwartaalmutation is calculated
summarised_data$CPI_Kwartaalmutatie <- as.numeric(summarised_data$CPI_Kwartaal) * 100 / as.numeric(summarised_data$CPI_prev_kwartaal)-100
# Relevant data is selected
summarised_data <- subset(summarised_data, select = c("Bestedingscategorieen", "Kwartaal", "CPI_Kwartaal", "CPI_Kwartaalmutatie"))

# Add new label to make figures more readable 
summarised_data$BestedingscategorieStr <- ifelse(summarised_data$Bestedingscategorieen == "CPI011130","Brood", "Eieren")

# Visualisaties
# line graph 2 products kwartaal waarde
ggplot(data = summarised_data
       , aes(x = Kwartaal
             , y = CPI_Kwartaal
             , color= BestedingscategorieStr,
             group= BestedingscategorieStr
             )
       )+ theme(axis.text.x = element_text(angle = 90)) + geom_line() + ggtitle("CPI per kwartaal voor Brood en Eieren")
ggsave("Kwartaal.pdf")


# line graph 2 product kwartaalmutatie
ggplot(data = summarised_data
       , aes(x = Kwartaal
             , y = CPI_Kwartaalmutatie
             , color= BestedingscategorieStr
             , group= BestedingscategorieStr
            )
      ) +  theme(axis.text.x = element_text(angle = 90)) + geom_line() + ggtitle("Kwartaalmutatie van CPI voor Brood en Eieren")
ggsave("Kwartaalmutatie.pdf")


# Write results to SQLite database

conn <- dbConnect(RSQLite::SQLite(), db_name)

dbWriteTable(conn, "summarised_data", summarised_data, overwrite = TRUE)
result <- dbReadTable(conn, "summarised_data")

dbDisconnect(conn = conn)
