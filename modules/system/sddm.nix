{
  pkgs,
  ...
}: let
  c = import ../theme/palette.nix;
  sddm-astronaut = pkgs.sddm-astronaut.override {
    themeConfig = {
      HeaderTextColor = "#${c.fg}";
      DateTextColor = "#${c.fgDim}";
      TimeTextColor = "#${c.fg}";
      LoginFieldTextColor = "#${c.fg}";
      PasswordFieldTextColor = "#${c.fg}";
      UserIconColor = "#${c.accent}";
      PasswordIconColor = "#${c.accent}";
      WarningColor = "#${c.red}";
      LoginButtonBackgroundColor = "#${c.bgDark}";
      SystemButtonsIconsColor = "#${c.accent}";
      SessionButtonTextColor = "#${c.accent}";
      VirtualKeyboardButtonTextColor = "#${c.accent}";
      DropdownBackgroundColor = "#${c.bgDark}";
      HighlightBackgroundColor = "#${c.bgSelection}";
      Background = "/home/marco/.config/wallpapers/gruvbox-leaves.jpg";
      BackgroundColor = "#${c.bg}";
      DimBackgroundColor = "#${c.bgDarker}";
      DimBackground = "0.3";
    };
  };
in {
  services.displayManager = {
    sddm = {
      enable = true;
      wayland.enable = true;
      package = pkgs.kdePackages.sddm;
      extraPackages = [
        sddm-astronaut
      ];
      theme = "sddm-astronaut-theme";
    };
  };

  environment.systemPackages = [sddm-astronaut];
}
