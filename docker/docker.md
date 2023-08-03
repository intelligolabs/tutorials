# Building a docker image
In this folder you can find different dockerfiles for different purposes.
The general purpose images are based on the official Nvidia image `nvcr.io/nvidia/cuda:<version>` and are useful if you need a specific cuda version. These images come with pre-installed conda, tmux and htop, as well as cuda toolkit and cudnn.
## Building the image
1. Choose which image you want to build (based on the cuda version you need) and rename it to `Dockerfile`.
1. Navigate to the docker folder and build the image
```
docker build -t <image_name>:<image_tag> .
```
3. Start a container using the image
```
docker run --detach-keys="ctrl-\\,ctrl-\\" --privileged --gpus all -it -v ~:/home/$USER -v /media/data:/media/data <image_name>:<image_tag> <container_name>
```
`--detach-keys="ctrl-\\,ctrl-\\"` allows you to exit the container without killing it by pressing `ctrl+\` twice. This is needed because the default key combination `ctrl+p` and `ctrl+q` is used by vscode.
`--privileged` gives the container root access to the host machine
`--gpus all` gives the container access to all the GPUs on the host machine
`-it` starts the container in interactive mode
`-v` mounts the specified volumes to the container
`<image_name>:<image_tag>` specifies the image to use
`<container_name>` specifies the name of the container

### Example
```
docker build -t cuda:11.8 .
```
```
docker run --privileged --gpus all -it -v ~:/home/$USER -v /media/data:/media/data --detach-keys="ctrl-\\,ctrl-\\" --name test cuda:11.8 
```
These commands will build an image called `cuda:11.8` and start a container called `test` using the image. They will mount your home folder and the /media/data folder.


## Useful commands

### Exit the container
To exit the container WITHOUT KILLING IT press `ctrl+p` then `ctrl+q`. If you specified a different key combination (e.g. `ctrl-\\,ctrl-\\`) use that instead.
To KILL a container, type `exit`.

### Acces a pre-existing container
Get the container id with
```
docker ps
```
enter the container with
```
docker exec -it --detach-keys="ctrl-\\,ctrl-\\" <container id> bash
```
REMEMBER TO SET THE DETACH COMBINATION

### Kill a container running in the background
Get the container id with
```
docker ps
```
and then kill it with
```
docker kill <container id>
```


## Download a pre-built image
Check the official image tag on the [official Nvidia page](https://catalog.ngc.nvidia.com/orgs/nvidia/containers/cuda/tags)
Get the devel option 
```
docker pull <tag>
```
for example
```
docker pull nvcr.io/nvidia/cuda:11.8.0-cudnn8-devel-ubuntu22.04
```


## Create Conda environment
```
conda create -n test python=3.10
conda activate test
```
The conda environments will be only present inside the container, not on the host machine.

### install PyTorch
For compatibility issues with some libraries (xformer) it's important to compile Torch with the same cuda version you have installed
Check the CUDA version with: `nvcc --version`, the field to look for is ```release```
Check all the PyTorch versions for each CUDA version [here](https://pytorch.org/get-started/previous-versions/)
```
pip install torch==1.12.1+cu102 torchvision==0.13.1+cu102 torchaudio==0.12.1 --extra-index-url https://download.pytorch.org/whl/cu102
```

In general, you can use the below command, by specifiying the CUDA version in the url (without dots, e.g. 102 for 10.2)
```
pip install torch torchvision torchaudio --index-url https://download.pytorch.org/whl/cu<version>
```