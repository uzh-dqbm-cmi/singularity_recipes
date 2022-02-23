FROM bioconductor/bioconductor_docker:devel
MAINTAINER Todor Gitchev <todor.gitchev@uzh.ch>

ENV DEBIAN_FRONTEND noninteractive

# install all
RUN apt-get update -y
RUN apt-get install -y parallel
RUN apt-get install -y git

RUN apt-get install curl
    ## 3.9: https://repo.anaconda.com/miniconda/Miniconda3-py39_4.9.2-Linux-x86_64.sh
RUN curl https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh -o Miniconda3-latest-Linux-x86_64.sh
RUN chmod +x Miniconda3-latest-Linux-x86_64.sh
RUN ./Miniconda3-latest-Linux-x86_64.sh -b -p /opt/miniconda3

# take too much time, avoid if not needed
RUN conda update -n base -c defaults conda

RUN conda config --add channels defaults
RUN conda config --add channels conda-forge
RUN conda config --add channels bioconda
RUN conda config --add channels r
RUN conda update --all

RUN conda install --file bioinformatics/requirements.txt

RUN R -f bioinformatics/install_packages.R

RUN apt-get autoremove -y
RUN apt-get clean
