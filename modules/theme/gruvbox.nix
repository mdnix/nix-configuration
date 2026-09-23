{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.profiles.theme;
  c = import ./palette.nix;
  inherit (lib) mkEnableOption mkIf;
  # Every themed surface reads its colours from ~/.config/theme, which is the
  # only part of the dotfiles that Nix generates. The dotfile trees themselves
  # stay out-of-store symlinks so they remain live-editable; they just `source`
  # or `@import` the generated file instead of hardcoding hex.
in
{
  options.profiles.theme.enable = mkEnableOption "Gruvbox Material theme across the system";

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      gruvbox-gtk-theme
      gruvbox-plus-icons
    ];

    home-manager.users.marco = {
      home.file = {
        # GTK CSS — imported by waybar, wofi, swaync and wlogout, all of which
        # are GTK apps and understand @define-color and alpha().
        ".config/theme/colors.css".text = ''
          @define-color bg          #${c.bg};
          @define-color bg_dark     #${c.bgDark};
          @define-color bg_darker   #${c.bgDarker};
          @define-color bg_light    #${c.bgLight};
          @define-color bg_sel      #${c.bgSelection};
          @define-color bg_muted    #${c.bgMuted};

          @define-color fg          #${c.fg};
          @define-color fg_dim      #${c.fgDim};
          @define-color fg_faint    #${c.fgFaint};

          @define-color red         #${c.red};
          @define-color orange      #${c.orange};
          @define-color yellow      #${c.yellow};
          @define-color green       #${c.green};
          @define-color aqua        #${c.aqua};
          @define-color blue        #${c.blue};
          @define-color purple      #${c.purple};
          @define-color accent      #${c.accent};
        '';

        # Hyprland variables — sourced by hyprland.conf and hyprlock.conf.
        ".config/theme/hypr-colors.conf".text = ''
          $bg          = rgb(${c.bg})
          $bgDark      = rgb(${c.bgDark})
          $bgDarker    = rgb(${c.bgDarker})
          $bgLight     = rgb(${c.bgLight})
          $bgSelection = rgb(${c.bgSelection})
          $bgMuted     = rgb(${c.bgMuted})

          $fg          = rgb(${c.fg})
          $fgDim       = rgb(${c.fgDim})
          $fgFaint     = rgb(${c.fgFaint})

          $red         = rgb(${c.red})
          $orange      = rgb(${c.orange})
          $yellow      = rgb(${c.yellow})
          $green       = rgb(${c.green})
          $aqua        = rgb(${c.aqua})
          $blue        = rgb(${c.blue})
          $purple      = rgb(${c.purple})
          $accent      = rgb(${c.accent})

          # Alpha-carrying variants; Hyprland border/shadow colours need rgba().
          $borderActive   = rgba(${c.borderActive}ff)
          $borderInactive = rgba(${c.borderInactive}ff)
          $shadowColor    = rgba(${c.bgDarker}ee)
        '';

        # tmux — sourced by .tmux.conf. Only the colours live here; the bar
        # layout stays in the dotfile so it can be tweaked without a rebuild.
        # tmux expands #{@user_option} inside style strings, so these carry
        # through to status-style, window-status-style and friends.
        ".config/theme/tmux-colors.conf".text = ''
          set -g @tm_bg        "#${c.bgDark}"
          set -g @tm_bg_alt    "#${c.bgLight}"
          set -g @tm_fg        "#${c.fg}"
          set -g @tm_fg_dim    "#${c.fgDim}"
          set -g @tm_fg_faint  "#${c.fgFaint}"
          set -g @tm_accent    "#${c.accent}"
          set -g @tm_warn      "#${c.yellow}"
          set -g @tm_urgent    "#${c.red}"
          set -g @tm_border    "#${c.borderInactive}"
          set -g @tm_border_on "#${c.borderActive}"
        '';

        # Ghostty — pulled in from ghostty/config via config-file.
        ".config/theme/ghostty-colors".text = ''
          background = #${c.bg}
          foreground = #${c.fg}
          cursor-color = #${c.fg}
          selection-background = #${c.bgSelection}
          selection-foreground = #${c.fg}

          palette = 0=#${c.bg}
          palette = 1=#${c.red}
          palette = 2=#${c.green}
          palette = 3=#${c.yellow}
          palette = 4=#${c.blue}
          palette = 5=#${c.purple}
          palette = 6=#${c.aqua}
          palette = 7=#${c.fg}
          palette = 8=#${c.bgMuted}
          palette = 9=#${c.red}
          palette = 10=#${c.green}
          palette = 11=#${c.yellow}
          palette = 12=#${c.blue}
          palette = 13=#${c.purple}
          palette = 14=#${c.aqua}
          palette = 15=#${c.fg}
        '';
      };

      home.pointerCursor = {
        enable = true;
        package = pkgs.phinger-cursors;
        name = "phinger-cursors-dark";
        size = 24;
        gtk.enable = true;
        x11.enable = true;
      };

      gtk = {
        enable = true;
        theme = {
          name = "Gruvbox-Dark";
          package = pkgs.gruvbox-gtk-theme;
        };
        iconTheme = {
          name = "Gruvbox-Plus-Dark";
          package = pkgs.gruvbox-plus-icons;
        };
        # The package ships gtk-4.0 assets, so GTK4 apps get the same theme
        # rather than home-manager's new "leave GTK4 alone" default.
        gtk4.theme = {
          name = "Gruvbox-Dark";
          package = pkgs.gruvbox-gtk-theme;
        };
      };

      # Qt follows GTK rather than carrying a second copy of the palette.
      qt = {
        enable = true;
        platformTheme.name = "gtk3";
      };

      dconf.settings."org/gnome/desktop/interface" = {
        color-scheme = "prefer-dark";
        gtk-theme = "Gruvbox-Dark";
        icon-theme = "Gruvbox-Plus-Dark";
      };
    };

    # Console (TTY) colours, so even a dropped-to-tty session matches.
    console.colors = [
      c.bg
      c.red
      c.green
      c.yellow
      c.blue
      c.purple
      c.aqua
      c.fg
      c.bgMuted
      c.red
      c.green
      c.yellow
      c.blue
      c.purple
      c.aqua
      c.fg
    ];
  };
}
