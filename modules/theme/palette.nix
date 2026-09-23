# Gruvbox Material (dark, hard) — the single source of truth for every themed
# surface in this configuration. Hex values carry no leading "#" so they compose
# into whichever notation a consumer needs: "#${red}", "rgb(${red})", "0x${red}".
{
  bg = "1d2021";
  bgDark = "131617";
  bgDarker = "0b0e0f";
  bgLight = "3c3836";
  bgSelection = "504945";
  bgMuted = "665c54";

  fg = "d4be98";
  fgDim = "bdae93";
  fgFaint = "7c6f64";

  red = "ea6962";
  orange = "e78a4e";
  yellow = "d8a657";
  green = "a9b665";
  aqua = "89b482";
  blue = "7daea3";
  purple = "d3869b";

  # Named separately so a future palette swap only has to re-point this one.
  accent = "7daea3";

  # Window borders are deliberately NOT the accent: focus indication wants to
  # stay quiet, while the accent still carries the bar's active workspace, the
  # launcher selection and the lock screen's input outline.
  borderActive = "a89984";
  borderInactive = "3c3836";
}
