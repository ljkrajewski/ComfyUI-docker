### Filename: Dockerfile
FROM nvidia/cuda:12.4.1-cudnn-devel-ubuntu22.04
ARG BASEDIR=/usr/src
ARG COMFYDIR=$BASEDIR/ComfyUI
ARG LISTENPORT=8188

WORKDIR $BASEDIR
RUN apt update && \
    apt upgrade -y && \
    apt install git curl wget pip3 -y && \
    git clone https://github.com/comfyanonymous/ComfyUI

## Install dependencies
WORKDIR $COMFYDIR
RUN pip3 install xformers!=0.0.18 -r requirements.txt --extra-index-url https://download.pytorch.org/whl/cu121 --extra-index-url https://download.pytorch.org/whl/cu118 --extra-index-url https://download.pytorch.org/whl/cu117  && \
    pip3 install accelerate && \
    pip3 install einops transformers>=4.25.1 safetensors>=0.3.0 aiohttp pyyaml Pillow scipy tqdm psutil  && \
    pip3 install torch==2.1.0 torchvision torchaudio --index-url https://download.pytorch.org/whl/cu121  && \
    pip3 install torchsde

## Install custom nodes
WORKDIR $COMFYDIR/custom_nodes
RUN git clone https://github.com/ltdrdata/ComfyUI-Manager
WORKDIR $COMFYDIR
RUN pip3 install GitPython && \
    python3 custom_nodes/ComfyUI-Manager/cm-cli.py restore-dependencies

## Download models
# checkpoints
WORKDIR $COMFYDIR/models/checkpoints
RUN wget -c https://huggingface.co/stabilityai/stable-diffusion-xl-base-1.0/resolve/main/sd_xl_base_1.0.safetensors && \
    curl https://civitai.com/api/download/models/456194 -o Juggernaut_XL_RunDiffusion.safetensors -L && \
    curl https://civitai.com/api/download/models/130072 -o RealisticVisionV60B1.safetensors -L && \
    curl https://civitai.com/api/download/models/293240 -o RealismEngineSDXL_30VAE.safetensors -L
# VAEs
WORKDIR $COMFYDIR/models/vae
RUN wget -c https://huggingface.co/stabilityai/sd-vae-ft-mse-original/resolve/main/vae-ft-mse-840000-ema-pruned.safetensors
# LoRAs
WORKDIR $COMFYDIR/models/loras
RUN wget -c https://huggingface.co/stabilityai/stable-diffusion-xl-base-1.0/resolve/main/sd_xl_offset_example-lora_1.0.safetensors
# ControlNet
WORKDIR $COMFYDIR/models/controlnet
RUN wget -c https://huggingface.co/comfyanonymous/ControlNet-v1-1_fp16_safetensors/resolve/main/control_v11e_sd15_ip2p_fp16.safetensors && \
    wget -c https://huggingface.co/comfyanonymous/ControlNet-v1-1_fp16_safetensors/resolve/main/control_v11e_sd15_shuffle_fp16.safetensors && \
    wget -c https://huggingface.co/comfyanonymous/ControlNet-v1-1_fp16_safetensors/resolve/main/control_v11p_sd15_canny_fp16.safetensors && \
    wget -c https://huggingface.co/comfyanonymous/ControlNet-v1-1_fp16_safetensors/resolve/main/control_v11f1p_sd15_depth_fp16.safetensors && \
    wget -c https://huggingface.co/comfyanonymous/ControlNet-v1-1_fp16_safetensors/resolve/main/control_v11p_sd15_inpaint_fp16.safetensors && \
    wget -c https://huggingface.co/comfyanonymous/ControlNet-v1-1_fp16_safetensors/resolve/main/control_v11p_sd15_lineart_fp16.safetensors && \
    wget -c https://huggingface.co/comfyanonymous/ControlNet-v1-1_fp16_safetensors/resolve/main/control_v11p_sd15_mlsd_fp16.safetensors && \
    wget -c https://huggingface.co/comfyanonymous/ControlNet-v1-1_fp16_safetensors/resolve/main/control_v11p_sd15_normalbae_fp16.safetensors && \
    wget -c https://huggingface.co/comfyanonymous/ControlNet-v1-1_fp16_safetensors/resolve/main/control_v11p_sd15_openpose_fp16.safetensors && \
    wget -c https://huggingface.co/comfyanonymous/ControlNet-v1-1_fp16_safetensors/resolve/main/control_v11p_sd15_scribble_fp16.safetensors && \
    wget -c https://huggingface.co/comfyanonymous/ControlNet-v1-1_fp16_safetensors/resolve/main/control_v11p_sd15_seg_fp16.safetensors && \
    wget -c https://huggingface.co/comfyanonymous/ControlNet-v1-1_fp16_safetensors/resolve/main/control_v11p_sd15_softedge_fp16.safetensors && \
    wget -c https://huggingface.co/comfyanonymous/ControlNet-v1-1_fp16_safetensors/resolve/main/control_v11p_sd15s2_lineart_anime_fp16.safetensors && \
    wget -c https://huggingface.co/comfyanonymous/ControlNet-v1-1_fp16_safetensors/resolve/main/control_v11u_sd15_tile_fp16.safetensors
# T2I-Adapter
RUN wget -c https://huggingface.co/TencentARC/T2I-Adapter/resolve/main/models/t2iadapter_depth_sd14v1.pth && \
    wget -c https://huggingface.co/TencentARC/T2I-Adapter/resolve/main/models/t2iadapter_seg_sd14v1.pth && \
    wget -c https://huggingface.co/TencentARC/T2I-Adapter/resolve/main/models/t2iadapter_sketch_sd14v1.pth && \
    wget -c https://huggingface.co/TencentARC/T2I-Adapter/resolve/main/models/t2iadapter_keypose_sd14v1.pth && \
    wget -c https://huggingface.co/TencentARC/T2I-Adapter/resolve/main/models/t2iadapter_openpose_sd14v1.pth && \
    wget -c https://huggingface.co/TencentARC/T2I-Adapter/resolve/main/models/t2iadapter_color_sd14v1.pth && \
    wget -c https://huggingface.co/TencentARC/T2I-Adapter/resolve/main/models/t2iadapter_canny_sd14v1.pth
# ControlNet SDXL
RUN wget -c https://huggingface.co/stabilityai/control-lora/resolve/main/control-LoRAs-rank256/control-lora-canny-rank256.safetensors && \
    wget -c https://huggingface.co/stabilityai/control-lora/resolve/main/control-LoRAs-rank256/control-lora-depth-rank256.safetensors && \
    wget -c https://huggingface.co/stabilityai/control-lora/resolve/main/control-LoRAs-rank256/control-lora-recolor-rank256.safetensors && \
    wget -c https://huggingface.co/stabilityai/control-lora/resolve/main/control-LoRAs-rank256/control-lora-sketch-rank256.safetensors
WORKDIR $COMFYDIR/custom_nodes
RUN git clone https://github.com/Fannovel16/comfy_controlnet_preprocessors
WORKDIR $COMFYDIR/custom_nodes/comfy_controlnet_preprocessors
RUN python3 install.py
# ESRGAN upscale model
WORKDIR $COMFYDIR/models/upscale_models
RUN wget -c https://github.com/xinntao/Real-ESRGAN/releases/download/v0.1.0/RealESRGAN_x4plus.pth && \
    wget -c https://huggingface.co/sberbank-ai/Real-ESRGAN/resolve/main/RealESRGAN_x2.pth && \
    wget -c https://huggingface.co/sberbank-ai/Real-ESRGAN/resolve/main/RealESRGAN_x4.pth

## Start ComfyUI
WORKDIR $COMFYDIR
EXPOSE $LISTENPORT   # Remember to use the '-p 80:8818' flag with your 'docker run' command.
CMD python3 main.py --listen --port $LISTENPORT
