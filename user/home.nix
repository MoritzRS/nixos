{ inputs, lib, config, pkgs, ... }: {
  nixpkgs.config.allowUnfree = true;
  
  home = {
    stateVersion = "22.11";
    username = "mrs";
    homeDirectory = "/home/mrs";
    packages = with pkgs; [
      php
      nodejs
      neovim
      google-chrome
      firefox
      epiphany
      obsidian
      apostrophe
      godot
    ];
  };

  security.pam.services.mrs.enableGnomeKeyring = true;

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

    "org/gnome/settings-daemon/plugins/power" = {
      "sleep-inactive-ac-type" = "nothing";
      "sleep-inactive-battery-type" = "nothing";
    };

    "org/gnome/desktop/session" = {
      idle-delay = "uint32 0";
    };
  };

  programs = {
    home-manager.enable = true;
    zsh = {
      enable = true;
      history = {
        size = 10000;
        path = "${config.xdg.dataHome}/zsh/history";
      };
    };
    starship = {
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
    git = {
      enable = true;
      userName = "MoritzRS";
    };
    vscode = {
      enable = true;
      extensions = with pkgs.vscode-extensions; [
        svelte.svelte-vscode
        bradlc.vscode-tailwindcss
        esbenp.prettier-vscode
        eamodio.gitlens
      ];
    };
  };
}