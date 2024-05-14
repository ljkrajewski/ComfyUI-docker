# Filename: Dockerfile
FROM nvidia/cuda:12.4.1-cudnn-devel-ubuntu22.04
ARG BASEDIR=/usr/src
ARG COMFYDIR=$BASEDIR/ComfyUI

WORKDIR $BASEDIR
RUN apt update && \
    apt upgrade -y && \
    apt install git curl wget pip3 -y && \
    git clone https://github.com/comfyanonymous/ComfyUI

# Install dependencies
WORKDIR $COMFYDIR
RUN pip3 install accelerate && \
    pip3 install einops transformers>=4.25.1 safetensors>=0.3.0 aiohttp pyyaml Pillow scipy tqdm psutil  && \
    pip3 install xformers!=0.0.18 torch==2.1.0 torchvision torchaudio --index-url https://download.pytorch.org/whl/cu121  && \
    pip3 install torchsde

# Install custom nodes
WORKDIR $COMFYDIR/custom_nodes
RUN git clone https://github.com/ltdrdata/ComfyUI-Manager
WORKDIR $COMFYDIR
RUN pip3 install GitPython && \
    python custom_nodes/ComfyUI-Manager/cm-cli.py restore-dependencies

# Download models
WORKDIR $COMFYDIR/models
RUN wget -c https://huggingface.co/stabilityai/stable-diffusion-xl-base-1.0/resolve/main/sd_xl_base_1.0.safetensors -P checkpoints && \   ##checkpoints
    curl https://civitai.com/api/download/models/456194 -o checkpoints/Juggernaut_XL_RunDiffusion.safetensors -L && \
    curl https://civitai.com/api/download/models/130072 -o checkpoints/RealisticVisionV60B1.safetensors -L && \
    wget -c https://huggingface.co/stabilityai/sd-vae-ft-mse-original/resolve/main/vae-ft-mse-840000-ema-pruned.safetensors -P vae && \   ##VAEs
    wget -c https://huggingface.co/stabilityai/stable-diffusion-xl-base-1.0/resolve/main/sd_xl_offset_example-lora_1.0.safetensors -P vae && \
    wget -c https://huggingface.co/stabilityai/stable-diffusion-xl-base-1.0/resolve/main/sd_xl_offset_example-lora_1.0.safetensors -P loras && \   ##LoRAs
    wget -c https://huggingface.co/TencentARC/T2I-Adapter/resolve/main/models/t2iadapter_depth_sd14v1.pth -P controlnet && \   ##T2I-Adapter
    wget -c https://huggingface.co/TencentARC/T2I-Adapter/resolve/main/models/t2iadapter_seg_sd14v1.pth -P controlnet && \
    wget -c https://huggingface.co/TencentARC/T2I-Adapter/resolve/main/models/t2iadapter_sketch_sd14v1.pth -P controlnet && \
    wget -c https://huggingface.co/TencentARC/T2I-Adapter/resolve/main/models/t2iadapter_keypose_sd14v1.pth -P controlnet && \
    wget -c https://huggingface.co/TencentARC/T2I-Adapter/resolve/main/models/t2iadapter_openpose_sd14v1.pth -P controlnet && \
    wget -c https://huggingface.co/TencentARC/T2I-Adapter/resolve/main/models/t2iadapter_color_sd14v1.pth -P controlnet && \
    wget -c https://huggingface.co/TencentARC/T2I-Adapter/resolve/main/models/t2iadapter_canny_sd14v1.pth -P controlnet
