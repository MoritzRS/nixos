# needs to be run as root (sudo -i)

# Partition
parted /dev/vda -- mklabel gpt

parted /dev/vda -- mkpart primary 512MB -8GB
parted /dev/vda -- mkpart pimrary linux-swap -8GB 100%
parted /dev/vda -- mkpart ESP fat32 1MB 512MB
parted /dev/vda -- set 3 esp on

# formatting
mkfs.ext4 -L nixos /dev/vda1
mkswap -L swap /dev/vda2
mkfs.fat -F 32 -n boot /dev/vda3

# mounting
mount /dev/disk/by-label/nixos /mnt
mkdir -p /mnt/boot
mount /dev/disk/by-label/boot /mnt/boot
swapon /dev/vda2

# configuration
nixos-generate-config --root /mnt
cp /mnt/etc/nixos/hardware-configuration.nix hardware-configuration.nix

nixos-install --flake .#nixos