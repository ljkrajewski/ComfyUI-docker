#!/usr/bin/env bash
# This script downloads models used for the ComfyUI docker image and verifies their integrity.
# It should be ran _before_ running the docker build.

set PWD=`pwd`

[ ! -d $PWD/models/checkpoints ] && mkdir -p $PWD/models/checkpoints
cd $PWD/models/checkpoints
[ ! -f sd_xl_base_1.0.safetensors ] && wget -c https://huggingface.co/stabilityai/stable-diffusion-xl-base-1.0/resolve/main/sd_xl_base_1.0.safetensors
[ ! -f Juggernaut_XL_RunDiffusion.safetensors ] && curl https://civitai.com/api/download/models/456194 -o Juggernaut_XL_RunDiffusion.safetensors -L
[ ! -f RealisticVisionV60B1.safetensors ] && curl https://civitai.com/api/download/models/130072 -o RealisticVisionV60B1.safetensors -L
[ ! -f RealismEngineSDXL_30VAE.safetensors ] && curl https://civitai.com/api/download/models/293240 -o RealismEngineSDXL_30VAE.safetensors -L

[ ! -d $PWD/models/vae ] && mkdir -p $PWD/models/vae
cd $PWD/models/vae
[ ! -f vae-ft-mse-840000-ema-pruned.safetensors ] && wget -c https://huggingface.co/stabilityai/sd-vae-ft-mse-original/resolve/main/vae-ft-mse-840000-ema-pruned.safetensors

[ ! -d $PWD/models/loras ] && mkdir -p $PWD/models/loras
cd $PWD/models/loras
[ ! -f sd_xl_offset_example-lora_1.0.safetensors ] && wget -c https://huggingface.co/stabilityai/stable-diffusion-xl-base-1.0/resolve/main/sd_xl_offset_example-lora_1.0.safetensors

[ ! -d $PWD/models/controlnet ] && mkdir -p $PWD/models/controlnet
cd $PWD/models/controlnet
[ ! -f control_v11e_sd15_ip2p_fp16.safetensors ] && wget -c https://huggingface.co/comfyanonymous/ControlNet-v1-1_fp16_safetensors/resolve/main/control_v11e_sd15_ip2p_fp16.safetensors
[ ! -f control_v11e_sd15_shuffle_fp16.safetensors ] && wget -c https://huggingface.co/comfyanonymous/ControlNet-v1-1_fp16_safetensors/resolve/main/control_v11e_sd15_shuffle_fp16.safetensors
[ ! -f control_v11p_sd15_canny_fp16.safetensors ] && wget -c https://huggingface.co/comfyanonymous/ControlNet-v1-1_fp16_safetensors/resolve/main/control_v11p_sd15_canny_fp16.safetensors
[ ! -f control_v11f1p_sd15_depth_fp16.safetensors ] && wget -c https://huggingface.co/comfyanonymous/ControlNet-v1-1_fp16_safetensors/resolve/main/control_v11f1p_sd15_depth_fp16.safetensors
[ ! -f control_v11p_sd15_inpaint_fp16.safetensors ] && wget -c https://huggingface.co/comfyanonymous/ControlNet-v1-1_fp16_safetensors/resolve/main/control_v11p_sd15_inpaint_fp16.safetensors
[ ! -f control_v11p_sd15_lineart_fp16.safetensors ] && wget -c https://huggingface.co/comfyanonymous/ControlNet-v1-1_fp16_safetensors/resolve/main/control_v11p_sd15_lineart_fp16.safetensors
[ ! -f control_v11p_sd15_mlsd_fp16.safetensors ] && wget -c https://huggingface.co/comfyanonymous/ControlNet-v1-1_fp16_safetensors/resolve/main/control_v11p_sd15_mlsd_fp16.safetensors
[ ! -f control_v11p_sd15_normalbae_fp16.safetensors ] && wget -c https://huggingface.co/comfyanonymous/ControlNet-v1-1_fp16_safetensors/resolve/main/control_v11p_sd15_normalbae_fp16.safetensors
[ ! -f control_v11p_sd15_openpose_fp16.safetensors ] && wget -c https://huggingface.co/comfyanonymous/ControlNet-v1-1_fp16_safetensors/resolve/main/control_v11p_sd15_openpose_fp16.safetensors
[ ! -f control_v11p_sd15_scribble_fp16.safetensors ] && wget -c https://huggingface.co/comfyanonymous/ControlNet-v1-1_fp16_safetensors/resolve/main/control_v11p_sd15_scribble_fp16.safetensors
[ ! -f control_v11p_sd15_seg_fp16.safetensors ] && wget -c https://huggingface.co/comfyanonymous/ControlNet-v1-1_fp16_safetensors/resolve/main/control_v11p_sd15_seg_fp16.safetensors
[ ! -f control_v11p_sd15_softedge_fp16.safetensors ] && wget -c https://huggingface.co/comfyanonymous/ControlNet-v1-1_fp16_safetensors/resolve/main/control_v11p_sd15_softedge_fp16.safetensors
[ ! -f control_v11p_sd15s2_lineart_anime_fp16.safetensors ] && wget -c https://huggingface.co/comfyanonymous/ControlNet-v1-1_fp16_safetensors/resolve/main/control_v11p_sd15s2_lineart_anime_fp16.safetensors
[ ! -f control_v11u_sd15_tile_fp16.safetensors ] && wget -c https://huggingface.co/comfyanonymous/ControlNet-v1-1_fp16_safetensors/resolve/main/control_v11u_sd15_tile_fp16.safetensors

# T2I-Adapter
[ ! -f t2iadapter_depth_sd14v1.pth ] && wget -c https://huggingface.co/TencentARC/T2I-Adapter/resolve/main/models/t2iadapter_depth_sd14v1.pth
[ ! -f t2iadapter_seg_sd14v1.pth ] && wget -c https://huggingface.co/TencentARC/T2I-Adapter/resolve/main/models/t2iadapter_seg_sd14v1.pth
[ ! -f t2iadapter_sketch_sd14v1.pth ] && wget -c https://huggingface.co/TencentARC/T2I-Adapter/resolve/main/models/t2iadapter_sketch_sd14v1.pth
[ ! -f t2iadapter_keypose_sd14v1.pth ] && wget -c https://huggingface.co/TencentARC/T2I-Adapter/resolve/main/models/t2iadapter_keypose_sd14v1.pth
[ ! -f t2iadapter_openpose_sd14v1.pth ] && wget -c https://huggingface.co/TencentARC/T2I-Adapter/resolve/main/models/t2iadapter_openpose_sd14v1.pth
[ ! -f t2iadapter_color_sd14v1.pth ] && wget -c https://huggingface.co/TencentARC/T2I-Adapter/resolve/main/models/t2iadapter_color_sd14v1.pth
[ ! -f t2iadapter_canny_sd14v1.pth ] && wget -c https://huggingface.co/TencentARC/T2I-Adapter/resolve/main/models/t2iadapter_canny_sd14v1.pth

# ControlNet SDXL
[ ! -f control-lora-canny-rank256.safetensors ] && wget -c https://huggingface.co/stabilityai/control-lora/resolve/main/control-LoRAs-rank256/control-lora-canny-rank256.safetensors
[ ! -f control-lora-depth-rank256.safetensors ] && wget -c https://huggingface.co/stabilityai/control-lora/resolve/main/control-LoRAs-rank256/control-lora-depth-rank256.safetensors
[ ! -f control-lora-recolor-rank256.safetensors ] && wget -c https://huggingface.co/stabilityai/control-lora/resolve/main/control-LoRAs-rank256/control-lora-recolor-rank256.safetensors
[ ! -f control-lora-sketch-rank256.safetensors ] && wget -c https://huggingface.co/stabilityai/control-lora/resolve/main/control-LoRAs-rank256/control-lora-sketch-rank256.safetensors

# ESRGAN upscale model
[ ! -d $PWD/models/upscale_models ] && mkdir -p $PWD/models/upscale_models
cd $PWD/models/upscale_models
[ ! -f RealESRGAN_x4plus.pth ] && wget -c https://github.com/xinntao/Real-ESRGAN/releases/download/v0.1.0/RealESRGAN_x4plus.pth
[ ! -f RealESRGAN_x2.pth ] && wget -c https://huggingface.co/sberbank-ai/Real-ESRGAN/resolve/main/RealESRGAN_x2.pth
[ ! -f RealESRGAN_x4.pth ] && wget -c https://huggingface.co/sberbank-ai/Real-ESRGAN/resolve/main/RealESRGAN_x4.pth

# Verify Downloads
cd $PWD/models/
sha256sum -c models.sha256
