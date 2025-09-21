{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.profiles.tools;
  inherit (lib) mkEnableOption mkIf;
in
{
  options.profiles.tools.enable = mkEnableOption "System administration and utility tools";

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs.unstable; [
      # System monitoring
      htop
      btop
      iotop
      nethogs
      ncdu
      duf
      procs

      # Network tools
      nmap
      netcat-gnu
      tcpdump
      wireshark
      speedtest-cli
      iperf3

      # File utilities
      rsync
      rclone
      fzf
      fd
      ripgrep
      tree
      file
      lsof

      # Archive tools
      unrar
      p7zip
      zip
      unzip
      gzip
      xz

      # Text processing
      jq
      yq-go
      sed
      awk
      grep

      # System utilities
      stress
      stress-ng
      smartmontools
      hdparm
      lm_sensors
      usbutils
      pciutils

      # Backup and sync
      borgbackup
      syncthing
    ];

    # Enable syncthing service
    services.syncthing.enable = true;
  };
}