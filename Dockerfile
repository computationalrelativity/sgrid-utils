# Copyright (c) David Radice
# Distributed under the terms of the Modified BSD License.

ARG OWNER=dradice
FROM ubuntu:24.04
WORKDIR /work

LABEL maintainer="David Radice <david.radice@psu.edu>"

# Update and install basic packages
RUN apt-get update && \
    apt-get upgrade -y && \
    apt-get install --yes git build-essential liblapack-dev libsuitesparse-dev libgsl-dev

# Download Wolfgang's packages
RUN git clone https://github.com/wofti/Packages.git && \
    cd Packages/dctemplates_extBlasLapack && \
    make

# Download sgrid
RUN git clone https://github.com/sgridsource/sgrid.git
COPY MyConfig /work/sgrid 
RUN cd sgrid && make git_clone

# Patch DNSdata
COPY patches/DNSdata.patch /work/sgrid/src/Projects/DNSdata
RUN cd sgrid/src/Projects/DNSdata && patch -p1 < DNSdata.patch

# Build sgrid
RUN cd sgrid && make -j4

# Set working directory
WORKDIR /work/data

# Set entrypoint
ENTRYPOINT ["/work/sgrid/exe/sgrid"]
