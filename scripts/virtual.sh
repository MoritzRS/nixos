# Partitioning
parted /dev/sda -- mklabel gpt
parted /dev/sda -- mkpart ESP fat32 1MB 512MB
parted /dev/sda -- mkpart primary 512MB -20GB
parted /dev/sda -- mkpart primary linux-swap -20GB 100%
parted /dev/sda -- set 1 esp on

# Formatting
mkfs.fat -F 32 -n boot /dev/sda1
mkfs.ext4 -L nixos /dev/sda2
mkswap -L swap /dev/sda3

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
