# Dissimilarity-for-ESM-data
A demo on calculating Bray-Curtis dissimilarity with multivariate time series data which are grouped by persons. Here, we showcase with emotion regulation (ER) experience sampling method (ESM) data.

Download the below R script for annotated codes:

	BrayCurtisDissimilarity_for_ESMdata.R
# So, what is Bray-Curtis dissimilarity?
Bray-Curtis dissimilarity is a way of measuring how different two sets of things are, based on the relative abundances of the things in each set. This is often used in ecology to compare the species composition of different environments or time points, but it can be used to compare any kind of set where each item has a numerical abundance - for example, intensities of using emotion regulation strategies.

<details>
  <summary>Click to expand on an example to calculate the full index</summary>

Imagine you want to see how Edmund use regulate his emotions upon hearing some shocking news, for example, feeling anxious on his safety hearing there is a war outbreak. Over the day, you ask Edmund to rate every 2 hours the intensity with which he used three different emotion regulation strategies, on a scale from 0 to 10, with 0 meaning they did not use the strategy at all and 10 meaning they used the strategy extremely intensively. The three strategies are cognitive reappraisal,  distraction, and social sharing. Here are the ratings you get for 11am and 1pm:

11am:

- Reappraisal: 2 
-  Distraction: 8
-   Social Sharing: 0

1pm:

- Reappraisal: 3  
- Distraction: 5
-   Social Sharing: 2

To calculate the Bray-Curtis dissimilarity within Edmund's reporting between 11am and 1pm, you:

1.  Add up the total intensity of using ER strategies for time point:

-   11am has a total of 10 (2+8+0)
-   1pm has a total of 10 (3+5+2)

2. Identify the set of minimum intensity across time points. the minimum intensity is 2 for reappraisal  (out of 2 and 3), 5 for distraction (5, 8), and 0 for social sharing (0,2). This makes a set of (2,5,0). 
3.  For each time point, add up the intensity exclusive to that time point. This is subtracting the set of intensity with the minimum set. So,

-   For 11am: (2+8+0) - (2+5+0) = 3
-   For 1pm: (3+5+2) - (2+5+0) = 3

3.  Add up the exclusive intensity of the two time points and divide it by the total intensity get Bray-Curtis dissimilarity:

-  (3+3)/(10+10) = 0.333

A value of 0 in Bray-Curtis dissimilarity would indicate that the two sets are identical, while a value of 1 would indicate that the two sets share no species in common. The Bray-Curtis dissimilarity between 11am and 1pm is 0.333. This tells you that the two time points are different, but not to a great extent.  

</details>

<details>
  <summary>Click to read about partitioning and its benefits</summary>

Apart from using its full index, partitioning Bray-Curtis dissimilarity into two subcomponents has been a common practice in ecological research for many years, as it can provide insight into the processes that are driving differences between communities. Specifically, Bray-Curtis dissimilarity can be partitioned into contributions from **replacement** (which describes how abundance of one species is shifted to another) and **nestedness** (which describes unidirectional changes in overall species abundance).

Replacement and nestedness describe numerically two analogous processes in the context of emotion regulation: replacement describes strategy switching, the simultaneous decrease in use of one strategy and increase in another; nestedness describes endorsement change, the unidirectional increase or decrease of intensity in all ER strategies use.

Let's look at the 11am and 1pm example again:
- the replacement subcomponent is given by the smaller of the exclusive intensity divided by the smaller total intensity between the two time points. Since both time points have the same exclusive intensity and total intensity,  replacement = 3/10 = 0.333.
- the nestedness subcomponent is given by the full index minus replacement subcomponent (it can be alternatively expressed - see next expandable subsection for details). So, nestedness = 0.333 - 0.333 = 0.
- In other words, the dissimilarity between Edmund's reporting at 11am and 1pm is solely due to replacement - or strategy switching.

Let us contrast the above example with another set of ratings we get from Edmund at 3pm:
- Reappraisal: 1
- Distraction: 3
- Social Sharing: 0

Repeating the calculation steps of Bray-Curtis dissimilarity between 1pm and 3pm:
- Total intensity = (3+5+2) + (1+3+0) = 10+4 = 14
- Minimum intensity set: {1,3,0}
- Exclusive intensity 1pm: (3+5+2) - (1+3+0) = 6
- Exclusive intensity 3pm: (1+3+0) - (1+3+0) = 0
- Bray-Curtis dissimilarity full index = (6+0)/14 = 0.429
- Replacement = (smaller exclusive intensity)/(smaller total intensity) = 0/4 = 0
- Nestedness = full index - replacement = 0.429 - 0 = 0.429

This time, the dissimilarity between Edmund's reporting at 11am and 1pm is solely due to nestedness - or endorsement change.

</details>

<details>
  <summary>Click to see the formulae of the full index and two subcomponents</summary>

### Intermediate calculation steps
Let *x* be a multivariate dataset with *N* variables reported over *n* measurement occasions,  so that *x*<sub>it</sub> refers to a particular value of the *i*<sup>th</sup> variable at time *t*.
$$A=\sum_{i=1}^{N}min(x_{ij},x_{ik})$$

$$B=\sum_{i=1}^{N}x_{ij}-A$$ $$C=\sum_{i=1}^{N}x_{ik}-A$$

### Formulae of Bray-Curtis dissimilarity and its subcomponents

**Bray-Curtis dissimilarity - full index** ( = replacement + nestedness)
$$\frac{B+C}{2A+B+C}$$
**Replacement subcomponent** ( = full index - nestedness)
$$\frac{min(B,C)}{2A+min(B,C)}$$
**Nestedness subcomponent** ( = full index - replacement)
$$\frac{\left | B-C \right |}{2A+B+C}\times \frac{A}{A+min(B,C)}$$

</details>

# Required packages
	# Install the below if needed:
	#     install.packages(c("betapart","haven"))
	#     remotes::install_github("wviechtb/esmpack")

	library(betapart)
	library(haven) # for reading sav files
	source("BrayCurtisDissimilarity_Calculate.R")
Download BrayCurtisDissimilarity_Calculate.R at this repo.

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


