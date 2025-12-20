{pkgs, ...}: {

  environment.systemPackages = [
	pkgs.nerd-fonts.jetbrains-mono
  ];

  fonts.packages = with pkgs; [
    noto-fonts
    fira-code
    nerd-fonts.fira-code
    nerd-fonts.terminess-ttf
    inter-nerdfont
  ];
}
