{
  pkgs,
  inputs,
  ...
}: let
  sddm-astronaut = pkgs.sddm-astronaut.override {
    themeConfig = {
      HeaderTextColor = "#ffffff";
      DateTextColor = "#ffffff";
      TimeTextColor = "#ffffff";
      LoginFieldTextColor = "#ffffff";
      PasswordFieldTextColor = "#ffffff";
      UserIconColor = "#ffffff";
      PasswordIconColor = "#ffffff";
      WarningColor = "#ff6b6b";
      LoginButtonBackgroundColor = "#1a1a1a";
      SystemButtonsIconsColor = "#ffffff";
      SessionButtonTextColor = "#ffffff";
      VirtualKeyboardButtonTextColor = "#ffffff";
      DropdownBackgroundColor = "#1a1a1a";
      HighlightBackgroundColor = "#333333";
      Background = "/home/marco/.config/wallpapers/wallpaper1.jpg";
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
      settings = {
        Wayland.SessionDir = "${
          inputs.hyprland.packages."${pkgs.system}".hyprland
        }/share/wayland-sessions";
      };
    };
  };

  environment.systemPackages = [sddm-astronaut];
}
