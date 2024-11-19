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

FROM base AS dependencies
# Configure AWS (Required - AWS configuration files should be placed under aws/)
COPY ./conf/spark-defaults.conf "$SPARK_HOME/conf/spark-defaults.conf"
ENV SPARK_CONF_DIR="$SPARK_HOME/conf"
RUN curl -L -o $SPARK_HOME/jars/hadoop-aws-3.2.0.jar https://repo1.maven.org/maven2/org/apache/hadoop/hadoop-aws/3.2.0/hadoop-aws-3.2.0.jar/ \
RUN curl -L -o $SPARK_HOME/jars/aws-java-sdk-bundle-1.11.199.jar https://repo1.maven.org/maven2/com/amazonaws/aws-java-sdk-bundle/1.11.199/aws-java-sdk-bundle-1.11.199.jar/

# Install python libraries
COPY ./requirements.txt ./
RUN pip install -r requirements.txt

# Expose the default port for Jupyter
EXPOSE 8888