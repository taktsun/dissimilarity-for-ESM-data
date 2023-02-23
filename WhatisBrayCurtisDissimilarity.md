
# What is Bray-Curtis dissimilarity?
Bray-Curtis dissimilarity is a way of measuring how different two sets of things are, based on the relative abundances of the things in each set. This is often used in ecology to compare the species composition of different environments or time points, but it can be used to compare any kind of set where each item has a numerical abundance - for example, intensities of using emotion regulation strategies.

# Example: Edmund's day in regulating his emotions

Imagine you want to see how Edmund regulates his emotions (e.g, the anxiety about safety upon hearing there is a war outbreak in a nearby country). Over the day, you ask Edmund to rate every 2 hours the intensity with which he used three different emotion regulation strategies, on a scale from 0 to 10, with 0 meaning he did not use the strategy at all and 10 meaning he used the strategy extremely intensively. The three strategies are cognitive reappraisal,  distraction, and social sharing. Here are the ratings you get for 11am and 1pm:

|Time|Reappraisal|Distraction|SocialSharing|
|---|----------|-----------|----|
|11am|2|8|0|
|1pm|3|5|2|
	
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

# Partitioning of Bray-Curtis disssimilarity and its benefits

Apart from using its full index, partitioning Bray-Curtis dissimilarity into two subcomponents has been a common practice in ecological research for many years, as it can provide insight into the processes that are driving differences between communities. Specifically, Bray-Curtis dissimilarity can be partitioned into contributions from **replacement** (which describes how abundance of one species is shifted to another) and **nestedness** (which describes unidirectional changes in overall species abundance).

Replacement and nestedness describe numerically two analogous processes in the context of emotion regulation: replacement describes strategy switching, the simultaneous decrease in use of one strategy and increase in another; nestedness describes endorsement change, the unidirectional increase or decrease of intensity in all ER strategies use.

Let's look at the 11am and 1pm example again:
- the replacement subcomponent is given by the smaller of the exclusive intensity divided by the smaller total intensity between the two time points. Since both time points have the same exclusive intensity and total intensity,  replacement = 3/10 = 0.333.
- the nestedness subcomponent is given by the full index minus replacement subcomponent (it can be alternatively expressed - see next expandable subsection for details). So, nestedness = 0.333 - 0.333 = 0.
- In other words, the dissimilarity between Edmund's reporting at 11am and 1pm is solely due to replacement - or strategy switching.

Let us contrast the above example with another set of ratings we get from Edmund at 3pm:

|Time|Reappraisal|Distraction|SocialSharing|
|---|----------|-----------|----|
|11am|2|8|0|
|1pm|3|5|2|
|3pm|1|3|0|


Repeating the calculation steps of Bray-Curtis dissimilarity between 1pm and 3pm:
- Total intensity = (3+5+2) + (1+3+0) = 10+4 = 14
- Minimum intensity set: (1,3,0)
- Exclusive intensity 1pm: (3+5+2) - (1+3+0) = 6
- Exclusive intensity 3pm: (1+3+0) - (1+3+0) = 0
- Bray-Curtis dissimilarity full index = (6+0)/14 = 0.429
- Replacement = (smaller exclusive intensity)/(smaller total intensity) = 0/4 = 0
- Nestedness = full index - replacement = 0.429 - 0 = 0.429

This time, the dissimilarity between Edmund's reporting at 11am and 1pm is solely due to nestedness - or endorsement change.

# Formulae of the full index and two subcomponents

### Intermediate calculation steps
Let *x* be a multivariate dataset with *N* variables reported over *n* measurement occasions,  so that *x*<sub>it</sub> refers to a particular value of the *i*<sup>th</sup> variable at time *t*.
$$A=\sum_{i=1}^{N}min(x_{ij},x_{ik})$$

$$B=\sum_{i=1}^{N}x_{ij}-A$$ 

$$C=\sum_{i=1}^{N}x_{ik}-A$$

### Formulae of Bray-Curtis dissimilarity and its subcomponents

**Bray-Curtis dissimilarity - full index** ( = replacement + nestedness)
$$\frac{B+C}{2A+B+C}$$
**Replacement subcomponent** ( = full index - nestedness)
$$\frac{min(B,C)}{2A+min(B,C)}$$
**Nestedness subcomponent** ( = full index - replacement)
$$\frac{\left | B-C \right |}{2A+B+C}\times \frac{A}{A+min(B,C)}$$


