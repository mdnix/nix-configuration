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
      zed-editor
      vscode
      git
      gnupg
      wget
      curl
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
      rustc
      cargo
      rust-analyzer

      # container & k8s
      kubectl
      kubecolor
      kind
      kubernetes-helm
      openshift

      # Development tools
      lazygit
      lazydocker
      devpod

      # Virtualization
      virt-manager
      qemu

    ];

    # Enable fonts for development
    fonts.packages = with pkgs.unstable; [
      nerd-fonts.fira-code
    ];

    # Enable virtualization
    virtualisation = {
      docker.enable = true;
      libvirtd.enable = true;
    };

    # Add user to libvirtd and docker groups
    users.users.marco.extraGroups = [ "libvirtd" "docker" ];
  };
}
