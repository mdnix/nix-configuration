{pkgs, ...}: {
  fonts = {
    packages = with pkgs.unstable; [
      # Essential fonts
      roboto
      work-sans
      source-sans
      inter
      dejavu_fonts
      noto-fonts
      noto-fonts-cjk-sans
      noto-fonts-color-emoji

      # Nerd fonts
      nerd-fonts.fira-code
      nerd-fonts.meslo-lg

      # Emoji fonts
      openmoji-color
      twemoji-color-font
    ];

    enableDefaultPackages = false;

    fontconfig = {
      defaultFonts = {
        serif = [ "Noto Serif" ];
        sansSerif = [ "Inter" "Noto Sans" ];
        monospace = [ "FiraCode Nerd Font" "Noto Sans Mono" ];
        emoji = [ "Noto Color Emoji" "OpenMoji Color" ];
      };
    };
  };
}