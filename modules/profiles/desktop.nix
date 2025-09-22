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
      pavucontrol
      brightnessctl

      # System utilities
      networkmanagerapplet
      blueman
      gnome-themes-extra
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
  };
}