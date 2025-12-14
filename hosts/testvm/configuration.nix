{ config, pkgs, ... }:

{
  imports = [
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

  # Enable profiles for testing
  profiles = {
    desktop.enable = true;
    development.enable = true;
    tools.enable = true;
    office.enable = true;
  };

  # Boot loader (GRUB for VM)
  boot.loader.grub.enable = true;
  boot.loader.grub.device = "/dev/vda";
  boot.loader.grub.useOSProber = true;

  # Hostname
  networking.hostName = "testvm";

  # Enable networking
  networking.networkmanager.enable = true;

  # Timezone and locale
  time.timeZone = "Europe/Zurich";
  i18n.defaultLocale = "en_US.UTF-8";

  # Keyboard layout
  services.xserver.xkb = {
    layout = "ch";
    variant = "de_nodeadkeys";
  };
  console.keyMap = "sg";

  # Enable zsh
  programs.zsh.enable = true;

  # User configuration
  users.users.marco = {
    isNormalUser = true;
    description = "Marco";
    shell = pkgs.zsh;
    extraGroups = [ "networkmanager" "wheel" "docker" "libvirtd" ];
  };

  # Enable SSH for remote access
  services.openssh.enable = true;

  services.spice-vdagentd.enable = true;
  services.qemuGuest.enable = true;

  system.stateVersion = "25.05";
}
