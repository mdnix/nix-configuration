{ config, pkgs, ... }:

{
  imports = [
    #./disks.nix
    ./hardware-configuration.nix

    # System modules
    ../../modules/system/fonts.nix
    ../../modules/system/nix.nix
    ../../modules/system/audio.nix
    ../../modules/system/sddm.nix

    # Profile modules
    ../../modules/profiles/desktop.nix
    ../../modules/profiles/development.nix
    ../../modules/profiles/office.nix
    ../../modules/profiles/tools.nix
  ];

  # Enable profiles
  profiles = {
    desktop.enable = true;
    development.enable = true;
    office.enable = true;
    tools.enable = true;
  };

  # Boot loader
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Hostname
  networking.hostName = "x1";

  # Timezone and locale
  time.timeZone = "Europe/Zurich";
  i18n.defaultLocale = "en_US.UTF-8";

  # Keyboard layout
  services.xserver.xkb = {
    layout = "ch";
    options = "nodeadkeys";
  };

  # Enable zsh
  programs.zsh.enable = true;

  # User configuration
  users.users.marco = {
    isNormalUser = true;
    description = "Marco";
    shell = pkgs.zsh;
    extraGroups = [ "networkmanager" "wheel" "docker" ];
  };

  # Nix configuration is handled in system/nix.nix

  system.stateVersion = "25.05";
}
