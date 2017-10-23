logbr <- function() {
  x <- 10^seq(-5,5)
  sort(c(x,3*x))
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

knitr::knit_hooks$set(hook_test = function(before, options, envir) {
  if(before) {
    file <- file.path(options$dir, paste0(options$label, ".cpp"))
    writeLines(con=file, options$code)
  }
})

