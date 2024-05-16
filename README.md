# ComfyUI-docker
The goal of this project is to create a working docker image running ComfyUI capable of running on shared computing services like RunPod with the nodes and models that I use.  It's not the goal to create an image for public consuption, but feel free to fork it and change it to fit your wants/needs/desires, but you're pretty much on your own (IOW, no support offered).

## Builing the docker image
1. Run *download_models.sh* to download the models and verify their integrity.
2. ```$ docker build <some other stuff here>```

## Useful links
- [comfyanonymous/ComfyUI [github]](https://github.com/comfyanonymous/ComfyUI)
- [Setting Up NVIDIA CUDA Toolkit in a Docker Container on Debian/Ubuntu](https://linuxconfig.org/setting-up-nvidia-cuda-toolkit-in-a-docker-container-on-debian-ubuntu)
- [_nvidia/cuda_ docker image [dockerhub]](https://hub.docker.com/r/nvidia/cuda/)
- [ComfyUI Command Line Arguments: Informational [reddit]](https://www.reddit.com/r/comfyui/comments/15jxydu/comfyui_command_line_arguments_informational/)
- [Docker Build: A Beginner’s Guide to Building Docker Images](https://stackify.com/docker-build-a-beginners-guide-to-building-docker-images/)
- [Dockerfile reference](https://docs.docker.com/reference/dockerfile/)
- [comfyui_colab_with_manager.ipynb [Google Colab]](https://colab.research.google.com/github/ltdrdata/ComfyUI-Manager/blob/main/notebooks/comfyui_colab_with_manager.ipynb)
