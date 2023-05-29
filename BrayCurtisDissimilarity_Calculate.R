# ===============================================================
# Function that calculates Bray-Curtis dissimilarity for ESM data
# ===============================================================
library(betapart)
calcBrayCurtisESM <- function (d, vn, pid, tid, bSubnarm = TRUE, bPersonnarm = TRUE){
  m<- d[,vn]
  # T/F values for each observation
  b_firstbeep<-as.vector(d[tid]==ave(d[tid], d[pid], FUN = min))
  d$b_firstbeep <- b_firstbeep
  d$b_completeER <- complete.cases(m)

  # Calculate Bray-Curtis dissimilarity (successive difference)
  d$BrayCurtisFull.suc <-NA
  d$BrayCurtisRepl.suc <-NA
  d$BrayCurtisNest.suc <-NA

  # calculating by loop on pairwise dissimilarity because calculating dissimilarity for large matrix takes a long time
  for (i in 1:nrow(d)){
    if(!d$b_firstbeep[i]){ # first beep of each person remains NA
      tempmat <- rbind(d[i,vn],setNames(d[i-1,vn],names(d[i,vn])))
      tempres <- bray.part(tempmat)
      d$BrayCurtisFull.suc[i] <- tempres$bray[1]
      d$BrayCurtisRepl.suc[i] <- tempres$bray.bal[1]
      d$BrayCurtisNest.suc[i] <- tempres$bray.gra[1]
    }
  }

  # Calculate Bray-Curtis dissimilarity (all-moment comparison)

  # exclude rows with all NA or only 1 available score, because bray.part needs at least 2 variables for calculation
  dTemp <- d[rowSums(is.na(d[,vn])) < (ncol(d[,vn])-1),
             append(c(pid,tid),vn)] #include only ER items and binding info
  vbray.full <- NULL
  vbray.repl <- NULL
  vbray.nest <- NULL
  for (i in 1:nrow(unique(dTemp[pid]))){
    dPerson <- dTemp[dTemp[pid]==unlist(unique(dTemp[pid]))[[i]],] # create a temp d for each person
    matx <- dPerson[,vn]
    nobs <- nrow(dPerson)
    resbray <- bray.part(matx)

    vtemp <- colMeans(as.matrix(resbray$bray))
    vtemp <- ifelse(bSubnarm & is.na(as.matrix(resbray$bray)[,1]),as.matrix(resbray$bray)[,1],vtemp)
    vbray.full <- append(vbray.full,vtemp*nobs/(nobs-1))
    vtemp <- colMeans(as.matrix(resbray$bray.bal),na.rm=bSubnarm)
    vtemp <- ifelse(bSubnarm & is.na(as.matrix(resbray$bray.bal)[,1]),as.matrix(resbray$bray.bal)[,1],vtemp)
    vbray.repl <- append(vbray.repl,vtemp*nobs/(nobs-1))
    vtemp <- colMeans(as.matrix(resbray$bray.gra),na.rm=bSubnarm)
    vtemp <- ifelse(bSubnarm & is.na(as.matrix(resbray$bray.gra)[,1]),as.matrix(resbray$bray.gra)[,1],vtemp)
    vbray.nest <- append(vbray.nest,vtemp*nobs/(nobs-1))
  }

  dTemp$BrayCurtisFull.amm <- vbray.full
  dTemp$BrayCurtisRepl.amm <- vbray.repl
  dTemp$BrayCurtisNest.amm <- vbray.nest

  dTemp<- dTemp[,setdiff(names(dTemp), vn)] # remove vn cols
  d<- merge(d,dTemp, by=c(pid,tid),all=TRUE)


  # calculate person-mean of dissimilarity
  d$person_BrayCurtisFull.suc <- ave(d$BrayCurtisFull.suc, d[pid], FUN = function(x) mean(x, na.rm = bPersonnarm))
  d$person_BrayCurtisRepl.suc <- ave(d$BrayCurtisRepl.suc, d[pid], FUN = function(x) mean(x, na.rm = bPersonnarm))
  d$person_BrayCurtisNest.suc <- ave(d$BrayCurtisNest.suc, d[pid], FUN = function(x) mean(x, na.rm = bPersonnarm))
  d$person_BrayCurtisFull.amm <- ave(d$BrayCurtisFull.amm, d[pid], FUN = function(x) mean(x, na.rm = bPersonnarm))
  d$person_BrayCurtisRepl.amm <- ave(d$BrayCurtisRepl.amm, d[pid], FUN = function(x) mean(x, na.rm = bPersonnarm))
  d$person_BrayCurtisNest.amm <- ave(d$BrayCurtisNest.amm, d[pid], FUN = function(x) mean(x, na.rm = bPersonnarm))

  d
}
