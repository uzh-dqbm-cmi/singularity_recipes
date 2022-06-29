FROM bioconductor/bioconductor_docker:RELEASE_3_14
# OR :latest, RELEASE_3_14
MAINTAINER Todor Gitchev <todor.gitchev@uzh.ch>

ENV DEBIAN_FRONTEND noninteractive

# install all
RUN apt-get update -y
RUN apt-get install -y parallel
RUN apt-get install -y git
# RUN apt-get install -y libxml2-dev

RUN apt-get install -y curl
 ## 3.9: https://repo.anaconda.com/miniconda/Miniconda3-py39_4.9.2-Linux-x86_64.sh
RUN curl https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh -o Miniconda3-latest-Linux-x86_64.sh
RUN chmod +x Miniconda3-latest-Linux-x86_64.sh
RUN ./Miniconda3-latest-Linux-x86_64.sh -b -p /opt/miniconda3

RUN export PATH=/opt/miniconda3/bin:$PATH

# take too much time, avoid if not needed
RUN /opt/miniconda3/bin/conda update -n base -c defaults conda

RUN /opt/miniconda3/bin/conda config --add channels conda-forge
RUN /opt/miniconda3/bin/conda config --add channels bioconda
RUN /opt/miniconda3/bin/conda config --add channels anaconda
RUN /opt/miniconda3/bin/conda config --add channels r
RUN /opt/miniconda3/bin/conda update --all

COPY bioinformatics/dna_toolbox_requirements.txt /
COPY bioinformatics/dna_toolbox_install_packages.R /

RUN /opt/miniconda3/bin/conda install --file /dna_toolbox_requirements.txt
RUN /opt/miniconda3/bin/conda install -c conda-forge mamba
RUN /opt/miniconda3/bin/mamba install snakemake -c conda-forge -c bioconda
# RUN /opt/miniconda3/bin/conda create -n LIQUORICE -c bioconda -c conda-forge liquorice ray
RUN R -f /dna_toolbox_install_packages.R

RUN apt-get autoremove -y
RUN apt-get clean

# check all is there
CMD conda list
CMD python --version
CMD pip --version
CMD Rscript --version
