{pkgs, ...}: {
  gtk = {
    enable = true;
    theme.name = "Breeze-Dark";
    iconTheme.name = "Papirus-Dark";
    font = {
      size = 10;
      name = "JetBrains Mono";
      package = pkgs.jetbrains-mono;
    };
  };
}
