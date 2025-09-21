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
      package = inputs.hyprland.packages."${pkgs.system}".hyprland;
      portalPackage = inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.xdg-desktop-portal-hyprland;
    };

    # Essential Wayland packages
    environment.systemPackages = with pkgs.unstable; [
      # Hyprland ecosystem (using inputs for latest)
      inputs.hyprland.packages.${pkgs.system}.hyprland
      inputs.hyprland.packages.${pkgs.system}.hyprpaper
      inputs.hyprpanel.packages.${pkgs.system}.default
      inputs.hyprland.packages.${pkgs.system}.hypridle
      inputs.hyprland.packages.${pkgs.system}.hyprlock
      wofi

      # Wayland utilities
      qt5.qtwayland
      qt6.qtwayland
      libsForQt5.qt5ct
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
      zen-browser
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
      direnv
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
  };
}