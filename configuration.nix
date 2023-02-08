{ inputs, config, pkgs, ...}:
{

  system.stateVersion = "22.11";
  nix = {
    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 30d";
    };
  };

  imports = [
    ./hardware-configuration.nix
  ];

  # Bootloader
  boot = {
    kernelParams = [
      "quiet"
      "loglevel=3"
    ];
    loader = {
      timeout = 5;
      grub = {
        enable = true;
        device = "nodev";
        efiSupport = true;
        efiInstallAsRemovable = true;
        useOSProber = true;
        configurationLimit = 5;
      };
    };
    grub2-theme = {
      enable = true;
      theme = "stylish";
      screen = "1080p"
      footer = true;
    };
  };
  
  # Time
  time.timeZone = "Europe/Berlin";

  # Locale
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

  # GUI
  services.xserver = {
    enable = true;
    layout = "de";
    xkbVariant = "";
    displayManager.gdm.enable = true;
    desktopManager.gnome.enable = true;
    desktopManager.xterm.enable = false;
    excludePackages = [
      pkgs.xterm
    ];
  };

  # exclude gnome bloat
  environment.gnome.excludePackages = [
    pkgs.gnome-tour
  ];

  # Fonts
  fonts.fonts = with pkgs; [
    noto-fonts
    noto-fonts-cjk
    noto-fonts-emoji
    (nerdfonts.override { 
      fonts = ["Hack" "JetBrainsMono"];
    })
  ];

  # Shell
  programs.zsh = {
    enable = true;
  };

  services.printing.enable = true;

  # Sound (Pipewire)
  sound.enable = true;
  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    pulse.enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
  };

  # Packages
  nixpkgs.config.allowUnfree = true;
  environment.systemPackages = with pkgs; [
    vim
    wget
    gnome.gnome-tweaks
    git
  ];

  programs.dconf.enable = true;

  ##############################################################
  ##################### User Configuration #####################
  ##############################################################

  users.users.mrs = {
    isNormalUser = true;
    initialPassword = "1234";
    description = "MoritzRS";
    extraGroups = [ "networkmanager" "wheel" ];
    shell = pkgs.zsh;
  };
  
  home-manager.users.mrs = { config, pkgs, ...}: {
    home.stateVersion = "22.11";

    nixpkgs.config.allowUnfree = true;
    home.packages = with pkgs; [
      php
      nodejs
      neovim
      google-chrome
      firefox
      epiphany
      obsidian
      apostrophe
    ];

    programs.vscode = {
      enable = true;
      extensions = with pkgs.vscode-extensions; [
        svelte.svelte-vscode
        bradlc.vscode-tailwindcss
        esbenp.prettier-vscode
        eamodio.gitlens
      ];
    };

    programs.zsh = {
      enable = true;
      history = {
        size = 10000;
        path = "${config.xdg.dataHome}/zsh/history";
      };
    };

    programs.starship = {
      enable = true;
      settings = {
        add_newline = false;
        format = "$username[](fg:white bg:blue)$directory[](fg:blue bg:cyan)$git_branch$git_status[ ](fg:cyan)";
        username = {
          style_user = "bg:white fg:black";
          style_root = "bg:white fg:black";
          format = "[  ]($style)";
          disabled = false;
          show_always = true;
        };
        directory = {
          style = "bg:blue fg:black";
          format = "[ $path ]($style)";
        };
        git_branch = {
          symbol = "";
          style = "bg:cyan fg:black";
          format = "[ $symbol $branch ]($style)";
        };
        git_status = {
          style = "bg:cyan fg:black";
          format = "[$all_status$ahead_behind ]($style)";
        };
      };
    };

    dconf.settings = {
      "org/gnome/desktop/interface" = {
        color-scheme = "prefer-dark";
        enable-hot-corners = false;
      };

      "org/gnome/shell" = {
        favorite-apps = [
          "google-chrome.desktop"
          "firefox.desktop"
          "org.gnome.Epiphany.desktop"
          "code.desktop"
          "org.gnome.Console.desktop"
          "org.gnome.Nautilus.desktop"
          "gnome-system-monitor.desktop"
          "org.gnome.Settings.desktop"
        ];
      };

      "org/gnome/desktop/background" = {
        picture-uri = "file:///run/current-system/sw/share/backgrounds/gnome/blobs-l.svg";
        picture-uri-dark = "file:///run/current-system/sw/share/backgrounds/gnome/blobs-d.svg";
      };

      "org/gnome/desktop/screensaver" = {
        picture-uri = "file:///run/current-system/sw/share/backgrounds/gnome/drool-l.svg";
      };

      "org/gnome/desktop/interface" = {
        font-name = "JetBrainsMono Nerd Font 11";
        monospace-font-name = "JetBrainsMono Nerd Font Mono 10";
        document-font-name = "JetBrainsMono Nerd Font 11";
      };
    };

    programs.git = {
      enable = true;
      userName = "MoritzRS";
    };
  };

}