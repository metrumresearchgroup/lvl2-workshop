##' ---
##' title: ""
##' date: ""
##' author: ""
##' output: github_document
##' ---


library(mrgsolve)
library(dplyr)
library(tidyr)

project <- "../devmodels/epo"
post <- readRDS("../devmodels/epo/post_real.RDS")

head(post)

mod <- mread("epo", project)

mod <- param(mod, THETA19 = mod$THETA19/2)
post <- mutate(post, THETA19 = THETA19/2)

qw <- ev(amt = 40000, ii = 168, addl = 3, rate = -2)

tiw <- ev_days(ev(amt = 7000, rate = -2), days="m,w,f", addl = 3)
qw <- filter(tiw, time==0) %>% mutate(amt = 40000)

data_sc <- bind_rows(tiw,qw) %>% mutate(ID = amt)

mod %>% 
  zero_re %>% 
  mrgsim(data = data_sc, end = 672) %>%
  plot

data_iv <- mutate(data_sc, cmt = 2, rate = 0)
mod %>% 
  zero_re %>% 
  mrgsim(data = data_iv, end = 672) %>%
  plot


iv_tiw <- ev_rep(tiw, id = 1:250) %>% mutate(cmt = 2, rate = 0)
iv_qw <- filter(iv_tiw, time==0) %>% mutate(amt = 40000, ID = ID + 1000)

data <- bind_rows(iv_tiw, iv_qw)

sim <- function(i, mod, data) {
 mod <- param(mod, slice(post,i))
 out <- mrgsim(mod, data = data, obsonly = TRUE,
               end = -1, add = c(672))
 mutate(out, irep = i, qw = as.integer(ID >= 1000))
}

sim(100, mod, data)


set.seed(10020)
mcRNG()
out <- parallel::mclapply(1:101, mc.cores = 8, 
                          sim, mod, data) %>% bind_rows


sum1 <- 
out %>% 
  group_by(irep,time,qw) %>%
  summarise(success = mean(HGBi > 8.5)) 

sum2 <- 
  sum1 %>%
  group_by(qw,time) %>% 
  summarise(PR = mean(success > 0.4))

sum2
