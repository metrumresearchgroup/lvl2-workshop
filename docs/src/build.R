source("libPaths.R")

library(rmarkdown)
library(knitr)
library(parallel)
library(mrgsolve)
library(dplyr)
library(knitr)
library(readr)
library(magrittr)
library(ggplot2)

build_doc <- function(input,..., output_dir = "docs/", quiet=FALSE)  {
  rmarkdown::render(input,..., output_dir=output_dir,quiet=quiet)
}

build_doc("categorical_r_rcpp.Rmd")


build_doc("handson_opg_answer.Rmd")

build_doc("target_attainment.Rmd")

build_doc("docs/src/intro.Rmd")

build_doc("fit_linear.Rmd")

build_doc("fit_mrgsolve.Rmd")

build_doc("sim_ebe.Rmd")

build_doc("fit_map_bayes.Rmd")

build_doc("fit_yoshikado.Rmd")

build_doc("fit_indometh.Rmd")

build_doc("fit_indometh_answer.Rmd")

build_doc("epo_pts.Rmd")

build_doc("meropenem_vpc.Rmd")

build_doc("azped.Rmd")

build_doc("annotated.Rmd")

#build_doc("docs/src/adaptive.Rmd")

build_doc("input_data_set.Rmd")

build_doc("plugin.Rmd")

build_doc("design.Rmd")

build_doc("target_attainment.Rmd")
