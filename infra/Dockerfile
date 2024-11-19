## Jupyter containers' base image
FROM jupyter/pyspark-notebook:latest AS base
USER root

# Image lightweight
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    rsync && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Configure Spark
ENV PYSPARK_PYTHON python3

# Install Jupyter notebook extensions
RUN pip install --upgrade notebook==6.4.12
RUN pip install jupyter_contrib_nbextensions
RUN jupyter contrib nbextension install
RUN jupyter nbextension enable /home/jovyan/work
# Set WORKDIR as /home/jovyan/work
WORKDIR /home/jovyan/work

# Expose the default port for Jupyter
EXPOSE 8888