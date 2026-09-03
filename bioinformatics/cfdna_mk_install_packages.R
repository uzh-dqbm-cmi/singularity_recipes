# Title     : Install R package dependencies
# Objective : prepare environment to run the R scripts in this project

# R -f continues after errors by default; fail the image build instead.
options(error = function() {
  traceback(2)
  quit(save = "no", status = 1)
})

install_dependencies <- function(packages) for (package in packages) if (!requireNamespace(package, quietly = TRUE)) install.packages(package, quietly = TRUE) else print(paste("Package", package, " already installed."))

if (!requireNamespace("BiocManager", quietly = TRUE)) install.packages("BiocManager", quietly = TRUE)

install_Bioc_dependencies <- function(packages) {
  for (package in packages) {
     if (!requireNamespace(package, quietly = TRUE)) {
       BiocManager::install(package, quietly = TRUE, ask = FALSE, update = FALSE)
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

install_dependencies(packages = c(
  "ggplot2", "optparse", "this.path", "remotes",
  "dplyr", "data.table", "scales", "R.utils", "matrixStats", "PSCBS"
))

# CNAclinic Imports plus ichorCNA Bioconductor deps still on the current release
install_Bioc_dependencies(packages = c(
  "HMMcopy", "GenomeInfoDb", "GenomicRanges", "IRanges",
  "Rsamtools", "QDNAseq", "QDNAseq.hg19",
  "DNAcopy", "CGHbase", "CGHcall", "Biobase", "annotate",
  "org.Hs.eg.db",
  "TxDb.Hsapiens.UCSC.hg19.knownGene",
  "TxDb.Hsapiens.UCSC.hg38.knownGene"
))

# copynumber was removed from Bioconductor 3.18; last release is 3.16.
# remotes cannot resolve it from current repos, so CNAclinic install was a no-op.
if (!requireNamespace("copynumber", quietly = TRUE)) {
  install.packages(
    "https://bioconductor.org/packages/3.16/bioc/src/contrib/copynumber_1.38.0.tar.gz",
    repos = NULL,
    type = "source"
  )
}

remotes::install_github(
  "sdchandra/CNAclinic",
  build_vignettes = FALSE,
  dependencies = TRUE,
  upgrade = "never"
)

remotes::install_github("broadinstitute/ichorCNA", upgrade = "never")

stopifnot(
  requireNamespace("ichorCNA", quietly = TRUE),
  requireNamespace("CNAclinic", quietly = TRUE)
)

# IF_NEEDED: install_jypiter_dependencies(packages = c('repr', 'IRdisplay', 'evaluate', 'crayon', 'pbdZMQ', 'uuid', 'digest'))
