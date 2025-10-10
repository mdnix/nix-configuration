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

      # Communication
      thunderbird
      discord
      zoom-us
      mullvad-vpn

      # Note-taking and productivity
      obsidian
      imagemagick
      _1password-gui
    ];

    # Enable printing
    services.printing.enable = true;
    services.printing.drivers = [ pkgs.unstable.hplip ];

    # Enable scanning
    hardware.sane.enable = true;

    # Enable Mullvad VPN
    services.mullvad-vpn.enable = true;
  };
}
