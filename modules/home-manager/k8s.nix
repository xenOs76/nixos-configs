{pkgs, ...}: {
  home.packages = with pkgs; [
    kubectl
    kubectl-node-shell
    kubectl-images
    kubectl-ktop
    krew
    kubectx
    istioctl
    k9s
    kubecolor
    lens
    velero
    kubecolor
    (wrapHelm kubernetes-helm {
      plugins = [
        kubernetes-helmPlugins.helm-diff
        kubernetes-helmPlugins.helm-s3
      ];
    })
  ];

  # Fetch k9s skin from https://github.com/catppuccin/k9s
  home.file = {
    ".config/k9s/skins/catppuccin-frappe-transparent.yaml".text = builtins.readFile (builtins.fetchurl {
      url = "https://raw.githubusercontent.com/catppuccin/k9s/refs/heads/main/dist/catppuccin-frappe-transparent.yaml";
      sha256 = "sha256:0jl7ny00s2db4h3zlimayyaivrnwy06rn348s5hhkkypkzjcm2kp";
    });
  };

  programs.k9s = {
    enable = true;
    settings = {k9s = {ui = {skin = "catppuccin-frappe-transparent";};};};
  };
}
