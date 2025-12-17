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
      # Core utilities
      git
      gnupg
      wget
      curl
      direnv
      nix-direnv
      sops
      age

      # Shell & terminal
      bash
      zsh-completions
      tmux
      starship

      # Editors & IDEs
      neovim
      vscode
      zed-editor
      heynote

      # Build tools & compilers
      gcc
      gnumake
      pkg-config
      cmake
      just

      # Go
      go
      gopls
      delve

      # Python
      python3

      # JavaScript/TypeScript
      nodejs
      bun

      # Rust
      rustc
      cargo
      rust-analyzer
      rustup

      # Zig
      zig
      zls

      # Nix
      nixd

      # Container tools
      lazydocker
      devpod

      # Kubernetes tools
      kubectl
      kubectx
      kubecolor
      krew
      k9s
      kind
      kubernetes-helm

      # Platform tools
      openshift
      talosctl
      talhelper
      omnictl

      # Infrastructure as Code
      packer
      opentofu

      # Git tools
      lazygit
      gitleaks
      pre-commit
      conform

      # SSH/Security
      keychain

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
