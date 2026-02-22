{
  pkgs,
  config,
  lib,
  ...
}: let
  shell-generic-os76cfg-values = pkgs.writeShellScriptBin "shell-generic-os76cfg-values" ''
    echo "config.os76Cfg values in os76-imports/scripts.nix import:"
    echo "checkValue = ${config.os76Cfg.checkValue}"
    echo "gitUserName = ${config.os76Cfg.gitUserName}"
    echo "defKubeNamespace = ${config.os76Cfg.defKubeNamespace}"
    echo "defAwsRegionList = ${lib.strings.concatStringsSep " " config.os76Cfg.defAwsRegionList}"
    echo "firefoxAdditionalCertificates = ${lib.strings.concatStringsSep " " config.os76Cfg.firefoxAdditionalCertificates}"
  '';

  k3s_config_ro_path = "/home/xeno/.kube/config-ro";

  k3s-sync-config-from-secret = pkgs.writeShellScriptBin "k3s-sync-config-from-secret" ''
    cat ${k3s_config_ro_path} > ~/.kube/config && chmod 600 ~/.kube/config
  '';

  plasmashell-replace = pkgs.writeShellScriptBin "plasmashell-replace" ''
    plasmashell --replace &
  '';

  docker-login-xeno-registry-0-pw_path = "/home/xeno/.config/docker_registry_0_pw";

  docker-login-xeno-registry-0-os76-priv = pkgs.writeShellScriptBin "docker-login-xeno-registry-0-os76-priv" ''
    cat ${docker-login-xeno-registry-0-pw_path} | docker login -u xeno --password-stdin registry.0.os76.xyz
  '';

  docker-login-xenos76-github = pkgs.writeShellScriptBin "docker-login-xenos76-github" ''
    cat /home/xeno/.config/goreleaser/github_token | docker login ghcr.io -u xenos76 --password-stdin
  '';
in {
  sops.secrets = {
    k3s_config = {
      path = k3s_config_ro_path;
    };
    docker_registry_0_pw = {
      path = docker-login-xeno-registry-0-pw_path;
    };
  };

  home.packages = [
    shell-generic-os76cfg-values
    k3s-sync-config-from-secret
    plasmashell-replace
    docker-login-xeno-registry-0-os76-priv
    docker-login-xenos76-github
  ];

  programs.bash.shellAliases = {
    reg-ls-zero = "reg ls registry.0.os76.xyz";
    reg-tags-zero = "reg tags --auth-url registry.0.os76.xyz";
  };
}
