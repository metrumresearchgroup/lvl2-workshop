typef <- function(x) factor(x, c(1,2), c("Pitavastatin alone", "Pitavastatin + CsA"))

rotx <- function(angle=30) theme(axis.text.x = element_text(angle = angle, hjust = 1))
roty <- function(angle=30) theme(axis.text.y = element_text(angle = angle, hjust = 1))

noline <- ggplot2::element_blank()

theme_plain <- function(...) {
  require(ggplot2)
  theme_bw() + theme(panel.grid.major=noline,panel.grid.minor=noline, 
                     plot.margin=margin(0.5,0.5,1,0.5,unit="cm"),...)
}
cutq <- function(x,prefix=character(0)) {
  stopifnot(all(x > 0))
  lbl <- paste0(prefix,paste0("Q", c(1,2,3,4)))
  # get quantiles for non-placebos
  q <- quantile(x,c(0,0.25,0.5,0.75,1)) %>% unname
  # cut non-placebo records
  qs <- cut(x,breaks=q,include.lowest=TRUE,right=FALSE,labels=lbl)
  qs <- as.character(qs)
  # output
  y <- vector(mode="character", length=length(x))
  #' Assign placebo records
  # assign non-placebo records
  y <- qs
  # Order
  y <- factor(y,levels=c(lbl))
  y
}



datag <- function(amt) {
  out <- vector(mode="list",length=length(amt))
  for(i in seq_along(amt)) {
    cycle <- data_frame(amt=amt[i],time=0,evid=1,cmt=12,ID=i,ii=1,addl=20)
    out[[i]] <- bind_rows(cycle,mutate(cycle,time=28))
  }
  bind_rows(out)
}

knitr_config <- function() {
  knitr::opts_chunk$set(message = FALSE, comment = '.', warning = FALSE) 
}

logbr <- function() {
  x <- 10^seq(-5,5)
  sort(c(x,3*x))
}

.colSet1 <- function(...) ggplot2::scale_color_brewer(palette="Set1",...)
.fillSet1 <- function(...) ggplot2::scale_fill_brewer(palette="Set1",...)

nfact <- function(x,prefix="", suffix="",pad=TRUE) {
  ux <- sort(unique(x))
  if(pad) return(factor(x,ux, paste(prefix,ux,suffix)))
  return(factor(x,ux, paste0(prefix,ux,suffix)))
}
AUC <- function(data, time="TIME", id="ID", dv="DV") {
  if(any(is.na(data[[id]])))warning('id contains NA')
  if(any(is.na(data[[time]])))warning('time contains NA')
  if(any(is.na(data[[dv]])))warning('dv contains NA')
  data <- data[order(data[[id]],-data[[time]]),]
  nrec <- length(data[[time]])
  data$diff <- c(data[[time]][-nrec] - data[[time]][-1],0)
  data$meanDV <- c((data[[dv]][-1] + data[[dv]][-nrec])/2,0)
  data$dAUC <- data$diff*data$meanDV
  data <- data[order(data[[id]],data[[time]]),]
  data <- data[duplicated(data[[id]]),]
  AUC <- aggregate.data.frame(data$dAUC,by=list(data[[id]]),FUN=sum)
  names(AUC) <- c(id,"AUC")
  return(AUC)
}