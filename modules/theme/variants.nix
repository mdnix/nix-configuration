# The two Gruvbox Material variants: a palette plus the non-colour choices that
# travel with a background. Hex carries no leading "#" so it composes into
# whichever notation a consumer needs.
#
# Keys name a *role*, not a lightness — `bgDark` is the recessed surface, so in
# the light variant it is not darker than `bg`. Never assume the direction.
{
  dark = {
    variant = "dark";

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

    # Deliberately not the accent: focus indication stays quiet so the accent
    # can carry the active workspace, launcher selection and lock input.
    borderActive = "a89984";
    borderInactive = "3c3836";

    gtkTheme = "Gruvbox-Dark";
    iconTheme = "Gruvbox-Plus-Dark";
    cursorTheme = "phinger-cursors-dark";
    colorScheme = "prefer-dark";
    btopTheme = "gruvbox_material_dark";
    wallpaper = "gruvbox-backwater.jpg";
  };

  light = {
    variant = "light";

    bg = "f9f5d7";
    bgDark = "f2e5bc";
    bgDarker = "e5d5ad";
    bgLight = "eee0b7";
    bgSelection = "ddccab";
    bgMuted = "a89984";

    fg = "654735";
    fgDim = "7c6f64";
    fgFaint = "928374";

    red = "c14a4a";
    orange = "c35e0a";
    yellow = "b47109";
    green = "6c782e";
    aqua = "4c7a5d";
    blue = "45707a";
    purple = "945e80";

    accent = "45707a";

    borderActive = "7c6f64";
    borderInactive = "ddccab";

    gtkTheme = "Gruvbox-Light";
    iconTheme = "Gruvbox-Plus-Light";
    cursorTheme = "phinger-cursors-light";
    colorScheme = "prefer-light";
    btopTheme = "gruvbox_light";
    # The brightest wallpaper available; they are all dark renders.
    wallpaper = "gruvbox-village-square.jpg";
  };
}
