{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.profiles.office;
  inherit (lib) mkEnableOption mkIf;
in
{
  options.profiles.office.enable = mkEnableOption "Office productivity applications";

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs.unstable; [
      # Office suite
      libreoffice-fresh

      # PDF tools
      evince
      okular
      pdftk
      pandoc

      # Communication
      thunderbird
      discord
      zoom-us

      # Note-taking and productivity
      obsidian
      imagemagick
      _1password-gui

      # File management
      file-roller
      p7zip
      unzip
      zip
    ];

    # Enable printing
    services.printing.enable = true;
    services.printing.drivers = [ pkgs.unstable.hplip ];

    # Enable scanning
    hardware.sane.enable = true;
  };
}
