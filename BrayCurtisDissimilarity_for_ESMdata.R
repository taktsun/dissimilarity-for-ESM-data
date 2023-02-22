# ---------------------------------------------------------------------
# R script demonstration
# Calculating Bray-Curtis dissimilarity
# with grouped multivariate time series data

# Here, we use ratings on emotion regulation strategies repeatedly reported by multiple persons as the example dataset

# ---------------------------------------------------------------------

# =========================================
# Settings you may want to adjust
# =========================================

# If there are 2 or more all-zero observations, subcomponents cannot be calculated because of division by 0.
# Calculate all-moment comparison subcomponents by taking the means of available instances
allowSub.na.rm <- TRUE

#  whether missing values should be removed before computing the person-means
allowPerson.na.rm <- TRUE

# In this demonstration, each observation can be uniquely identified with ppnr (participant number) and triggerid (ESM beep)
varUniqueID <- c("ppnr","triggerid")

# =========================================
# Load required R packages
# =========================================

# Install the below if needed:
#     install.packages(c("betapart","haven"))
#     remotes::install_github("wviechtb/esmpack")

library(betapart)
library(haven) # for reading sav files
library(esmpack) # for calculating person-mean of Bray-Curtis dissimilarity
source("BrayCurtisDissimilarity_Calculate.R")

# =========================================
# Quickly reproduce Table 1 results
# =========================================
dfTable1 <- data.frame("ppnr" = rep(1,6),"triggerid"=c(1:6),
                       matrix(c(1,8,5,3,3,0,0,0,2,0,0,3), nrow = 6, ncol = 2,
                              dimnames = list(c(),c("Distraction","SocialSharing"))))
calcBrayCurtisESM(dfTable1, c("Distraction","SocialSharing"),"ppnr","triggerid")


# =========================================
# Step-by-step time series data preparation
# =========================================
#
# (1) Manually enter data
#     We make use of Edmund's data (see Table 1 of main text or Table SM1.2 of supplementary material 1)
#     We add a second set of data which is made up by reordering Edmund's data
#     We add a third set of data, Edmund with missing data, based on Edmund's data
#     We add a fourth set of data, Edmund with 2 time points of all-zero ratings, based on Edmund's data
#     We have 2 ER strategies here, distraction and social sharing

personName <- c("Edmund","EdmundReorder631452","EdMiss34", "EdZero34")
varNameManual <- c("Distraction","SocialSharing")
nt <- 6 # number of time points


np <- length(personName) # number of persons
nv <- length(varNameManual) # number of variables (ER strategies)
ppid<-unlist(lapply(1:np, function(x) rep(x,nt)))
ppname <- unlist(lapply(1:np, function(x) rep(personName[x],nt)))


#entering the same dataset by variable (strategy)
dataManual <- matrix(c(1,8,5,3,3,0,0,5,1,3,3,8,1,8,NA,NA,3,0,1,8,0,0,3,0, #Distraction
                       0,0,2,0,0,3,3,2,0,0,0,0,0,0,2,NA,0,3,0,0,0,0,0,3), #Social sharing
                     nrow = nt*np, ncol = nv, dimnames = list(c(),varNameManual))
#enter the same dataset by time point
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
names(identifiers) <- varUniqueID
dfManual <- data.frame(cbind(identifiers,dataManual))

# results of calculation
data.frame(ppname,calcBrayCurtisESM(dfManual, varNameManual,varUniqueID[1],varUniqueID[2], bSubnarm = allowSub.na.rm, bPersonnarm = allowPerson.na.rm))



# (2) example to reshape long data to wide data

# create a long dataset from the manual dataset for illustration...
dataLong <- reshape(dfManual, direction = "long", varying = varNameManual,v.names="Score", timevar = "Strategy", times = varNameManual, idvar = varUniqueID)
# Reshape back to wide format
dfLongToWide <- reshape(dataLong, idvar = varUniqueID, timevar = "Strategy", varying = varNameManual, direction = "wide")

calcBrayCurtisESM(dfLongToWide, varNameManual,varUniqueID[1],varUniqueID[2], bSubnarm = allowSub.na.rm, bPersonnarm = allowPerson.na.rm)


# (3) Load existing data - data in wide format already
# (i.e., each row is one observation, and each variable has a column

# Using Data1.sav from https://osf.io/mxjfh/ (Blanke et al., 2020) as an example:
rawdataExternal <- read_sav('Data1.sav')
# please identify the column names of variables you want to include
varNameExternal <- c("M_rum2","M_rum1","M_distr2","M_distr1","M_refl2","M_refl1")
# please identify the column names of person ID and beep number
oldUniqueID = c("ID_anonym","a_ftl_0")
identifiers <- rawdataExternal[,oldUniqueID]
names(identifiers) <- varUniqueID
dfExternal <- cbind(identifiers,rawdataExternal[,varNameExternal])


# results of calculation
calcBrayCurtisESM(dfExternal, varNameExternal,varUniqueID[1],varUniqueID[2], bSubnarm = allowSub.na.rm, bPersonnarm = allowPerson.na.rm)

