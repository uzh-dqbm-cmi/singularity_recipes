# Title     : Install R package dependencies
# Objective : prepare environment to run the R scripts in this project

install_dependencies <- function(packages) for (package in packages) if (!requireNamespace(package, quietly = TRUE)) install.packages(package, quietly = TRUE) else print(paste("Package", package, " already installed."))

if (!requireNamespace("BiocManager", quietly = TRUE)) install.packages("BiocManager", quietly = TRUE)

install_Bioc_dependencies <- function(packages) {
  for (package in packages) {
     if (!requireNamespace(package, quietly = TRUE)) {
       BiocManager::install(package, quietly = TRUE)
     } else {
       print(paste("Bioconductor package", package, " already installed."))
     }
  }
}

install_jypiter_dependencies <- function (packages) {
  if (!requireNamespace("IRkernel", quietly = TRUE)){
    install.packages("IRkernel", quietly = TRUE)
  }
  IRkernel::installspec(user = FALSE)
  install_dependencies(packages)
}

R.Version()
# update.packages(ask = FALSE)

#install_Bioc_dependencies(packages = c("org.Hs.eg.db", "TxDb.Hsapiens.UCSC.hg19.knownGene",
#                                       "TxDb.Hsapiens.UCSC.hg38.knownGene", "QDNAseq.hg19", "QDNAseq.hg38", "BSgenome.Hsapiens.UCSC.hg38",
#                                       "BSgenome.Hsapiens.UCSC.hg19"))

install_dependencies(packages = c("ggplot2", "optparse", "this.path", "remotes"))

install_Bioc_dependencies(packages = c("HMMcopy", "GenomeInfoDb", "GenomicRanges"))

remotes::install_github("sdchandra/CNAclinic", build_vignettes = FALSE, dependencies = TRUE)

remotes::install_github("broadinstitute/ichorCNA")

# IF_NEEDED: install_jypiter_dependencies(packages = c('repr', 'IRdisplay', 'evaluate', 'crayon', 'pbdZMQ', 'uuid', 'digest'))
