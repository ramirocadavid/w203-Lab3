rm(list=ls())

getwd()
setwd("~/W203-Statistics/Lab_03")
getwd()
library('car')

# Loads crime_v2.csv
crime <- read.csv("crime_v2.csv", header=TRUE)
head(crime)


# Lists basic data on number of variables and observations, data types, and provides samples
str(crime)

### This dataset consists of 97 rows (entries) described by 25 variables (columns)

### 'county' looks to be specified by odd numbers

### 'prbconv' looks like it's messed up (factor type, not number like 'prbarr' and 'prbpris')
    (crime$prbconv)
    ### These data are spread across 92 levels. 92-96 are "", while 97 is "`"`

### 'west' and 'central' look to be binary variables. Do 1s indicate 'east' and something else?



# Loads summary of crime object
summary(crime)

### There are 6 'NA' entries in all variables, except 'prbconv'; do these values all fall within the same rows? 

crime[crime$year == "NA",]
    ### Yes, there are 6 rows (labelled 'NA' and 'NA.1'-'NA.5') with NA values across the board

crime[crime$prvconv == "NA",]
    ### This doesn't return anything; do I need to explicitly look for "" or "`" 'prbconv' from above?

crime[crime$prbconv == '' | crime$prbconv=='`',]
    ### These appear to represent the same missing entries.However, the indicies are marked differently 
    ### (92-97, instead of 'NA' and 'NA.1'-'NA.5' above).

### 'county' appears to be out of register somewhere, since the max = 197 and not 2(97) - 1 = 193, as I'd expect for 
### 97 rows that are enumerated with odd numbers. [for n rows (1,2,...,k), county = 2n - 1] 

### 'prbarr' is a probability and should not exceed 1, but the max is 1.09091
   ### Is this truly a probability? Could arrests exceed offenses?

### We need to convert 'prbconv' (after removing missing values) into numbers and not factors
   ### Ensure the range of probabilities make sense (see above)

### 'avgsen' seems really low, given that it's in days. Does this include people are are convicted, 
### but don't receive a prison sentence (which would drive the average down). Is this effect enough
### to account for sentences imposed for severe crimes (e.g., murder, rape, assault, robbery)

### Random thought: This dataset doesn't distinguish between severe crimes and comparatively minor ones
   ### Does this represent an omitted variable?

### Is is realistic within a state the size of NC to have a county with a density of only
### 0.00002 (i.e., 1 person per 50,000 square miles)?
   ### Does this represent wilderness area?
   ### Are any other measures defined?

### As with other variables, unclear what the units of 'taxpc' are.
   ### These values for 'taxpc' could be reasonable, but we don't know for certain

### How are 'west' and 'central' defined? In particular, should their be a 50:50 split for 'west'?

### 'urban' is heavily positively skewed, suggesting that most of NC is rural (unsurprising)

### 'pctmin80' looks reasonable

### Wage information looks to be within reasonable ranges

### What does 'mix' indicate? 


# Next steps
### Eliminate "NA" values
### I still need to look at histograms of these variables to check the distributions
### Should also generate scatterplot matrix
### Consider models of 'crmrte' against following regressors:
   ### prbarr, prbconv, prbpris, (avgsen?)
   ### density, pctmin80, pctymle
   ### density, polpc, taxpc