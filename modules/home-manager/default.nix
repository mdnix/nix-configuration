{ config, pkgs, inputs, ... }:

{
  home.username = "marco";
  home.homeDirectory = "/home/marco";
  home.stateVersion = "25.05";

  # Copy dotfiles to their respective locations
  home.file = {
    # Git configuration
    ".gitconfig".source = ../../files/dotfiles/.gitconfig;

    # Zsh configuration
    ".zshrc".source = ../../files/dotfiles/.zshrc;

    # Tmux configuration
    ".tmux.conf".source = ../../files/dotfiles/.tmux.conf;

    # Starship configuration
    ".config/starship.toml".source = ../../files/dotfiles/starship.toml;

    # Neovim configuration
    ".config/nvim".source = ../../files/dotfiles/nvim;
    ".config/nvim".recursive = true;

    # Ghostty configuration
    ".config/ghostty".source = ../../files/dotfiles/ghostty;
    ".config/ghostty".recursive = true;

    # Hyprland configuration
    ".config/hypr".source = ../../files/dotfiles/hypr;
    ".config/hypr".recursive = true;

    # Hyprpanel configuration
    ".config/hyprpanel".source = ../../files/dotfiles/hyprpanel;
    ".config/hyprpanel".recursive = true;

    # Wallpapers
    ".config/wallpapers".source = ../../files/wallpapers;
    ".config/wallpapers".recursive = true;
  };

  # Let Home Manager install and manage itself
  programs.home-manager.enable = true;
}