




# Dissimilarity-for-ESM-data
A demo on calculating [Bray-Curtis dissimilarity](https://github.com/taktsun/dissimilarity-for-ESM-data/blob/3a285d405a1d05c30b7a4967a31e1cd98e97450e/WhatisBrayCurtisDissimilarity.md) with multivariate time series data which are grouped by persons. Here, we showcase with emotion regulation (ER) experience sampling method (ESM) data.

The demo code, based on [vignette.R](vignette.R), sources two files from the Internet. If you want to run this demo offline, please download:
- [BrayCurtisDissimilarity_Calculate.R](BrayCurtisDissimilarity_Calculate.R) from this repo
-  Data1.sav from https://osf.io/mxjfh/ as an example of external data

[Want to use your dataset right away? Read this section.](#using-an-existing-dataset)

# Required packages

	# Install the below if needed:
	    install.packages(c("betapart","haven"))

	# Load libraries
		library(betapart)
		library(haven) # for reading sav files

	# Download and source BrayCurtisDissimilarity_Calculate.R 
	# https://github.com/taktsun/dissimilarity-for-ESM-data
	
		source("https://github.com/taktsun/dissimilarity-for-ESM-data/raw/40c407b0ca9261eab56e8de822c3de1657645105/BrayCurtisDissimilarity_Calculate.R")


# Quickly reproducing Edmund's 2-variable dataset
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

	calcBrayCurtisESM(d = dfTable1, # dataframe
	                  vn =  c("Distraction","SocialSharing"), # list of variables
	                  pid = "ppnr", # participant identifier
	                  tid = "triggerid") # trigger/beep identifier
# What is the output?
New columns are created and attached to the original dataframe. 
In the context of an ESM study, an observation is a moment, and a group is a person.
|Variable|Level|Subcomponent?|Comparison approach|
|---|---|---|---|
|BrayCurtisFull.suc|Observation|Full index|Successive Difference|
|BrayCurtisRepl.suc|Observation|Replacement|Successive Difference|
|BrayCurtisNest.suc|Observation|Nestedness|Successive Difference|
|BrayCurtisFull.amm|Observation|Full index|All-moment|
|BrayCurtisRepl.amm|Observation|Replacement|All-moment|
|BrayCurtisNest.amm|Observation|Nestedness|All-moment|
|person_BrayCurtisFull.suc|Group|Full index|Successive Difference|
|person_BrayCurtisRepl.suc|Group|Replacement|Successive Difference|
|person_BrayCurtisNest.suc|Group|Nestedness|Successive Difference|
|person_BrayCurtisFull.amm|Group|Full index|All-moment|
|person_BrayCurtisRepl.amm|Group|Replacement|All-moment|
|person_BrayCurtisNest.amm|Group|Nestedness|All-moment|


# How should I prepare my data to calculate dissimilarity?
- Each target variable needs to be assigned to a separate column - see [example dataset above](#quickly-reproducing-edmunds-2-variable-dataset) as reference. If needed, at the end of this tutorial, there is a subsection on reshaping data.
- There is a grouping variable ("ppnr", person in ESM study)
- There is an observation number variable that does not repeat within a person ("triggerid", time point in ESM study)
- Sort data first by group (person), then observation (time point) in ascending order
- Do not remove any observations with missing data
- Make sure all variables have values >=0

Other conditions but they are likely to have been met:
- At least 2 observations (e.g., Time Point 1 to 6 has 6 observations), where: 
	- both have at least 2 variables (e.g., Distraction and Social Sharing) with values
	- At least 1 value is >0

# Using an existing dataset

If you want to use your own dataset, replace read_sav('https://osf.io/download/w8y33/') with read_sav('yourdata.sav'), read.csv('yourdata.csv'), or anything similar.

	# Using Data1.sav from https://osf.io/mxjfh/ (Blanke et al., 2020) as an example:
		rawdataExternal <- read_sav('https://osf.io/download/w8y33/')
	
	# identify the column names of variables you want to include
		varNameExternal <-
		c("M_rum2","M_rum1","M_distr2","M_distr1","M_refl2","M_refl1")
	# identify the column names of person ID and beep number
		pid = "ID_anonym" # participant identifer
		tid = "a_ftl_0" # trigger/beep identifer (within a person and should not reset with each day)
	# create a new dataframe, dfExternal...
		identifiers <- rawdataExternal[,c(pid,tid)]
		dfExternal <- cbind(identifiers,rawdataExternal[,varNameExternal])

	# results of calculation
		calcBrayCurtisESM(dfExternal, varNameExternal,pid,tid)


# Troubleshooting/Extra

## Can I use the script if my data are binary (0/1)? 

In [BrayCurtisDissimilarity_Calculate.R](BrayCurtisDissimilarity_Calculate.R), we make use of `bray.part()` from betapart to calculate Bray-Curtis dissimilarity. When used with binary data, `bray.part()` give the same calculation results as `beta.pair()`, a dedicated function for binary data,  as shown below.

	library(betapart)
	data(ceram.s) # a dataset from betapart with only binary/incidence data
	df<-ceram.s
	dis.binary <- beta.pair(df, index.family="sorensen") # Sørensen dissimilarity for binary data
	dis.bray <- bray.part(df) # Bray-Curtis dissimilarity

	# only name and attribute mismatches but no value mismatches
	all.equal(dis.binary,dis.bray)

	# if another index family dissimilarity is used (e.g., Ruzicka)
	dis.ruz <- beta.pair.abund(df, index.family = "ruz")
	# the values will be different, as shown by "mean relative difference:..."
	all.equal(dis.binary,dis.ruz)

This is not surprising, because Bray-Curtis dissimilarity is an extension of the Sørensen dissimilarity. The formula of Sørensen dissimilarity (see [Baselga, 2010](https://doi.org/10.1111/j.1466-8238.2009.00490.x)) is basically the same as that of Bray-Curtis dissimilarity (see [Baselga, 2013](https://doi.org/10.1111/2041-210X.12029)), except the data type that the formulae are pertained to be working with.

One drawback of `bray.part()` is that it doesn't not warn you if there are non-binary values in your data (i.e., values other than 0 or 1).
You are encouraged to cross-check the results between `bray.part()`and  `beta.pair()` before using our script to work with your binary ESM data.

## Why is there NA/NaN?
In general,
- NA is due to missing data
	- so the first observation of a person will always return NA for successive difference because there is no previous observation to compare with
- NaN is due to division by zero, brought by zero values in all variables

Let's denote the moment of interest as *t*.
- For successive difference, 
	- missing data at *t* or *t-1* will return NA
	- zero values for all variables at *t* **and** *t-1* will return NaN for **the full index** 
	- zero values for all variables at *t* **or** *t-1* will return NaN for **all subcomponents** 
- For all-moment comparison, missing data at *t* will return NA  
- All-moment comparison is calculated by the mean of dissimilarity between *t* and all other moments.
	- If you set na.rm = TRUE in this calculation process, zero values for all variables
		- in >=2 observations will return NaN for **the full index and all subcomponents of THOSE observations** 
		- in only 1 observation will return NaN for **all subcomponents in THAT observation** 
	- If you set na.rm = FALSE in this calculation process, zero values for all variables
		- in >=2 observations will return NaN 
			- for **the full index of THOSE observations** 
			- for **all subcomponents in ALL observations** 
		- in only 1 observation will return NaN for **all subcomponents in ALL observations** 

To understand these NA/NaN behaviours, run the following code and inspect the output:

	allowSub.na.rm <- TRUE
	allowPerson.na.rm <- TRUE
	personName <- c("Edmund","EdmundReorder631452","EdMiss34", "EdZero34")
	varNameManual <- c("Distraction","SocialSharing")
	nt <- 6 # number of time points


	np <- length(personName) # number of persons
	nv <- length(varNameManual) # number of variables (ER strategies)
	ppid<-unlist(lapply(1:np, function(x) rep(x,nt)))
	ppname <- unlist(lapply(1:np, function(x) rep(personName[x],nt)))


	#enter the dataset by variable (strategy)
		dataManual <- matrix(c(1,8,5,3,3,0,0,5,1,3,3,8,1,8,NA,NA,3,0,1,8,0,0,3,0, #Distraction
			       0,0,2,0,0,3,3,2,0,0,0,0,0,0,2,NA,0,3,0,0,0,0,0,3), #Social sharing
			     nrow = nt*np, ncol = nv, dimnames = list(c(),varNameManual))
	#an alternative way to enter the same dataset by time point
		dataManual <- matrix(c(1,0, #Edmund's data
			       8,0,
			       5,2,
			       3,0,
			       3,0,
			       0,3,
			       0,3, #Edmund's data reordered
			       5,2, #in the order of time point 6,3,1,4,5,2
			       1,0,
			       3,0,
			       3,0,
			       8,0,
			       1,0, #Edmund with missing data at time point 3 & 4
			       8,0,
			       NA,2,
			       NA,NA,
			       3,0,
			       0,3,
			       1,0, #Edmund with time point 3 & 4 rated all zeros
			       8,0, #Note how setting allowSub.na.rm = FALSE
			       0,0, #makes all all-moment subcomponents become NaN
			       0,0,
			       3,0,
			       0,3),
				byrow = TRUE, nrow = nt*np, ncol = nv, dimnames = list(c(),varNameManual))

	beep <- c(rep(1:nt,np))
	identifiers <- data.frame(cbind(ppid,beep))
	names(identifiers) <- c("ppnr","triggerid")
	dfManual <- data.frame(cbind(identifiers,dataManual))

	# results of calculation
		data.frame(ppname,calcBrayCurtisESM(dfManual, 
					varNameManual,"ppnr","triggerid", 
					bSubnarm = allowSub.na.rm, 
					bPersonnarm = allowPerson.na.rm))

## How do I reshape data to the required format?

You need to reshape your data if the target variables are in long format but not occupying separate columns. Note that you need to have run the codes from the above subsection about NA/NaN for the below codes to work:

	# create a long dataset from the manual dataset for illustration...
		dataLong <- reshape(dfManual, direction = "long", varying = varNameManual,v.names="Score", timevar = "Strategy", times = varNameManual, idvar =  c("ppnr","triggerid"))
	# reshape back to wide format
		dfLongToWide <- reshape(dataLong, idvar = c("ppnr","triggerid"), timevar = "Strategy", varying = varNameManual, direction = "wide")
	# the below should give the same output as before
		data.frame(ppname,calcBrayCurtisESM(dfLongToWide, varNameManual,"ppnr","triggerid", bSubnarm = allowSub.na.rm, bPersonnarm = allowPerson.na.rm))
