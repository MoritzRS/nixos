{ inputs, lib, config, pkgs, ... }: {
  imports = [
    ../hardware-configuration.nix
  ];

  # Standard Setup
  system.stateVersion = "23.05";
  nixpkgs.config.allowUnfree = true;

  # Nix Config
  nix.settings.experimental-features = "nix-command flakes";
  nix.settings.auto-optimise-store = true;
  nix.gc.automatic = true;
  nix.gc.date = "weekly";
  nix.gc.options = "--delete-older-than 30d";

  # Bootloader
  boot.kernelParams = ["quite" "loglevel=3"];
  boot.loader.timeout = 3;
  boot.loader.grub.enable = true;
  boot.loader.grub.device = "nodev";
  boot.loader.grub.efiSupport = true;
  boot.loader.grub.efiInstallAsRemovable = true;
  boot.loader.grub.useOSProber = true;
  boot.loader.grub.configurationLimit = 5;

  # Grub Theme
  boot.loader.grub2-theme.enable = true;
  boot.loader.grub2-theme.theme = "tela";
  boot.loader.grub2-theme.screen = "1080p";
  boot.loader.grub2-theme.footer = false;

  # Timezone
  time.timeZone = "Europe/Berlin";

  # Locale
  console.keyMap = "de";
  i18n.defaultLocale = "de_DE.UTF-8";
  i18n.extraLocaleSettings.LC_ADDRESS = "de_DE.UTF-8";
  i18n.extraLocaleSettings.LC_IDENTIFICATION = "de_DE.UTF-8";
  i18n.extraLocaleSettings.LC_MEASUREMENT = "de_DE.UTF-8";
  i18n.extraLocaleSettings.LC_MONETARY = "de_DE.UTF-8";
  i18n.extraLocaleSettings.LC_NAME = "de_DE.UTF-8";
  i18n.extraLocaleSettings.LC_NUMERIC = "de_DE.UTF-8";
  i18n.extraLocaleSettings.LC_PAPER = "de_DE.UTF-8";
  i18n.extraLocaleSettings.LC_TELEPHONE = "de_DE.UTF-8";
  i18n.extraLocaleSettings.LC_TIME = "de_DE.UTF-8";

  # Touchpad
  services.xserver.libinput.enable = true;
  services.xserver.libinput.touchpad.naturalScrolling = false;
  services.xserver.libinput.touchpad.middleEmulation = true;
  services.xserver.libinput.touchpad.tapping = true;

  # Gnome
  services.xserver.enable = true;
  services.xserver.layout = "de";
  services.xserver.displayManager.gdm.enable = true;
  services.xserver.desktopManager.gnome.enable = true;
  services.xserver.desktopManager.xterm.enable = false;
  environment.gnome.excludePackages = [ pkgs.gnome-tour ];

  # Printing
  services.printing.enable = true;

  # Audio
  security.rtkit.enable = true;
  services.pipewire.enable = true;
  services.pipewire.pulse.enable = true;
  services.pipewire.alsa.enable = true;
  services.pipewire.alsa.support32Bit = true;

  # Shell
  programs.zsh.enable = true;
  environment.shells = [ pkgs.zsh ];
  users.defaultUserShell = pkgs.zsh;

  # Fonts
  fonts.fonts = [
	pkgs.noto-fonts
	pkgs.noto-fonts-cjk
	pkgs.noto-fonts-emoji
	(pkgs.nerdfonts.override { fonts = [ "Hack" "JetBrainsMono" ]; })
  ];

  # System Packages
  environment.systemPackages = [
	# Basic Tools
	pkgs.vim
	pkgs.wget
	pkgs.git
	pkgs.gnome.gnome-tweaks

	# Application Runners
	pkgs.steam-run
	pkgs.appimage-run
  ];

  # Podman
  virtualisation.podman.enable = true;
  virtualisation.podman.dockerCompat = true;
  virtualisation.podman.defaultNetwork.settings.dns_enabled = true
 
  # User
  users.users.mrs.home = "/home/mrs";
  users.users.mrs.isNormalUser = true;
  users.users.mrs.description = "MoritzRS";
  users.users.mrs.initialPassword = "1234";
  users.users.mrs.extraGroups = [ "wheel" "networkmanager" ];
  security.pam.services.mrs.enableGnomeKeyring = true;
}