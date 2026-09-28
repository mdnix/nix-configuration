{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.profiles.theme;
  variants = import ./variants.nix;
  # The boot default, and what every build-time-only consumer (SDDM, console,
  # spicetify) is pinned to.
  default = variants.dark;

  inherit (lib) mkEnableOption mkIf;
in
{
  options.profiles.theme.enable = mkEnableOption "Gruvbox Material theme across the system";

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      gruvbox-gtk-theme
      gruvbox-plus-icons
      phinger-cursors
      theme-toggle
    ];

    # `config` and `lib` below shadow the NixOS ones deliberately: `lib.hm` and
    # `config.home.homeDirectory` only exist on home-manager's.
    home-manager.users.marco =
      { config, lib, ... }:
      let
        inherit (lib)
          concatLines
          concatMapAttrs
          mapAttrs'
          mapAttrsToList
          nameValuePair
          ;

        inherit (config.home) homeDirectory;

        # Themed surfaces read ~/.config/theme/current, a symlink at one of the
        # variant dirs generated here, so switching is a symlink flip plus
        # reload IPC (theme-toggle) rather than a rebuild. The dotfiles stay
        # out-of-store symlinks and just `source`/`@import` these.
        variantFiles =
          palette:
          let
            wallpaper = "${homeDirectory}/.config/wallpapers/${palette.wallpaper}";
          in
          {
            # GTK CSS — imported by waybar, wofi, swaync and wlogout.
            "colors.css".text = ''
              @define-color bg          #${palette.bg};
              @define-color bg_dark     #${palette.bgDark};
              @define-color bg_darker   #${palette.bgDarker};
              @define-color bg_light    #${palette.bgLight};
              @define-color bg_sel      #${palette.bgSelection};
              @define-color bg_muted    #${palette.bgMuted};

              @define-color fg          #${palette.fg};
              @define-color fg_dim      #${palette.fgDim};
              @define-color fg_faint    #${palette.fgFaint};

              @define-color red         #${palette.red};
              @define-color orange      #${palette.orange};
              @define-color yellow      #${palette.yellow};
              @define-color green       #${palette.green};
              @define-color aqua        #${palette.aqua};
              @define-color blue        #${palette.blue};
              @define-color purple      #${palette.purple};
              @define-color accent      #${palette.accent};
            '';

            # Hyprland variables — sourced by hyprland.conf and hyprlock.conf.
            "hypr-colors.conf".text = ''
              $bg          = rgb(${palette.bg})
              $bgDark      = rgb(${palette.bgDark})
              $bgDarker    = rgb(${palette.bgDarker})
              $bgLight     = rgb(${palette.bgLight})
              $bgSelection = rgb(${palette.bgSelection})
              $bgMuted     = rgb(${palette.bgMuted})

              $fg          = rgb(${palette.fg})
              $fgDim       = rgb(${palette.fgDim})
              $fgFaint     = rgb(${palette.fgFaint})

              $red         = rgb(${palette.red})
              $orange      = rgb(${palette.orange})
              $yellow      = rgb(${palette.yellow})
              $green       = rgb(${palette.green})
              $aqua        = rgb(${palette.aqua})
              $blue        = rgb(${palette.blue})
              $purple      = rgb(${palette.purple})
              $accent      = rgb(${palette.accent})

              # Hyprland border/shadow colours need rgba().
              $borderActive   = rgba(${palette.borderActive}ff)
              $borderInactive = rgba(${palette.borderInactive}ff)
              $shadowColor    = rgba(${palette.bgDarker}ee)

              # Not colours, but they travel with the variant.
              $wallpaper    = ${wallpaper}
              $cursor_theme = ${palette.cursorTheme}
            '';

            # tmux — sourced by .tmux.conf, which keeps the bar layout so it
            # stays tweakable without a rebuild. tmux expands #{@user_option}
            # inside style strings, so these reach status-style and friends.
            "tmux-colors.conf".text = ''
              set -g @tm_bg        "#${palette.bgDark}"
              set -g @tm_bg_alt    "#${palette.bgLight}"
              set -g @tm_fg        "#${palette.fg}"
              set -g @tm_fg_dim    "#${palette.fgDim}"
              set -g @tm_fg_faint  "#${palette.fgFaint}"
              set -g @tm_accent    "#${palette.accent}"
              set -g @tm_warn      "#${palette.yellow}"
              set -g @tm_urgent    "#${palette.red}"
              set -g @tm_border    "#${palette.borderInactive}"
              set -g @tm_border_on "#${palette.borderActive}"
            '';

            # Ghostty — pulled in from ghostty/config via config-file.
            "ghostty-colors".text = ''
              background = #${palette.bg}
              foreground = #${palette.fg}
              cursor-color = #${palette.fg}
              selection-background = #${palette.bgSelection}
              selection-foreground = #${palette.fg}

              palette = 0=#${palette.bg}
              palette = 1=#${palette.red}
              palette = 2=#${palette.green}
              palette = 3=#${palette.yellow}
              palette = 4=#${palette.blue}
              palette = 5=#${palette.purple}
              palette = 6=#${palette.aqua}
              palette = 7=#${palette.fg}
              palette = 8=#${palette.bgMuted}
              palette = 9=#${palette.red}
              palette = 10=#${palette.green}
              palette = 11=#${palette.yellow}
              palette = 12=#${palette.blue}
              palette = 13=#${palette.purple}
              palette = 14=#${palette.aqua}
              palette = 15=#${palette.fg}
            '';

            # Everything the switcher needs that is not a colour. It sources
            # this, so a new per-variant knob never means editing the script.
            "env".text = ''
              THEME_VARIANT=${palette.variant}
              GTK_THEME_NAME=${palette.gtkTheme}
              ICON_THEME_NAME=${palette.iconTheme}
              CURSOR_THEME_NAME=${palette.cursorTheme}
              COLOR_SCHEME=${palette.colorScheme}
              WALLPAPER=${wallpaper}
            '';
          };

        # -> home.file entries under ~/.config/theme/<variant>/.
        themeFiles = concatMapAttrs (
          variant: palette:
          mapAttrs' (
            name: file: nameValuePair ".config/theme/${variant}/${name}" file
          ) (variantFiles palette)
        ) variants;

        # btop rewrites its config on exit, churning the dotfile in git. A
        # stable path here makes that rewrite a no-op, and makes the theme
        # switchable: current.theme flips alongside the colour dir.
        btopThemes = concatMapAttrs (variant: palette: {
          ".config/btop/themes/${variant}.theme".source =
            "${pkgs.btop}/share/btop/themes/${palette.btopTheme}.theme";
        }) variants;

        # The live choice. Unmanaged by home-manager because theme-toggle
        # rewrites them, so activation seeds one only when it is missing.
        currentLinks = {
          ".config/theme/current" = ".config/theme/${default.variant}";
          ".config/btop/themes/current.theme" = ".config/btop/themes/${default.variant}.theme";
        };
      in
      {
        home.file = themeFiles // btopThemes;

        # After linkGeneration, not writeBoundary: the targets are themselves
        # home.file links, and seeding before they exist fails under `set -eu`.
        # `-e` follows the link, so a dangling `current` is re-seeded too.
        home.activation.themeCurrent = lib.hm.dag.entryAfter [ "linkGeneration" ] (
          concatLines (
            mapAttrsToList (target: fallback: ''
              if [ ! -e "$HOME/${target}" ]; then
                run ${pkgs.coreutils}/bin/ln -sfn "$HOME/${fallback}" "$HOME/${target}"
              fi
            '') currentLinks
          )
        );

        # Size and plumbing stay declarative; only the name moves at runtime,
        # via theme-toggle's gsettings and `hyprctl setcursor`.
        home.pointerCursor = {
          enable = true;
          package = pkgs.phinger-cursors;
          name = default.cursorTheme;
          size = 24;
          gtk.enable = true;
          x11.enable = true;
        };

        gtk = {
          enable = true;
          theme = {
            name = default.gtkTheme;
            package = pkgs.gruvbox-gtk-theme;
          };
          iconTheme = {
            name = default.iconTheme;
            package = pkgs.gruvbox-plus-icons;
          };
          # The package ships gtk-4.0 assets, so opt out of home-manager's
          # "leave GTK4 alone" default.
          gtk4.theme = {
            name = default.gtkTheme;
            package = pkgs.gruvbox-gtk-theme;
          };
        };

        # Qt follows GTK rather than carrying a second copy of the palette.
        qt = {
          enable = true;
          platformTheme.name = "gtk3";
        };

        # Seed values only; theme-toggle rewrites these keys at runtime.
        dconf.settings."org/gnome/desktop/interface" = {
          color-scheme = default.colorScheme;
          gtk-theme = default.gtkTheme;
          icon-theme = default.iconTheme;
        };
      };

    # TTY colours. Set once at boot with no reload path, so it stays on the
    # default. Slots 0-7 are normal and 8-15 bright; only the bg slot differs.
    console.colors =
      let
        ansi =
          bg: [ bg ] ++ (with default; [ red green yellow blue purple aqua fg ]);
      in
      ansi default.bg ++ ansi default.bgMuted;
  };
}
