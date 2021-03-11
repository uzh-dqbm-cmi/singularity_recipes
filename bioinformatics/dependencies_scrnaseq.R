# Title     : Install R package dependencies
# Objective : prepare environment to run the R scripts in this project
# Created by: todor
# Created on: 07.03.21

install_dependencies <- function(packages){
  for (package in packages){
    if (!requireNamespace(package, quietly = TRUE)) {
      install.packages(package, quietly = TRUE)
    } else {
      print(paste("Package", package, " already installed."))
    }

  }
}

install_Bioc_dependencies <- function(packages){
  if (!requireNamespace("BiocManager", quietly = TRUE))
    install.packages("BiocManager", quietly = TRUE)

  for (package in packages){
    if (!requireNamespace(package, quietly = TRUE)) {
      BiocManager::install(package, quietly = TRUE)
    } else {
      print(paste("Bioconductor package", package, " already installed."))
    }

  }
}

install_dependencies(packages = c("dplyr", "Seurat", "reshape", "data.table", "readr", "hash", "ggplot2",
                                  "scales", "RColorBrewer", "gridExtra", "grid", "gtable", "plotly"))

install_Bioc_dependencies(packages = c("SingleR", "Gviz", "Organism.dplyr", "GenomicRanges", "GenomicFeatures", "affy"))
# "backports",