FROM python:3.11-slim-bookworm
LABEL maintainer="Todor Gitchev <todor.gitchev@uzh.ch>"

ENV DEBIAN_FRONTEND=noninteractive \
    UV_COMPILE_BYTECODE=1 \
    UV_LINK_MODE=copy \
    UV_PYTHON_DOWNLOADS=never \
    PYTHONUNBUFFERED=1

COPY --from=ghcr.io/astral-sh/uv:latest /uv /uvx /bin/
COPY bioinformatics/cfdna_tools_requirements.txt /

# build-essential is only needed to compile datrie (snakemake 7); purge it in this layer
RUN apt-get update -y \
    && apt-get install -y --no-install-recommends \
        bedtools \
        build-essential \
        fonts-dejavu-core \
        libcurl4 \
        libgomp1 \
    && uv pip install --system --no-cache -r /cfdna_tools_requirements.txt \
    && apt-get purge -y --auto-remove build-essential \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

RUN uv pip list && python --version \
    && python -c "import argparse, pysam, pyBigWig, pybedtools, pandas, numpy, scipy, yaml, matplotlib, snakemake; assert pandas.__version__.startswith('1.')"
