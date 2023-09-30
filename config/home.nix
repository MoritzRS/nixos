{ inputs, lib, config, pkgs, ... }: {
  
  # Standard Setup
  nixpkgs.config.allowUnfree = true;
  home.stateVersion = "22.11";
  home.username = "mrs";
  home.homeDirectory = "/home/mrs";
  programs.home-manager.enable = true;

  # Gnome Appearance
  dconf.settings."org/gnome/desktop/interface".enable-hot-corners = false;
  dconf.settings."org/gnome/desktop/interface".show-battery-percentage = true;
  dconf.settings."org/gnome/desktop/interface".color-scheme = "prefer-dark";
  dconf.settings."org/gnome/desktop/background".picture-uri = "file:///run/current-system/sw/share/backgrounds/gnome/blobs-l.svg";
  dconf.settings."org/gnome/desktop/background".picture-uri-dark = "file:///run/current-system/sw/share/backgrounds/gnome/blobs-d.svg";
  dconf.settings."org/gnome/desktop/screensaver".picture-uri = "file:///run/current-system/sw/share/backgrounds/gnome/drool-l.svg";
  
  # Gnome Power Management
  dconf.settings."org/gnome/settings-daemon/plugins/power".sleep-inactive-ac-type = "nothing";
  dconf.settings."org/gnome/settings-daemon/plugins/power".sleep-inactive-battery-type = "nothing";
  dconf.settings."org/gnome/desktop/session".idle-delay = "uint32 0";
  
  # Gnome Dash
  dconf.settings."org/gnome/shell".favorite-app = [
    "google-chrome.desktop"
    "firefox.desktop"
    "org.gnome.Epiphany.desktop"
    "code.desktop"
    "org.gnome.Console.desktop"
    "org.gnome.Nautilus.desktop"
    "gnome-system-monitor.desktop"
    "org.gnome.Settings.desktop"
  ];
    

  # User Shell
  programs.zsh.enable = true;
  programs.zsh.history.size = 1000;
  programs.zsh.history.path = "${config.xdg.dataHome}/zsh/history";
  programs.starship.enable = true;
  programs.starship.settings = { };

  # Git
  programs.git.enable = true;
  programs.git.userName = "MoritzRS";
  programs.git.userEmail = "moritzts@nixos";

  # VS-Code
  programs.vscode.enable = true;
  programs.vscode.extensions = [
    pkgs.vscode-extensions.esbenp.prettier-vscode
    pkgs.vscode-extensions.eamodio.gitlens
    pkgs.vscode-extensions.svelte.svelte-vscode
    pkgs.vscode-extensions.bradlc.vscode-tailwindcss
    pkgs.vscode-extensions.ms-python.python
    pkgs.vscode-extensions.ms-python.vscode-pylance
  ];

  # Other Programs
  home.packages = [
    # Development
    pkgs.php
    pkgs.nodejs_18
    pkgs.python3
    pkgs.sqlitebrowser
    pkgs.insomnia
    pkgs.godot

    # Browsers
    pkgs.google-chrome
    pkgs.firefox
    pkgs.epiphany
    
    # Note Taking
    pkgs.obsidian
    pkgs.apostrophe
  ];
}