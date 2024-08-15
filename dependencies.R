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