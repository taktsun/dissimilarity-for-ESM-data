# Dissimilarity-for-ESM-data
A demo on calculating Bray-Curtis dissimilarity with multivariate time series data which are grouped by persons. Here, we showcase with emotion regulation (ER) experience sampling method (ESM) data.

Download the below R script for annotated codes:

	BrayCurtisDissimilarity_for_ESMdata.R

# Required packages
	# Install the below if needed:
	#     install.packages(c("betapart","haven"))
	#     remotes::install_github("wviechtb/esmpack")

	library(betapart)
	library(haven) # for reading sav files
	source("BrayCurtisDissimilarity_Calculate.R")
Download BrayCurtisDissimilarity_Calculate.R at this repo.

# Quickly reproducing Edmund's dataset
|ppnr|triggerid|Distraction|SocialSharing |
|---|----------|-----------|----|
|1|1|1|0|
|1|2|8|0|
|1|3|5|2|
|1|4|3|0|
|1|5|3|0|
|1|6|0|3|
Run the following code to get Edmund's dataset above, which is equivalent to Table 1 in the paper:

	dfTable1 <- data.frame("ppnr" = rep(1,6),"triggerid"=c(1:6),
	                       matrix(c(1,8,5,3,3,0,0,0,2,0,0,3), nrow = 6, ncol = 2,
	                       dimnames = list(c(),c("Distraction","SocialSharing"))))
Run the following code to calculate Bray-Curtis dissimilarity with Edmund's data:

	calcBrayCurtisESM(dfTable1, c("Distraction","SocialSharing"),"ppnr","triggerid")
# What is the output?
Per-observation (moment-level in ESM study) output:
- BrayCurtisFull.suc:	The full Bray-Curtis dissimilarity index calculated in successive difference
- BrayCurtisRepl.suc:	The replacement subcomponent calculated in successive difference
- BrayCurtisNest.suc:	The nestedness subcomponent calculated in successive difference
- BrayCurtisFull.amm:	The full Bray-Curtis dissimilarity index calculated in all-moment comparison
- BrayCurtisRepl.amm:	The replacement subcomponent calculated in all-moment comparison
- BrayCurtisNest.amm:	The nestedness subcomponent calculated in all-moment comparison

Group (person-level in ESM) output:
- person_BrayCurtisFull.suc:	Person-mean of BrayCurtisFull.suc
- person_... : Person-mean of other moment level dissimilarity 
# What is needed to use calculate dissimilarity?
- Values >=0
- At least 2 observations (e.g. Time Point 1 to 6), where 
	- both have at least 2 variables (e.g., Distraction and Social Sharing)  with values
- Wide data format (see below on how to reshape data from long format to wide format)
- At least 1 observation has at least 1 non-zero value
# Why is there NA/NaN?
In general,
- NA is due to missing data
- NaN is due to division by zero, brought by zero values in all variables

Let's denote the moment of interest as *t* .
- For successive difference, 
	- missing data at *t* or *t-1* will return NA
	- zero values for all variables at *t* **and** *t-1* will return NaN for **the full index** 
	- zero values for all variables at *t* **or** *t-1* will return NaN for **all subcomponents** 
- For all-moment comparison, missing data at *t*  will return NA  
- All-moment comparison is calculated by the mean of dissimilarity between *t* and all other moments.
	- If you set na.rm = TRUE in this calculation process, zero values for all variables
		- in >=2 observations will return NaN for **the full index and all subcomponents of THOSE observations** 
		- in only 1 observation will return NaN for **all subcomponents in THAT observation** 
	- If you set na.rm = FALSE in this calculation process, zero values for all variables
		- in >=2 observations will return NaN 
			- for **the full index of THOSE observations** 
			- for **all subcomponents in ALL observations** 
		- in only 1 observation will return NaN for **all subcomponents in ALL observations** 


