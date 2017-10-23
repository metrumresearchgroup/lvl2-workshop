
library(ggplot2)


beta0 <- 10
beta1 <- 0.5
.sd <- 5
.n <- 125

##' 
set.seed(10101)
x <- runif(125, 10, 100)
y <- beta0 + x*beta1 + rnorm(length(x), 0, .sd)
data <- data.frame(x=x, y=y)

ggplot(data=data, aes(x,y)) + geom_point()

saveRDS(file="data/linear.RDS", ascii=TRUE, data)

set.seed(212200)
ec50 <- 100
e0 <- 5
emax <- 20
.sd <- 1.5
x <- runif(125, 10,300)
y <- e0 + emax*x/(x+ec50) + rnorm(length(x), 0,.sd)
data <- data.frame(conc=x,effect=y)
ggplot(data=data, aes(conc,effect)) + geom_point()


pred <- function(p,data) {
 y.hat <- p[1] + p[2]*data$conc/(p[3]+data$conc)
 sum((y.hat-data$effect)^2)
}

fit <- optim(c(e0 = 3, emax = 10, ec50=100),
             pred, data=data, hessian=TRUE)

se <- sqrt(diag(solve(fit$hessian)))
data.frame(est = fit$par, se=se)
saveRDS(file="data/fit-your-turn.RDS", ascii=TRUE, data)
