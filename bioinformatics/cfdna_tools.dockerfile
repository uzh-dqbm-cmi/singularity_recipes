FROM python:3.11-slim-bookworm
LABEL maintainer="Todor Gitchev <todor.gitchev@uzh.ch>"

ENV DEBIAN_FRONTEND=noninteractive \
    UV_COMPILE_BYTECODE=1 \
    UV_LINK_MODE=copy \
    UV_PYTHON_DOWNLOADS=never \
    PYTHONUNBUFFERED=1

COPY --from=ghcr.io/astral-sh/uv:latest /uv /uvx /bin/
COPY bioinformatics/cfdna_tools_requirements.txt /

# TFP (02_fcc_count.sh) needs gawk specifically — mawk's srand is not
# deterministic across processes. bookworm samtools is 1.16.1 (TFP pins
# 1.22.1; both use only faidx/view/index). torch is installed from the
# CPU wheel index so the image does not pull CUDA.
RUN apt-get update -y \
    && apt-get install -y --no-install-recommends \
        fonts-dejavu-core \
        gawk \
        libcurl4 \
        libgomp1 \
        parallel \
        samtools \
    && uv pip install --system --no-cache -r /cfdna_tools_requirements.txt \
    && uv pip install --system --no-cache --index-url https://download.pytorch.org/whl/cpu torch \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

RUN uv pip list && python --version \
    && python -c "import numpy, pandas, scipy, pysam, yaml, matplotlib, sklearn, joblib, torch; assert sklearn.__version__ == '1.2.2'; assert numpy.__version__.startswith('1.26')" \
    && samtools --version \
    && command -v gawk \
    && command -v parallel
