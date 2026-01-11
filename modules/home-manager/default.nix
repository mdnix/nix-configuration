{ config, pkgs, inputs, ... }:

let
  spicePkgs = inputs.spicetify-nix.legacyPackages.${pkgs.system};
  # Path to your dotfiles in the git repo (absolute path for out-of-store symlinks)
  dotfilesPath = "${config.home.homeDirectory}/Documents/gitrepos/nix-configuration/files/dotfiles";
  wallpapersPath = "${config.home.homeDirectory}/Documents/gitrepos/nix-configuration/files/wallpapers";
in
{
  imports = [
    inputs.spicetify-nix.homeManagerModules.spicetify
  ];

  home.username = "marco";
  home.homeDirectory = "/home/marco";
  home.stateVersion = "25.05";

  home.file = {
    # Git configuration
    ".gitconfig".source = config.lib.file.mkOutOfStoreSymlink "${dotfilesPath}/.gitconfig";

    # Zsh configuration
    ".zshrc".source = config.lib.file.mkOutOfStoreSymlink "${dotfilesPath}/.zshrc";

    # Tmux configuration
    ".tmux.conf".source = config.lib.file.mkOutOfStoreSymlink "${dotfilesPath}/.tmux.conf";

    # Starship configuration
    ".config/starship.toml".source = config.lib.file.mkOutOfStoreSymlink "${dotfilesPath}/starship.toml";

    # Neovim configuration
    ".config/nvim" = {
      source = config.lib.file.mkOutOfStoreSymlink "${dotfilesPath}/nvim";
      recursive = true;
      force = true;
    };

    # Ghostty configuration
    ".config/ghostty" = {
      source = config.lib.file.mkOutOfStoreSymlink "${dotfilesPath}/ghostty";
      recursive = true;
      force = true;
    };

    # Hyprland configuration
    ".config/hypr" = {
      source = config.lib.file.mkOutOfStoreSymlink "${dotfilesPath}/hypr";
      recursive = true;
      force = true;
    };

    # Hyprpanel configuration
    ".config/hyprpanel" = {
      source = config.lib.file.mkOutOfStoreSymlink "${dotfilesPath}/hyprpanel";
      recursive = true;
      force = true;
    };

    # Wofi configuration
    ".config/wofi" = {
      source = config.lib.file.mkOutOfStoreSymlink "${dotfilesPath}/wofi";
      recursive = true;
      force = true;
    };

    # Wallpapers
    ".config/wallpapers" = {
      source = config.lib.file.mkOutOfStoreSymlink "${wallpapersPath}";
      recursive = true;
      force = true;
    };
  };

  # Let Home Manager install and manage itself
  programs.home-manager.enable = true;

  # Spicetify (Spotify customization)
  programs.spicetify = {
    enable = true;
    enabledExtensions = with spicePkgs.extensions; [
      adblockify
      hidePodcasts
      shuffle
    ];
    theme = spicePkgs.themes.ziro;
    colorScheme = "rose-pine-moon";
  };
}
