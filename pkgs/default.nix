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
        hyprctl hyprpaper preload "$choice"
        hyprctl hyprpaper wallpaper ",$choice"
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
        case "$(printf '%s\n' "Wallpaper" "Night light" | pick "Style")" in
          "Wallpaper")   wallpaper_pick ;;
          "Night light") nightlight_toggle ;;
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
}
