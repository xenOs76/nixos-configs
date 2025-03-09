{pkgs, ...}: {
  fonts.packages = with pkgs; [
    noto-fonts
    fira-code
    fira-code-nerdfont
    terminus_font
    terminus-nerdfont
    inter-nerdfont
  ];
}
