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

### 'west' and 'central' look to be binary variables. Do 0s indicate 'east' and something else?



# Loads summary of crime object
summary(crime)

### There are 6 'NA' entries in all variables, except 'prbconv'; do these values all fall within the same rows? 

crime[crime$year == "NA",]
    ### Yes, there are 6 rows (labelled 'NA' and 'NA.1'-'NA.5') with NA values across the board

crime[crime$prvconv == "NA",]
    ### This doesn't return anything; do I need to explicitly look for "" or "`" 'prbconv' from above?

crime[crime$prbconv == '' | crime$prbconv=='`',]
    ### These appear to represent the same missing entries. However, the indicies are marked differently 
    ### (92-97, instead of 'NA' and 'NA.1'-'NA.5' above).

### 'county' appears to be out of register somewhere, since the max = 197 and not 2(97) - 1 = 193, as I'd expect for 
### 97 rows that are enumerated with odd numbers. [for n rows (1,2,...,k), county = 2n - 1] 
   ### Check on the number of counties in NC -> Katie says there are 100
   ### Only have a selection -> good that it doesn't exceed 100

### 'prbarr' is a probability and should not exceed 1, but the max is 1.09091
   ### Is this truly a probability? Could arrests exceed offenses?

### We need to convert 'prbconv' (after removing missing values) into numbers and not factors
   ### Ensure the range of probabilities make sense (see above)

### 'avgsen' seems really low, given that it's in days. Does this include people are are convicted, 
### but don't receive a prison sentence (which would drive the average down). Is this effect enough
### to account for sentences imposed for severe crimes (e.g., murder, rape, assault, robbery)?

### Random thought: This dataset doesn't distinguish between severe crimes and comparatively minor ones
   ### Does this represent an omitted variable?

### Is is realistic within a state the size of NC to have a county with a density of only
### 0.00002 (i.e., 1 person per 50,000 square miles)?
   ### Does this represent wilderness area?
   ### Are any other measures defined?

### Is it reasonable that the maximum density is only 8-9 people per square mile?
   ### Average in all of NC is ~200 residents/square mile (208)

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

# Eliminates rows with missing values
clean <- crime[complete.cases(crime),]

# Checks that blank rows aren't present
clean[clean$prbconv == '' | clean$prbconv=='`',]
clean[clean$year == "NA",]
tail(clean)

# Checks for duplicate rows
clean[duplicated(clean),]

# Verifies which row is a duplicate
clean[clean$county == 193,]

# Eliminates duplicate rows
clean <- clean[!duplicated(clean),]

# Checks for duplicate rows
clean[duplicated(clean),]

# Verifies which row is a duplicate
clean[clean$county == 193,]

# Re-cast 'prbconv' from factors into numbers
clean$prbconv <- as.numeric(as.character(clean$prbconv))

summary(clean)
str(clean)

### 'prbconv' seems high (2>1), but could represent a similar issue with the time lag we see for 'prbarr'

clean$prbconv

hist(clean$crmrte, breaks="FD", col="grey")
hist(clean$prbarr, breaks="FD", col="grey")
hist(clean$prbconv, breaks="FD", col="grey")
hist(clean$prbpris, breaks="FD", col="grey")
hist(clean$avgsen, breaks="FD", col="grey")
hist(clean$polpc, breaks="FD", col="grey")
hist(clean$density, breaks="FD", col="grey")
   ###  The distribution is almost certainly too low by two orders of magnitude
hist(clean$taxpc, breaks="FD", col="grey")
hist(clean$west, breaks="FD", col="grey")
hist(clean$central, breaks="FD", col="grey")
hist(clean$urban, breaks="FD", col="grey")
hist(clean$pctmin80, breaks="FD", col="grey")
hist(clean$wcon, breaks="FD", col="grey")
hist(clean$wtuc, breaks="FD", col="grey")
hist(clean$wtrd, breaks="FD", col="grey")
hist(clean$wfir, breaks="FD", col="grey")
hist(clean$wser, breaks="FD", col="grey")
   ### Extreme outlier in service (>$2000/week)
hist(clean$wmfg, breaks="FD", col="grey")
hist(clean$wfed, breaks="FD", col="grey")
hist(clean$wsta, breaks="FD", col="grey")
hist(clean$wloc, breaks="FD", col="grey")
hist(clean$mix, breaks="FD", col="grey")
hist(clean$pctymle, breaks="FD", col="grey")

# Generate scatterplots against crime rate, our outcome variable of interest
scatterplotMatrix(clean[,c(4:7, 3)])
scatterplotMatrix(clean[,c(8:11, 3)])
scatterplotMatrix(clean[,c(12:15, 3)])
scatterplotMatrix(clean[,c(16:19, 3)])
scatterplotMatrix(clean[,c(20:23, 3)])
scatterplotMatrix(clean[,c(24:25, 3)])

### polpc is positively correlated (would be more so w/o one outlier)
### Hard to determine if polpc or crmrte is causal  ->
### if you have a lot of crime, you might hire a lot of police

### Density is positively correlated with crime rate 

### pctmin80 has a hump in the middle

### urban is positively correlated

### wcon is weakly positively correlated

### wtuc is weakly positively correlated

### wtrd and wfir show stronger positive correlations

### wser would be strongly positively correlated were it not for outlier

### wmfg, wfed, wsta, and wloc show positive correlations, but do they make sense?

### pctymle shows positive correlation

# Impose different transformations to visualize 'prbarr'
# Leave unaltered
plot(x=clean$prbarr, y=clean$crmrte)
plot(x=1/(clean$prbarr), y=clean$crmrte)
plot(x=exp(-clean$prbarr), y=clean$crmrte)
plot(x=clean$prbarr, y=log10(clean$crmrte))

# Impose different transformations to visualize 'prbconv'
plot(x=clean$prbconv, y=clean$crmrte)
# One below is good
plot(x=1/(clean$prbconv), y=clean$crmrte)
plot(x=exp(-clean$prbconv), y=clean$crmrte)
plot(x=clean$prbconv, y=log10(clean$crmrte))

# Impose different transformations to visualize 'polpc'
plot(x=clean$polpc, y=clean$crmrte)
plot(x=1/(clean$polpc), y=clean$crmrte)
plot(x=exp(-clean$polpc), y=clean$crmrte)
# One below is good
plot(x=clean$polpc, y=log10(clean$crmrte))
plot(x=log10(clean$polpc), y=clean$crmrte)
plot(x=log10(clean$polpc), y=log10(clean$crmrte))

# Regression of 'crmrte' on 'prbarr'
probs <- lm(clean$crmrte ~ clean$prbarr)
probs$coefficients
summary(probs)

# Regression of 'crmrte' on 'prbconv'
probs <- lm(clean$crmrte ~ clean$prbconv)
probs$coefficients
summary(probs)

# Regression of 'crmrte' on 'prbarr' and 'prbconv'
probs <- lm(clean$crmrte ~ clean$prbarr + clean$prbconv)
probs$coefficients
summary(probs)

# Regression of 'crmrte' on 'prbarr', 'prbconv', and 'prbpris'
probs <- lm(clean$crmrte ~ clean$prbarr + clean$prbconv + clean$prbpris)
probs$coefficients
summary(probs)

# Regression of 'crmrte' on 1/prbarr and 1/prbconv
inv_prbarr <- 1/clean$prbarr
inv_prbconv <- 1/clean$prbconv
inv_probs <- lm(clean$crmrte ~ inv_prbarr + inv_prbconv)
inv_probs$coefficients
summary(inv_probs)

# Regression of 'crmrte' on 'prbarr' and 1/prbconv
probs <- lm(clean$crmrte ~ clean$prbarr + inv_prbconv)
probs$coefficients
summary(probs)