# NIXOS SYSTEM CONFIG

## Setup

First you need to partition your device

```bash
parted /dev/sda -- mklabel gpt
parted /dev/sda -- mkpart ESP fat32 1MB 512MB
parted /dev/sda -- mkpart primary 512MB -20GB
parted /dev/sda -- mkpart primary linux-swap -20GB 100%
parted /dev/sda -- set 1 esp on

mkfs.fat -F 32 -n boot /dev/sda1
mkfs.ext4 -L nixos /dev/sda1
mkswap -L swap /dev/sda3

mount /dev/disk/by-label/nixos /mnt
mkdir -p /mnt/boot
mount /dev/disk/by-label/boot /mnt/boot
swapon /dev/disk/by-label/swap
```

After that you can clone the repo

```bash
git clone https://github.com/moritzrs/nixos-flake /mnt/etc/nixos
```

To Install, generate a config and start the install process

```bash
nixos-generate-config --root /mnt
nixos-install --flake /mnt/etc/nixos#nixos
```

To reconfigure an existing system:

```bash
nixos-rebuild switch --flake /mnt/etc/nixos#nixos
```

If you just want to use the home setup, you can do so

```
home-manager switch --flake /mnt/etc/nixos#mrs@nixos
```