### Filename: Dockerfile
FROM nvidia/cuda:12.4.1-cudnn-devel-ubuntu22.04
ARG BASEDIR=/usr/src
ARG COMFYDIR=$BASEDIR/ComfyUI
ARG LISTENPORT=8188

# Update image, install tools, & download ComfyUI from Github
WORKDIR $BASEDIR
RUN apt update && \
    apt upgrade -y && \
    apt install git curl wget python3 python3-pip -y && \
    git clone https://github.com/comfyanonymous/ComfyUI

## Copy models
WORKDIR $COMFYDIR
COPY models models

## Install dependencies
WORKDIR $COMFYDIR
RUN pip3 install --upgrade torch torchvision torchaudio && \
    pip3 install xformers!=0.0.18 -r requirements.txt --extra-index-url https://download.pytorch.org/whl/cu121 --extra-index-url https://download.pytorch.org/whl/cu118 --extra-index-url https://download.pytorch.org/whl/cu117  && \
    pip3 install accelerate && \
    pip3 install einops transformers>=4.25.1 safetensors>=0.3.0 aiohttp pyyaml Pillow scipy tqdm psutil  && \
    pip3 install torchsde
#    pip3 install torch==2.1.0 torchvision torchaudio --index-url https://download.pytorch.org/whl/cu121  && \
   
## Install custom nodes
# ltdrdata/ComfyUI-Manager
WORKDIR $COMFYDIR/custom_nodes
RUN git clone https://github.com/ltdrdata/ComfyUI-Manager
WORKDIR $COMFYDIR
RUN pip3 install GitPython typer matplotlib && \
    python3 custom_nodes/ComfyUI-Manager/cm-cli.py restore-dependencies
# Fannovel16/comfy_controlnet_preprocessors
WORKDIR $COMFYDIR/custom_nodes
RUN git clone https://github.com/Fannovel16/comfy_controlnet_preprocessors
WORKDIR $COMFYDIR/custom_nodes/comfy_controlnet_preprocessors
#RUN sed -i 's/cu117/cu121/g' install.py && \
RUN python3 install.py

## Start ComfyUI
WORKDIR $COMFYDIR
EXPOSE $LISTENPORT   # Remember to use the '-p 80:8818' or '-P' flag with your 'docker run' command.
CMD python3 main.py --listen --port $LISTENPORT
