### Filename: Dockerfile
# Based on https://raw.githubusercontent.com/ltdrdata/ComfyUI-Manager/main/scripts/install-comfyui-venv-linux.sh
FROM nvidia/cuda:12.4.1-cudnn-devel-ubuntu22.04
ARG BASEDIR=/usr/src
ARG COMFYDIR=$BASEDIR/ComfyUI
#ARG LISTENPORT=8188

# Update image, install tools, & download ComfyUI from Github
WORKDIR $BASEDIR
RUN apt update && \
    apt upgrade -y && \
    apt install git curl wget python3 python3-pip -y && \
    ln -s /usr/bin/python3 /usr/bin/python && \
    git clone https://github.com/comfyanonymous/ComfyUI
WORKDIR $COMFYDIR/custom_nodes
RUN git clone https://github.com/ltdrdata/ComfyUI-Manager

## Copy models
WORKDIR $COMFYDIR
COPY models models

## Install dependencies
RUN pip install torch torchvision torchaudio --extra-index-url https://download.pytorch.org/whl/cu121 && \
    pip install -r requirements.txt && \
    pip install -r custom_nodes/ComfyUI-Manager/requirements.txt

## TO DO
# Needed custom notes:
#    Anything Everywhere
#    ImpactSegsAndMask
#    SAMLoader
#    UltralyticsDetectorProvider
#    SAMDetectorCombined
#    BboxDetectorSEGS
#    Anything Everywhere3
#    GetImageSize
#    Prompts Everywhere
#    Anything Everywhere?
#    IPAdapterModelLoader
#    PrepImageForClipVision
#    DWPreprocessor
#    IPAdapterApply
#    DetailerForEachDebug
#    NNLatentUpscale
#    CR Model Input Switch

## Start ComfyUI
WORKDIR $COMFYDIR
EXPOSE $LISTENPORT   
# Remember to use the '-p 80:8818' or '-P' flag with your 'docker run' command.
CMD python main.py --preview-method auto --listen --port 8188
