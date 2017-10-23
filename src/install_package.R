
dir.create("/data/Rlibs", showWarnings = FALSE)

.libPaths("/data/Rlibs")

install.packages(c("dplyr", "readr","Rcpp", "RcppArmadillo", "rmarkdown",
                   "knitr", "tidyr", "ggplot2", "BH", "formatR", "rbenchmark",
                   "minqa", "RcppDE", "DEoptim", "PopED", "purrrlyr", "purrr", 
                   "broom", "shiny", "miniUI", "shinydashboard", "numDeriv",
                   "devtools", "git2r", "dmutate", "MASS", "config"),
                   lib = "/data/Rlibs")

devtools::install_github("metrumresearchgroup/mrgsolve", lib = "/data/Rlibs")

devtools::install_github("mrgsolve/mrgsolvetk", lib = "/data/Rlibs")

devtools::install_github("kylebmetrum/optimhelp", lib = "/data/Rlibs")


