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
### final
reboot and check ```nvidia-smi```