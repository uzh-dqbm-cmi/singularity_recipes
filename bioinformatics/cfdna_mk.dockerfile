FROM bioconductor/bioconductor_docker:RELEASE_3_23
# OR :previous, RELEASE_3_16
LABEL maintainer="Todor Gitchev <todor.gitchev@uzh.ch>"

ENV DEBIAN_FRONTEND=noninteractive

# install all
RUN apt-get update -y
RUN apt-get install -y parallel
RUN apt-get install -y git
# RUN apt-get install -y libxml2-dev

RUN apt-get install -y curl
## 3.9: https://repo.anaconda.com/miniconda/Miniconda3-py39_4.9.2-Linux-x86_64.sh
#RUN curl https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh -o Miniconda3-latest-Linux-x86_64.sh
#RUN chmod +x Miniconda3-latest-Linux-x86_64.sh
#RUN ./Miniconda3-latest-Linux-x86_64.sh -b -p /opt/miniconda3
## start with mamba
RUN curl -L "https://github.com/conda-forge/miniforge/releases/latest/download/Miniforge3-Linux-x86_64.sh" -o Miniforge3-Linux-x86_64.sh
RUN chmod +x ./Miniforge3-Linux-x86_64.sh
SHELL ["/bin/bash", "-c"]
RUN ./Miniforge3-Linux-x86_64.sh -b -p /opt/miniforge3

ENV PATH="/opt/miniforge3/bin:${PATH}"

# take too much time, avoid if not needed
# RUN /opt/miniforge3/bin/mamba update -n base -c defaults mamba

# only for conda
#RUN /opt/miniconda3/bin/conda config --add channels conda-forge
#RUN /opt/miniconda3/bin/conda config --add channels bioconda
#RUN /opt/miniconda3/bin/conda config --add channels anaconda
#RUN /opt/miniconda3/bin/conda config --add channels r
#RUN /opt/miniconda3/bin/conda update --all

COPY bioinformatics/cfdna_mk_requirements.txt /
COPY bioinformatics/cfdna_mk_install_packages.R /

RUN /opt/miniforge3/bin/mamba install --file /cfdna_mk_requirements.txt
RUN /opt/miniforge3/bin/mamba install bioconda::snakemake -c conda-forge -c bioconda
RUN R -f /cfdna_mk_install_packages.R

RUN apt-get autoremove -y
RUN apt-get clean

RUN mamba list && python --version && pip --version && Rscript --version \
    && Rscript -e 'stopifnot(requireNamespace("ichorCNA", quietly=TRUE), requireNamespace("CNAclinic", quietly=TRUE))'
