{ inputs, lib, config, pkgs, ... }: {
  imports = [
    ./hardware-configuration.nix
  ];

  system.stateVersion = "22.11";

  nixpkgs = {
    config = {
      allowUnfree = true;
    };
  };

  nix = {
    settings = {
      experimental-features = "nix-command flakes";
      auto-optimise-store = true;
    };
    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 30d";
    };
  };


  boot = {
    kernelParams = [
      "quiet"
      "loglevel=3"
    ];
    loader = {
      timeout = 3;
      grub = {
        enable = true;
        device = "nodev";
        efiSupport = true;
        efiInstallAsRemovable = true;
        useOSProber = true;
        configurationLimit = 5;
      };
      grub2-theme = {
        enable = true;
        theme = "tela";
        screen = "1080p";
        footer = false;
      };
    };
  };

  time.timeZone = "Europe/Berlin";

  i18n.defaultLocale = "de_DE.UTF-8";
  i18n.extraLocaleSettings = {
    LC_ADDRESS = "de_DE.UTF-8";
    LC_IDENTIFICATION = "de_DE.UTF-8";
    LC_MEASUREMENT = "de_DE.UTF-8";
    LC_MONETARY = "de_DE.UTF-8";
    LC_NAME = "de_DE.UTF-8";
    LC_NUMERIC = "de_DE.UTF-8";
    LC_PAPER = "de_DE.UTF-8";
    LC_TELEPHONE = "de_DE.UTF-8";
    LC_TIME = "de_DE.UTF-8";
  };

  console.keyMap = "de";

  services = {
    xserver = {
      enable = true;
      layout = "de";
      xkbVariant = "";
      libinput = {
        enable = true;
        naturalScrolling = false;
        middleEmulation = true;
        tapping = true;
      };
      displayManager.gdm.enable = true;
      desktopManager.gnome.enable = true;
      desktopManager.xterm.enable = false;
      excludePackages = with pkgs; [
        xterm
      ];
    };
    printing.enable = true;
  };

  sound.enable = true;
  hardware = {
    bluetooth.enable = true;
    pulseaudio.enable = false;
  };
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    pulse.enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
  };

  environment = {
    systemPackages = with pkgs; [
      vim
      wget
      git
      gnome.gnome-tweaks
    ];
    shells = [ pkgs.zsh ];
    gnome.excludePackages = with pkgs; [
      gnome-tour
    ];
  };

  programs = {
    zsh.enable = true;
    dconf.enable = true;
  };

  fonts.fonts = with pkgs; [
    noto-fonts
    noto-fonts-cjk
    noto-fonts-emoji
    (nerdfonts.override { 
      fonts = ["Hack" "JetBrainsMono"];
    })
  ];

  users = {
    defaultUserShell = pkgs.zsh;
    users.mrs = {
      isNormalUser = true;
      initialPassword = "1234";
      description = "MoritzRS";
      extraGroups = [ "networkmanager" "wheel" ];
    };
  };




}