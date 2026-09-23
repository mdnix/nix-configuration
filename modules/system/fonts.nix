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
      nerd-fonts.departure-mono
      nerd-fonts.blex-mono
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
        # DepartureMono is single-weight, so BlexMono sits behind it to serve
        # bold/italic and anything the pixel font does not cover.
        monospace = [ "DepartureMono Nerd Font" "BlexMono Nerd Font" "Noto Sans Mono" ];
        emoji = [ "Noto Color Emoji" "OpenMoji Color" ];
      };
    };
  };
}