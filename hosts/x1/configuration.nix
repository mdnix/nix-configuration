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

  # Kernel for Lunar Lake support
  boot.kernelPackages = pkgs.linuxPackages_latest;

  # Intel graphics (Lunar Lake Arc 140V)
  hardware.graphics = {
    enable = true;
    extraPackages = with pkgs; [
      intel-media-driver
      intel-vaapi-driver
      libvdpau-va-gl
    ];
  };

  # Enable Intel GPU driver (xe)
  boot.initrd.kernelModules = [ "xe" ];

  # Laptop power management
  services.auto-cpufreq = {
    enable = true;
    settings = {
      charger = {
        governor = "performance";
        turbo = "auto";
      };
      battery = {
        governor = "powersave";
        turbo = "auto";
      };
    };
  };

  # Better touchpad/trackpoint support
  services.libinput = {
    enable = true;
    touchpad = {
      naturalScrolling = true;
      tapping = true;
      disableWhileTyping = true;
    };
  };

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
