# ltpp3_g2_oobe

This repository contains scripts and other tools used to create a customized version of the tibbo-oobe package for the Size 3 Linux Tibbo Project PCB (LTPP3), Gen. 2.

If you just want to install latest version of the tibbo-oobe package to your device, run: 

```
sudo apt-get install tibbo-oobe
```

## Requirements to create a package.
Ubuntu 20.04 or later 

Installing the prerequisites: 
```
sudo apt-get install  build-essential debhelper \
                      devscripts dh-python dh-make \
                      dh-systemd gnupg2 lintian \
                      reprepro vim lintian \
                      config-package-dev
```
## Creating the package
From the root of this repository execute:
```
makeoobe.sh 
```
