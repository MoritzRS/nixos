# Partitioning
parted /dev/nvme0n1 -- mklabel gpt;
parted /dev/nvme0n1 -- mkpart ESP fat32 1MB 512MB;
parted /dev/nvme0n1 -- mkpart primary 512MB -20GB;
parted /dev/nvme0n1 -- mkpart primary linux-swap -20GB 100%;
parted /dev/nvme0n1 -- set 1 esp on;

# Formatting
mkfs.fat -F 32 -n boot /dev/nvme0n1p1;
mkfs.ext4 -L nixos /dev/nvme0n1p2;
mkswap -L swap /dev/nvme0n1p3;

# Mounting
mount /dev/disk/by-label/nixos /mnt
mkdir -p /mnt/boot
mount /dev/disk/by-label/boot /mnt/boot
swapon /dev/disk/by-label/swap

# Cloning
git clone https://github.com/moritzrs/nixos /mnt/etc/nixos

# Generating
nixos-generate-config --root /mnt

# Installing
nixos-install --flake /mnt/etc/nixos#nixos
