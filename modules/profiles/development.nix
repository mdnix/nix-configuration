{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.profiles.development;
  inherit (lib) mkEnableOption mkIf;
in
{
  options.profiles.development.enable = mkEnableOption "Developer environment packages and tools";

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs.unstable; [
      # editors & shells
      neovim
      git
      gnupg
      wget
      curl
      jq
      yq-go
      ripgrep
      fd
      tree
      htop
      btop
      direnv
      nix-direnv
      tmux
      starship
      zsh-completions

      # languages / build essentials
      gcc
      gnumake
      pkg-config
      cmake
      go
      gopls
      delve
      python3

      # container & k8s
      kubectl
      kind
      helm
      openshift

      # Development tools
      lazygit
      lazydocker
      devpod

      # Virtualization
      virt-manager
      qemu

      # Cloud & sync
      rclone
    ];

    # Enable fonts for development
    fonts.packages = with pkgs.unstable; [
      (nerdfonts.override { fonts = [ "FiraCode" ]; })
    ];

    # Enable virtualization
    virtualisation = {
      docker.enable = true;
      libvirtd.enable = true;
    };

    # Add user to libvirtd group for virt-manager
    users.users.marco.extraGroups = [ "libvirtd" ];
  };
}
