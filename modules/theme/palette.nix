# The dark variant, for the consumers that genuinely cannot switch at runtime:
# SDDM (renders before the session exists), the TTY console, and spicetify
# (which patches the Spotify client at build time). Everything that *can*
# switch reads ~/.config/theme/current instead — see variants.nix.
(import ./variants.nix).dark
