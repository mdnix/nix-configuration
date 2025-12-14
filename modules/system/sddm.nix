{
  pkgs,
  inputs,
  ...
}: let
  sddm-astronaut = pkgs.sddm-astronaut.override {
    themeConfig = {
      HeaderTextColor = "#A594FD";
      DateTextColor = "#A594FD";
      TimeTextColor = "#A594FD";
      LoginFieldTextColor = "#A594FD";
      PasswordFieldTextColor = "#A594FD";
      UserIconColor = "#A594FD";
      PasswordIconColor = "#A594FD";
      WarningColor = "#ff6b6b";
      LoginButtonBackgroundColor = "#0B0B0B";
      SystemButtonsIconsColor = "#A594FD";
      SessionButtonTextColor = "#A594FD";
      VirtualKeyboardButtonTextColor = "#A594FD";
      DropdownBackgroundColor = "#0B0B0B";
      HighlightBackgroundColor = "#5940D4";
      Background = "/home/marco/.config/wallpapers/wallpaper.png";
      BackgroundColor = "#0B0B0B";
      DimBackgroundColor = "#000000";
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
