# Custom packages
pkgs: {
  # Keybinding cheatsheet. Reads the live binds out of Hyprland rather than a
  # second copy in a file, so every `bindd` in hyprland.conf documents itself.
  hypr-keybinds = pkgs.writeShellApplication {
    name = "hypr-keybinds";
    runtimeInputs = with pkgs; [ hyprland jq wofi ];
    text = ''
      hyprctl binds -j | jq -r '
        # Hyprland packs held modifiers into a bitmask: SHIFT 1, CTRL 4,
        # ALT 8, SUPER 64. Listed SUPER-first because that is how the
        # bindings read in hyprland.conf.
        def mods(m):
          [ if (m / 64 | floor) % 2 == 1 then "SUPER" else empty end,
            if (m / 4  | floor) % 2 == 1 then "CTRL"  else empty end,
            if (m / 8  | floor) % 2 == 1 then "ALT"   else empty end,
            if (m / 1  | floor) % 2 == 1 then "SHIFT" else empty end ]
          | join(" + ");

        def pad(s; n): s + ((" " * (n - (s | length))) // "");

        map(select((.description // "") != ""))
        | sort_by(.description)
        | map(pad(
            (if .modmask == 0 then .key else mods(.modmask) + " + " + .key end);
            27) + " " + .description)
        | .[]
      ' | wofi --dmenu --insensitive --prompt "Keybindings" --width 900 --height 600 \
        >/dev/null || true
    '';
  };

  # Tree menu in the spirit of omarchy-menu: one key opens everything, and any
  # section can be jumped to directly (`hypr-menu capture`) so a keybind can
  # land on a leaf of the tree without walking the root.
  hypr-menu = pkgs.writeShellApplication {
    name = "hypr-menu";
    runtimeInputs = with pkgs; [
      hyprland
      jq
      wofi
      wlogout
      hyprshot
      hyprpicker
      hyprsunset
      hypridle
      waybar
      cliphist
      wl-clipboard
      bemoji
      procps
      pkgs.hypr-keybinds
      pkgs.theme-toggle
    ];
    text = ''
      pick() {
        wofi --dmenu --insensitive --prompt "$1" --width 420 --height 380
      }

      # Toggles read their state back out of Hyprland instead of tracking it in
      # a state file, so an external `hyprctl keyword` cannot desync the menu.
      # gaps_out reports under .custom as a gap tuple ("5 10 5 10"); .int is the
      # fallback in case a Hyprland release reports it as a plain integer.
      gaps_toggle() {
        if [ "$(hyprctl getoption general:gaps_out -j \
                | jq -r '(.custom // .int // "") | tostring | split(" ")[0]')" = "0" ]; then
          hyprctl keyword general:gaps_out 8
          hyprctl keyword general:gaps_in 4
        else
          hyprctl keyword general:gaps_out 0
          hyprctl keyword general:gaps_in 0
        fi
      }

      # Compared numerically inside jq: whether `1.000000` survives as a string
      # or is normalised to `1` varies by jq version.
      transparency_toggle() {
        if [ "$(hyprctl getoption decoration:inactive_opacity -j \
                | jq -r 'if .float >= 1 then "opaque" else "transparent" end')" = "opaque" ]; then
          hyprctl keyword decoration:inactive_opacity 0.9
        else
          hyprctl keyword decoration:inactive_opacity 1.0
        fi
      }

      # pkill returns non-zero when nothing matched, which is the "not running"
      # branch rather than an error, hence the `||`.
      nightlight_toggle() { pkill hyprsunset || hyprsunset -t 4500 & }
      idle_toggle()       { pkill hypridle   || hypridle & }
      bar_toggle()        { pkill waybar     || waybar & }

      wallpaper_pick() {
        local dir="$HOME/.config/wallpapers" choice
        choice=$(find -L "$dir" -maxdepth 1 -type f \
                   \( -iname '*.png' -o -iname '*.jpg' -o -iname '*.jpeg' -o -iname '*.webp' \) \
                 | sort | pick "Wallpaper")
        [ -n "$choice" ] || return 0
        # Via theme-toggle so the pick is recorded against the current variant
        # and restored at next login instead of reverting to its default.
        theme-toggle wallpaper "$choice"
      }

      menu_capture() {
        case "$(printf '%s\n' \
            "Region" "Window" "Screen" "Region to clipboard" "Colour picker" \
          | pick "Capture")" in
          "Region to clipboard") hyprshot -m region --clipboard-only ;;
          "Region")              hyprshot -m region ;;
          "Window")              hyprshot -m window ;;
          "Screen")              hyprshot -m output ;;
          "Colour picker")       pkill hyprpicker || hyprpicker -a ;;
        esac
      }

      menu_toggles() {
        case "$(printf '%s\n' \
            "Gaps" "Transparency" "Night light" "Idle lock" "Top bar" \
          | pick "Toggle")" in
          "Gaps")         gaps_toggle ;;
          "Transparency") transparency_toggle ;;
          "Night light")  nightlight_toggle ;;
          "Idle lock")    idle_toggle ;;
          "Top bar")      bar_toggle ;;
        esac
      }

      menu_style() {
        case "$(printf '%s\n' "Light / Dark" "Wallpaper" "Night light" | pick "Style")" in
          "Light / Dark") theme-toggle ;;
          "Wallpaper")    wallpaper_pick ;;
          "Night light")  nightlight_toggle ;;
        esac
      }

      menu_clipboard() {
        local choice
        choice=$(cliphist list | pick "Clipboard")
        [ -n "$choice" ] || return 0
        printf '%s' "$choice" | cliphist decode | wl-copy
      }

      menu_root() {
        case "$(printf '%s\n' \
            "Apps" "Clipboard" "Emoji" "Capture" "Style" \
            "Toggles" "Keybindings" "System" \
          | pick "Menu")" in
          "Apps")        wofi --show drun ;;
          "Clipboard")   menu_clipboard ;;
          "Emoji")       bemoji -t ;;
          "Capture")     menu_capture ;;
          "Style")       menu_style ;;
          "Toggles")     menu_toggles ;;
          "Keybindings") hypr-keybinds ;;
          "System")      wlogout -b 5 ;;
        esac
      }

      case "''${1:-root}" in
        root)      menu_root ;;
        capture)   menu_capture ;;
        toggles)   menu_toggles ;;
        style)     menu_style ;;
        clipboard) menu_clipboard ;;
        system)    wlogout -b 5 ;;
        *) echo "hypr-menu: unknown route '$1'" >&2; exit 2 ;;
      esac
    '';
  };

  # Light/dark switcher: flips ~/.config/theme/current between the two palettes
  # gruvbox.nix generated, then walks every running surface's reload path.
  #
  # Surfaces with no reload path are left alone on purpose — SDDM and the TTY
  # are set before the session exists, spicetify patches Spotify at build time,
  # and btop picks its theme up on next launch.
  theme-toggle = pkgs.writeShellApplication {
    name = "theme-toggle";
    runtimeInputs = with pkgs; [
      coreutils
      hyprland
      jq
      glib
      procps
      libnotify
      swaynotificationcenter
    ];
    text = ''
      theme_dir="$HOME/.config/theme"
      current="$theme_dir/current"
      btop_themes="$HOME/.config/btop/themes"

      variant_now() {
        if [ -L "$current" ]; then
          basename "$(readlink "$current")"
        else
          echo dark
        fi
      }

      link_variant() {
        local v="$1"
        [ -d "$theme_dir/$v" ] || { echo "theme-toggle: no such variant: $v" >&2; exit 1; }
        # -n so `current` is replaced, not followed into the dir it points at.
        ln -sfn "$theme_dir/$v" "$current"
        if [ -e "$btop_themes/$v.theme" ]; then
          ln -sfn "$btop_themes/$v.theme" "$btop_themes/current.theme"
        fi
      }

      # Last pick for this variant, else its default. One file per variant, so a
      # pick survives a round trip through the other theme; an entry naming a
      # deleted image falls back rather than blanking the desktop.
      wallpaper_for() {
        local v="$1" fallback="$2" state chosen
        state="$theme_dir/wallpaper.$v"
        chosen=""
        if [ -r "$state" ]; then
          chosen="$(cat "$state")"
        fi
        if [ -n "$chosen" ] && [ -e "$chosen" ]; then
          echo "$chosen"
        else
          echo "$fallback"
        fi
      }

      wallpaper_set() {
        local path="$1"
        # hyprpaper 0.8 dropped preload/unload/listloaded, so this call loads
        # the image itself. Empty monitor field means "every output". Retried
        # because hyprpaper may still be coming up when exec-once runs this.
        for _ in 1 2 3 4 5; do
          if hyprctl hyprpaper wallpaper ",$path" >/dev/null 2>&1; then
            return 0
          fi
          sleep 0.4
        done
      }

      # tmux and nvim come off $PATH, not runtimeInputs: both talk to an
      # already-running process, and a second store copy is the wrong binary.
      tmux_reload() {
        command -v tmux >/dev/null 2>&1 || return 0
        tmux has-session >/dev/null 2>&1 || return 0
        # The whole file, not just the colours: status strings interpolate
        # #{@tm_*} at draw time, but pane-border-style resolves at set time.
        tmux source-file "$HOME/.tmux.conf" >/dev/null 2>&1 || true
        tmux refresh-client -S >/dev/null 2>&1 || true
      }

      nvim_reload() {
        local v="$1" sock
        command -v nvim >/dev/null 2>&1 || return 0
        for sock in "''${XDG_RUNTIME_DIR:-/run/user/$(id -u)}"/nvim.*; do
          [ -S "$sock" ] || continue
          # --remote-expr, not --remote-send: an expression cannot land in the
          # wrong mode mid-edit. The colorscheme is re-applied by hand because
          # gruvbox-material reads &background on load, not on change.
          timeout 2 nvim --server "$sock" --remote-expr \
            "execute('set background=$v | colorscheme gruvbox-material')" \
            >/dev/null 2>&1 || true
        done
      }

      ghostty_reload() {
        local addr
        # Ghostty has no reload IPC, but binds one by default (ctrl+shift+,)
        # and Hyprland can deliver it to a named window. Addresses are
        # collected up front so the loop is not reading hyprctl while
        # dispatching into it.
        while read -r addr; do
          [ -n "$addr" ] || continue
          hyprctl dispatch sendshortcut "CTRL SHIFT, comma, address:$addr" \
            >/dev/null 2>&1 || true
        done < <(hyprctl clients -j \
                 | jq -r '.[] | select(.class == "com.mitchellh.ghostty") | .address')
      }

      # Announces only when given an argument: a flip is worth a notification,
      # the login restore is not -- nothing switched.
      apply() {
        # shellcheck disable=SC1091,SC2154
        local announce="''${1:-}" v
        v="$(variant_now)"
        # shellcheck source=/dev/null
        . "$theme_dir/$v/env"

        # Both hyprland.conf and hyprlock.conf source current/, so one reload
        # covers borders now and the lock screen next time it is invoked.
        hyprctl reload >/dev/null 2>&1 || true
        hyprctl setcursor "$CURSOR_THEME_NAME" 24 >/dev/null 2>&1 || true

        # dconf is what live GTK apps and the portal read; home-manager's
        # settings.ini is only the startup default.
        gsettings set org.gnome.desktop.interface color-scheme "$COLOR_SCHEME" || true
        gsettings set org.gnome.desktop.interface gtk-theme "$GTK_THEME_NAME" || true
        gsettings set org.gnome.desktop.interface icon-theme "$ICON_THEME_NAME" || true
        gsettings set org.gnome.desktop.interface cursor-theme "$CURSOR_THEME_NAME" || true

        wallpaper_set "$(wallpaper_for "$v" "$WALLPAPER")"

        # Waybar rereads config and CSS on SIGUSR2. wofi and wlogout need
        # nothing: they are spawned per invocation.
        pkill -USR2 waybar || true
        swaync-client --reload-css >/dev/null 2>&1 || true

        tmux_reload
        nvim_reload "$v"
        ghostty_reload

        if [ -n "$announce" ]; then
          notify-send -a theme -i preferences-desktop-theme \
            "Theme" "Switched to $v" >/dev/null 2>&1 || true
        fi
      }

      case "''${1:-toggle}" in
        toggle)
          if [ "$(variant_now)" = "dark" ]; then link_variant light; else link_variant dark; fi
          apply announce
          ;;
        dark | light) link_variant "$1"; apply announce ;;
        # The login restore: hyprpaper.conf and settings.ini both start from
        # the build-time default, which may not be what was last picked.
        apply)  apply ;;
        # Records the pick against the current variant and hangs it now. Why
        # hypr-menu delegates here: only this script knows where that state
        # lives.
        wallpaper)
          [ "$#" -eq 2 ] || { echo "usage: theme-toggle wallpaper <path>" >&2; exit 2; }
          [ -e "$2" ] || { echo "theme-toggle: no such wallpaper: $2" >&2; exit 1; }
          printf '%s\n' "$2" > "$theme_dir/wallpaper.$(variant_now)"
          wallpaper_set "$2"
          ;;
        status) variant_now ;;
        *)
          echo "usage: theme-toggle [toggle|dark|light|apply|status|wallpaper <path>]" >&2
          exit 2
          ;;
      esac
    '';
  };
}
