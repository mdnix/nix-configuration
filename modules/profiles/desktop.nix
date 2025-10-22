{
  config,
  lib,
  pkgs,
  inputs,
  ...
}:
let
  cfg = config.profiles.desktop;
  inherit (lib) mkEnableOption mkIf;
in
{
  options.profiles.desktop.enable = mkEnableOption "Desktop environment with Hyprland";

  config = mkIf cfg.enable {
    # System-level Hyprland configuration
    programs.hyprland = {
      enable = true;
      withUWSM = true;
    };

    # Essential Wayland packages
    environment.systemPackages = with pkgs.unstable; [
      # Hyprland ecosystem
      hyprland
      hyprpaper
      hyprpanel
      hypridle
      hyprlock
      hyprsunset
      wofi

      # Wayland utilities
      qt6.qtwayland
      qt6ct
      hyprshot
      hyprpicker
      swappy
      imv
      wf-recorder
      wlr-randr
      wl-clipboard
      wayland-utils
      wayland-protocols

      # Essential desktop apps
      ghostty
      nautilus

      # Media and utilities
      vlc
      mpv
      spotify
      obs-studio
      pavucontrol
      brightnessctl
      cheese

      # System utilities
      networkmanagerapplet
      blueman
      gnome-themes-extra
      phinger-cursors
      libva
      dconf
      glib
      meson
    ];

    # Enable XDG portal for Hyprland
    xdg.portal = {
      enable = true;
      extraPortals = [ pkgs.xdg-desktop-portal-hyprland ];
    };

    # Sound is configured in system/audio.nix

    # Enable networking
    networking.networkmanager.enable = true;

    # Enable bluetooth
    hardware.bluetooth.enable = true;
    services.blueman.enable = true;

    # Enable polkit authentication agent
    security.polkit.enable = true;

    # Enable Flatpak
    services.flatpak.enable = true;

    # Enable UPower for battery information
    services.upower.enable = true;

    # Enable automatic mounting of USB devices
    services.udisks2.enable = true;
    services.gvfs.enable = true;

    # GTK dark theme configuration
    home-manager.users.marco = {
      gtk = {
        enable = true;
        theme = {
          name = "Adwaita-dark";
          package = pkgs.gnome-themes-extra;
        };
      };

      dconf.settings = {
        "org/gnome/desktop/interface" = {
          color-scheme = "prefer-dark";
          gtk-theme = "Adwaita-dark";
        };
      };
    };
  };
}
