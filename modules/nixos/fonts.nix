{pkgs, ...}: {
  fonts.packages = with pkgs; [
    noto-fonts
    fira-code
    nerd-fonts.fira-code
    nerd-fonts.terminess-ttf
    inter-nerdfont
  ];
}
