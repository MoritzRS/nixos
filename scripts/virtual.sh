# Partitioning
parted /dev/vda -- mklabel gpt
parted /dev/vda -- mkpart ESP fat32 1MB 512MB
parted /dev/vda -- mkpart primary 512MB -20GB
parted /dev/vda -- mkpart primary linux-swap -20GB 100%
parted /dev/vda -- set 1 esp on

# Formatting
mkfs.fat -F 32 -n boot /dev/vda1
mkfs.ext4 -L nixos /dev/vda2
mkswap -L swap /dev/vda3

# Mounting
mount /dev/disk/by-label/nixos /mnt
mkdir -p /mnt/boot
mount /dev/disk/by-label/boot /mnt/boot
swapon /dev/disk/by-label/swap

# Cloning
git clone --depth=1 https://github.com/moritzrs/nixos /mnt/etc/nixos

# Generating
nixos-generate-config --root /mnt

# Installing
nixos-install --flake /mnt/etc/nixos#nixos
