{pkgs, ...}: {
  fonts.packages = with pkgs; [
    noto-fonts
    fira-code
    jetbrains-mono
    nerd-fonts.fira-code
    nerd-fonts.terminess-ttf
    nerd-fonts.jetbrains-mono
    inter-nerdfont
  ];
}
