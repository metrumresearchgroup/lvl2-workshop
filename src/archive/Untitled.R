.libPaths("/data/Rlibs")

library(ggplot2)
library(dplyr)
library(mrgsolve)


data(Indometh)

head(Indometh)

count(Indometh, Subject)

obs <- as.data.frame(Indometh) %>% 
  mutate(evid = 0, cmt = 0, ID = as.numeric(Subject)) 

dose <- 
  distinct(obs, ID) %>% 
  mutate(amt = 25, time = 0, conc = NA, evid = 1, cmt = 2)

data <- 
  bind_rows(obs, dose) %>% 
  arrange(ID, time) %>%
  mutate(Subject = NULL)


head(data)

dv <- obs$conc

obj <- function(p, theta, data, dv, pred = FALSE, obsonly = TRUE) {
  names(p) <- names(theta)
  p <- lapply(p,exp)
  mod <- param(mod, p)
  out <- mrgsim(mod, data = data, obsonly=obsonly)
  if(pred) return(as.data.frame(out))
  return(sum(((out$CP - dv))^2))
}


mod <- mread_cache("pk1", modlib())

theta <- log(c(CL = 1, V = 100))

obj(theta,theta,data,dv)

fit <- optim(par = theta, fn=obj, theta = theta, data=data, dv=dv)


pred <- obj(fit$par, theta, data, dv, pred = TRUE, obsonly = FALSE)


data$pred <- pred$CP
head(data)


ggplot(data = data) + 
  geom_point(aes(time,conc)) + 
  scale_y_continuous(trans="log") + 
  geom_point(aes(time,pred),col="firebrick")

mod <- mread_cache("pk2", modlib())


theta <- log(c(CL = 4, V2 = 5, Q = 4, V3 = 15))

obj(theta,theta,data,dv)

fit <- minqa::newuoa(par = theta, fn=obj, theta = theta, data=data, dv=dv)


exp(fit$par)

pred <- obj(fit$par, theta, data, dv, pred = TRUE, obsonly = FALSE)
predi <- obj(theta,  theta, data, dv, pred = TRUE, obsonly = FALSE)


data$pred <- pred$CP
data$predi <- predi$CP
head(data)
pred <- distinct(data, time, .keep_all = TRUE)

ggplot(data = data) + 
  geom_point(aes(time,conc)) + 
  scale_y_continuous(trans="log") + 
  geom_line(data=pred,aes(time,pred),col="firebrick", lwd=1) +
  geom_line(data=pred,aes(time,predi),col="darkgreen", lwd=1) 

theta <- log(c(CL = 8, V2 = 7, Q = 6, V3 = 9))

fit <- RcppDE::DEoptim(obj, lower = rep(-4,4), upper = rep(4,4), 
                       theta = theta, data = data, dv = dv)

exp(fit$optim$bestmem)
