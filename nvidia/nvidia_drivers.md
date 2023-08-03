# Original link: https://www.murhabazi.com/install-nvidia-driver

## remove-purge driver
first to remove all driver I have installed before using :

```sudo apt-get purge nvidia-*```

```sudo apt-get update```

```sudo apt-get autoremove```

## install latest version
### search latest
```apt search nvidia-driver``` (install es: nvidia-driver-535)
### few dependencies

```sudo apt install libnvidia-common-535```

```sudo apt install libnividia-gl-535```
### install the final driver
```sudo apt install nvidia-driver-535```
### Check & update PATH
- reboot and check ```nvidia-smi```
- ```nvcc --version``` should not work (in your bashrc file you don't have the path to cuda). To fix this, 
  - ```sudo nano /etc/bash.bashrc``` and append ```export PATH="/usr/local/cuda/bin:$PATH"``` at the end (system wide bashrc config)

### Update nvidia-container-toolkit
https://docs.nvidia.com/datacenter/cloud-native/container-toolkit/latest/install-guide.html#step-1-install-nvidia-container-toolkit
