# Filename: Dockerfile
FROM nvidia/cuda:12.4.1-cudnn-devel-ubuntu22.04
WORKDIR /usr/src
RUN apt update && \
    apt upgrade -y && \
    apt install git -y && \
    git clone https://github.com/comfyanonymous/ComfyUI
WORKDIR /usr/src/ComfyUI
