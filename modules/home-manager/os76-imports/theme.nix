{
  pkgs,
  config,
  ...
}: let
  desktopFonts = config.os76Cfg.desktopFonts;
  ui = desktopFonts.ui;
  mono = desktopFonts.mono;

  fontPackages = {
    "Inter Nerd Font" = pkgs.inter-nerdfont;
    "JetBrains Mono" = pkgs.jetbrains-mono;
  };

  qtctAppearance = {
    style = "breeze";
    icon_theme = "Papirus-Dark";
    standard_dialogs = "xdgdesktopportal";
  };

  qtctFonts = {
    general = ''"${ui.name},${toString ui.size}"'';
    fixed = ''"${mono.name},${toString mono.size}"'';
  };

  cosmicFontRon = family: ''
    (
      family: "${family}",
      weight: Normal,
      stretch: Normal,
      style: Normal,
    )
  '';
in {
  xresources.properties = {
    "Xcursor.size" = desktopFonts.cursorSize;
    "Xft.dpi" = desktopFonts.dpi;
  };

  gtk = {
    enable = true;
    theme.name = "Breeze-Dark";
    iconTheme.name = "Papirus-Dark";
    font = {
      name = ui.name;
      size = ui.size;
      package = fontPackages.${ui.name} or pkgs.inter-nerdfont;
    };
  };

  qt = {
    enable = true;
    platformTheme.name = "qtct";
    style.name = "breeze";
    qt5ctSettings = {
      Appearance = qtctAppearance;
      Fonts = qtctFonts;
    };
    qt6ctSettings = {
      Appearance = qtctAppearance;
      Fonts = qtctFonts;
    };
  };

  fonts.fontconfig = {
    enable = true;
    defaultFonts = {
      serif = [ui.name "Noto Serif"];
      sansSerif = [ui.name "Noto Sans"];
      monospace = [mono.name "Noto Sans Mono"];
    };
  };

  xdg.configFile = {
    "cosmic/com.system76.CosmicTk/v1/interface_font".text = cosmicFontRon ui.name;
    "cosmic/com.system76.CosmicTk/v1/monospace_font".text = cosmicFontRon mono.name;
  };
}
