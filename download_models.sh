#!/usr/bin/env bash
# This script downloads models used for the ComfyUI docker image and verifies their integrity.
# It should be ran _before_ running the docker build.

set PWD=`pwd`
set CIVITAI_API=`cat ~/.ssh/civitai_apikey.txt`

function dlFromCivitAI {
#Usage: dlFromCivitAI '348913' 'JuggernautXL_v9-RunDiffusionPhoto2.safetensors'
#  [ ! -f $2 ] && curl https://civitai.com/api/download/models/$1 -o $2 -L
#}
#Usage: dlFromCivitAI '130072?type=Model&format=SafeTensor&size=pruned&fp=fp16'
# https://www.reddit.com/r/StableDiffusion/comments/1bkc428/bash_script_to_seamlessly_download_and_resume/
# To get a CivitAI API key:  https://education.civitai.com/civitais-guide-to-downloading-via-api/#step-by-step
  URL="https://civitai.com/api/download/models/$1"
  # Forcibly obtain filename via returned header truncated plain get
  FILENAME=$(curl -s -H "Authorization: Bearer $CIVITAI_API" -i -L --range '0-1' "$URL" | grep -a Content-Disposition | sed -n 's/.*filename=["]*\([^"]*\)["]*.*/\1/p')
  if [ -f "$FILENAME" ]; then
    echo "!!!! File $FILENAME already exists. Continuing via -L -C - -O \$filename:"
    curl -L -C - -o $FILENAME --retry 4 -H "Authorization: Bearer $CIVITAI_API" "$URL"
  else
    echo "========= Downloading into $FILENAME:"
    curl -JLO --retry 4 -H "Authorization: Bearer $CIVITAI_API" "$URL"
  fi
}

function dlFromHuggingFace {
#Usage: dlFromHuggingFace 'stabilityai/stable-diffusion-xl-base-1.0/resolve/main/sd_xl_base_1.0.safetensors'
  file="${1##*/}"
  [ ! -f $file ] && wget -c https://huggingface.co/$1
}

[ ! -d $PWD/models/checkpoints ] && mkdir -p $PWD/models/checkpoints
cd $PWD/models/checkpoints
dlFromHuggingFace 'stabilityai/stable-diffusion-xl-base-1.0/resolve/main/sd_xl_base_1.0.safetensors'
dlFromCivitAI '456194' #Juggernaut_XL_RunDiffusion.safetensors
dlFromCivitAI '130072?type=Model&format=SafeTensor&size=pruned&fp=fp16' #RealisticVisionV60B1.safetensors
dlFromCivitAI '293240' #RealismEngineSDXL_30VAE.safetensors

[ ! -d $PWD/models/vae ] && mkdir -p $PWD/models/vae
cd $PWD/models/vae
dlFromHuggingFace 'stabilityai/sd-vae-ft-mse-original/resolve/main/vae-ft-mse-840000-ema-pruned.safetensors'

[ ! -d $PWD/models/loras ] && mkdir -p $PWD/models/loras
cd $PWD/models/loras
dlFromHuggingFace 'stabilityai/stable-diffusion-xl-base-1.0/resolve/main/sd_xl_offset_example-lora_1.0.safetensors'
dlFromCivitAI '471794'   #Hands XL

[ ! -d $PWD/models/controlnet ] && mkdir -p $PWD/models/controlnet
cd $PWD/models/controlnet
dlFromHuggingFace 'comfyanonymous/ControlNet-v1-1_fp16_safetensors/resolve/main/control_v11e_sd15_ip2p_fp16.safetensors'
dlFromHuggingFace 'comfyanonymous/ControlNet-v1-1_fp16_safetensors/resolve/main/control_v11e_sd15_shuffle_fp16.safetensors'
dlFromHuggingFace 'comfyanonymous/ControlNet-v1-1_fp16_safetensors/resolve/main/control_v11p_sd15_canny_fp16.safetensors'
dlFromHuggingFace 'comfyanonymous/ControlNet-v1-1_fp16_safetensors/resolve/main/control_v11f1p_sd15_depth_fp16.safetensors'
dlFromHuggingFace 'comfyanonymous/ControlNet-v1-1_fp16_safetensors/resolve/main/control_v11p_sd15_inpaint_fp16.safetensors'
dlFromHuggingFace 'comfyanonymous/ControlNet-v1-1_fp16_safetensors/resolve/main/control_v11p_sd15_lineart_fp16.safetensors'
dlFromHuggingFace 'comfyanonymous/ControlNet-v1-1_fp16_safetensors/resolve/main/control_v11p_sd15_mlsd_fp16.safetensors'
dlFromHuggingFace 'comfyanonymous/ControlNet-v1-1_fp16_safetensors/resolve/main/control_v11p_sd15_normalbae_fp16.safetensors'
dlFromHuggingFace 'comfyanonymous/ControlNet-v1-1_fp16_safetensors/resolve/main/control_v11p_sd15_openpose_fp16.safetensors'
dlFromHuggingFace 'comfyanonymous/ControlNet-v1-1_fp16_safetensors/resolve/main/control_v11p_sd15_scribble_fp16.safetensors'
dlFromHuggingFace 'comfyanonymous/ControlNet-v1-1_fp16_safetensors/resolve/main/control_v11p_sd15_seg_fp16.safetensors'
dlFromHuggingFace 'comfyanonymous/ControlNet-v1-1_fp16_safetensors/resolve/main/control_v11p_sd15_softedge_fp16.safetensors'
dlFromHuggingFace 'comfyanonymous/ControlNet-v1-1_fp16_safetensors/resolve/main/control_v11p_sd15s2_lineart_anime_fp16.safetensors'
dlFromHuggingFace 'comfyanonymous/ControlNet-v1-1_fp16_safetensors/resolve/main/control_v11u_sd15_tile_fp16.safetensors'

# T2I-Adapter
dlFromHuggingFace 'TencentARC/T2I-Adapter/resolve/main/models/t2iadapter_depth_sd14v1.pth'
dlFromHuggingFace 'TencentARC/T2I-Adapter/resolve/main/models/t2iadapter_seg_sd14v1.pth'
dlFromHuggingFace 'TencentARC/T2I-Adapter/resolve/main/models/t2iadapter_sketch_sd14v1.pth'
dlFromHuggingFace 'TencentARC/T2I-Adapter/resolve/main/models/t2iadapter_keypose_sd14v1.pth'
dlFromHuggingFace 'TencentARC/T2I-Adapter/resolve/main/models/t2iadapter_openpose_sd14v1.pth'
dlFromHuggingFace 'TencentARC/T2I-Adapter/resolve/main/models/t2iadapter_color_sd14v1.pth'
dlFromHuggingFace 'TencentARC/T2I-Adapter/resolve/main/models/t2iadapter_canny_sd14v1.pth'

# ControlNet SDXL
dlFromHuggingFace 'stabilityai/control-lora/resolve/main/control-LoRAs-rank256/control-lora-canny-rank256.safetensors'
dlFromHuggingFace 'stabilityai/control-lora/resolve/main/control-LoRAs-rank256/control-lora-depth-rank256.safetensors'
dlFromHuggingFace 'stabilityai/control-lora/resolve/main/control-LoRAs-rank256/control-lora-recolor-rank256.safetensors'
dlFromHuggingFace 'stabilityai/control-lora/resolve/main/control-LoRAs-rank256/control-lora-sketch-rank256.safetensors'

# ESRGAN upscale model
[ ! -d $PWD/models/upscale_models ] && mkdir -p $PWD/models/upscale_models
cd $PWD/models/upscale_models
[ ! -f RealESRGAN_x4plus.pth ] && wget -c https://github.com/xinntao/Real-ESRGAN/releases/download/v0.1.0/RealESRGAN_x4plus.pth
dlFromHuggingFace 'sberbank-ai/Real-ESRGAN/resolve/main/RealESRGAN_x2.pth'
dlFromHuggingFace 'sberbank-ai/Real-ESRGAN/resolve/main/RealESRGAN_x4.pth'

# Verify Downloads
cd $PWD/models/
sha256sum -c models.sha256
