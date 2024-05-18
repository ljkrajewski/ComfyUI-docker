#!/usr/bin/env bash
# This script downloads models used for the ComfyUI docker image and verifies their integrity.
# It should be ran _before_ running the docker build.

export set BASEDIR=`pwd`
export set CIVITAI_API=`cat ~/.ssh/civitai.key`
# To get a CivitAI API key:  https://education.civitai.com/civitais-guide-to-downloading-via-api/#step-by-step

function dlFromWeb {
#Usage: dlFromWeb 'https://github.com/xinntao/Real-ESRGAN/releases/download/v0.1.0/RealESRGAN_x4plus.pth'
  file="${1##*/}"
  [ ! -f $file ] && wget -c $1
}

function dlFromCivitAI {
#Usage: dlFromCivitAI '130072?type=Model&format=SafeTensor&size=pruned&fp=fp16'
# https://www.reddit.com/r/StableDiffusion/comments/1bkc428/bash_script_to_seamlessly_download_and_resume/
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

[ ! -d $BASEDIR/models/checkpoints ] && mkdir -p $BASEDIR/models/checkpoints
cd $BASEDIR/models/checkpoints
dlFromWeb 'https://huggingface.co/stabilityai/stable-diffusion-xl-base-1.0/resolve/main/sd_xl_base_1.0.safetensors'
dlFromCivitAI '456194' #Juggernaut XL (Juggernaut_X_RunDiffusion) -- https://civitai.com/models/133005?modelVersionId=456194
dlFromCivitAI '130072?type=Model&format=SafeTensor&size=pruned&fp=fp16' #Realistic Vision V6.0 B1 (V5.1 [VAE]) -- https://civitai.com/models/4201?modelVersionId=130072
dlFromCivitAI '293240' #Realism Engine SDXL (v3.0 VAE) -- https://civitai.com/models/152525?modelVersionId=293240

[ ! -d $BASEDIR/models/vae ] && mkdir -p $BASEDIR/models/vae
cd $BASEDIR/models/vae
dlFromWeb 'https://huggingface.co/stabilityai/sd-vae-ft-mse-original/resolve/main/vae-ft-mse-840000-ema-pruned.safetensors'

[ ! -d $BASEDIR/models/loras ] && mkdir -p $BASEDIR/models/loras
cd $BASEDIR/models/loras
dlFromWeb 'https://huggingface.co/stabilityai/stable-diffusion-xl-base-1.0/resolve/main/sd_xl_offset_example-lora_1.0.safetensors'
dlFromCivitAI '471794'   #Hands XL + SD 1.5 (Hands v3) -- https://civitai.com/models/200255?modelVersionId=471794
dlFromCivitAI '192247'   #RealNylonFeets XL - Feet in nylon -- https://civitai.com/models/171114/realnylonfeets-xl-feet-in-nylon
dlFromCivitAI '164714'   #RealPantyhose XL - Sheer Pantyhose (tan and black) -- https://civitai.com/models/147682/realpantyhose-xl-sheer-pantyhose-tan-and-black
dlFromCivitAI '471781'   #Feet XL + SD 1.5 (Feet v3) -- https://civitai.com/models/200251?modelVersionId=471781

[ ! -d $BASEDIR/models/controlnet ] && mkdir -p $BASEDIR/models/controlnet
cd $BASEDIR/models/controlnet
dlFromWeb 'https://huggingface.co/comfyanonymous/ControlNet-v1-1_fp16_safetensors/resolve/main/control_v11e_sd15_ip2p_fp16.safetensors'
dlFromWeb 'https://huggingface.co/comfyanonymous/ControlNet-v1-1_fp16_safetensors/resolve/main/control_v11e_sd15_shuffle_fp16.safetensors'
dlFromWeb 'https://huggingface.co/comfyanonymous/ControlNet-v1-1_fp16_safetensors/resolve/main/control_v11p_sd15_canny_fp16.safetensors'
dlFromWeb 'https://huggingface.co/comfyanonymous/ControlNet-v1-1_fp16_safetensors/resolve/main/control_v11f1p_sd15_depth_fp16.safetensors'
dlFromWeb 'https://huggingface.co/comfyanonymous/ControlNet-v1-1_fp16_safetensors/resolve/main/control_v11p_sd15_inpaint_fp16.safetensors'
dlFromWeb 'https://huggingface.co/comfyanonymous/ControlNet-v1-1_fp16_safetensors/resolve/main/control_v11p_sd15_lineart_fp16.safetensors'
dlFromWeb 'https://huggingface.co/comfyanonymous/ControlNet-v1-1_fp16_safetensors/resolve/main/control_v11p_sd15_mlsd_fp16.safetensors'
dlFromWeb 'https://huggingface.co/comfyanonymous/ControlNet-v1-1_fp16_safetensors/resolve/main/control_v11p_sd15_normalbae_fp16.safetensors'
dlFromWeb 'https://huggingface.co/comfyanonymous/ControlNet-v1-1_fp16_safetensors/resolve/main/control_v11p_sd15_openpose_fp16.safetensors'
dlFromWeb 'https://huggingface.co/comfyanonymous/ControlNet-v1-1_fp16_safetensors/resolve/main/control_v11p_sd15_scribble_fp16.safetensors'
dlFromWeb 'https://huggingface.co/comfyanonymous/ControlNet-v1-1_fp16_safetensors/resolve/main/control_v11p_sd15_seg_fp16.safetensors'
dlFromWeb 'https://huggingface.co/comfyanonymous/ControlNet-v1-1_fp16_safetensors/resolve/main/control_v11p_sd15_softedge_fp16.safetensors'
dlFromWeb 'https://huggingface.co/comfyanonymous/ControlNet-v1-1_fp16_safetensors/resolve/main/control_v11p_sd15s2_lineart_anime_fp16.safetensors'
dlFromWeb 'https://huggingface.co/comfyanonymous/ControlNet-v1-1_fp16_safetensors/resolve/main/control_v11u_sd15_tile_fp16.safetensors'

# T2I-Adapter
dlFromWeb 'https://huggingface.co/TencentARC/T2I-Adapter/resolve/main/models/t2iadapter_depth_sd14v1.pth'
dlFromWeb 'https://huggingface.co/TencentARC/T2I-Adapter/resolve/main/models/t2iadapter_seg_sd14v1.pth'
dlFromWeb 'https://huggingface.co/TencentARC/T2I-Adapter/resolve/main/models/t2iadapter_sketch_sd14v1.pth'
dlFromWeb 'https://huggingface.co/TencentARC/T2I-Adapter/resolve/main/models/t2iadapter_keypose_sd14v1.pth'
dlFromWeb 'https://huggingface.co/TencentARC/T2I-Adapter/resolve/main/models/t2iadapter_openpose_sd14v1.pth'
dlFromWeb 'https://huggingface.co/TencentARC/T2I-Adapter/resolve/main/models/t2iadapter_color_sd14v1.pth'
dlFromWeb 'https://huggingface.co/TencentARC/T2I-Adapter/resolve/main/models/t2iadapter_canny_sd14v1.pth'

# ControlNet SDXL
dlFromWeb 'https://huggingface.co/stabilityai/control-lora/resolve/main/control-LoRAs-rank256/control-lora-canny-rank256.safetensors'
dlFromWeb 'https://huggingface.co/stabilityai/control-lora/resolve/main/control-LoRAs-rank256/control-lora-depth-rank256.safetensors'
dlFromWeb 'https://huggingface.co/stabilityai/control-lora/resolve/main/control-LoRAs-rank256/control-lora-recolor-rank256.safetensors'
dlFromWeb 'https://huggingface.co/stabilityai/control-lora/resolve/main/control-LoRAs-rank256/control-lora-sketch-rank256.safetensors'

# ESRGAN upscale model
[ ! -d $BASEDIR/models/upscale_models ] && mkdir -p $BASEDIR/models/upscale_models
cd $BASEDIR/models/upscale_models
dlFromWeb 'https://github.com/xinntao/Real-ESRGAN/releases/download/v0.1.0/RealESRGAN_x4plus.pth'
dlFromWeb 'https://huggingface.co/sberbank-ai/Real-ESRGAN/resolve/main/RealESRGAN_x2.pth'
dlFromWeb 'https://huggingface.co/sberbank-ai/Real-ESRGAN/resolve/main/RealESRGAN_x4.pth'

# Verify Downloads
cd $BASEDIR
sha256sum -c models.sha256
