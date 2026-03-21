{
  pkgs,
  config,
  lib,
  ...
}: let
  shell-generic-os76cfg-values = pkgs.writeShellScriptBin "shell-generic-os76cfg-values" ''
    echo "config.os76Cfg values in shell-generics/scripts.nix import:"
    echo "checkValue = ${config.os76Cfg.checkValue}"
    echo "gitUserName = ${config.os76Cfg.gitUserName}"
    echo "defKubeNamespace = ${config.os76Cfg.defKubeNamespace}"
    echo "defAwsRegionList = ${lib.strings.concatStringsSep " " config.os76Cfg.defAwsRegionList}"
    echo "firefoxAdditionalCertificates = ${lib.strings.concatStringsSep " " config.os76Cfg.firefoxAdditionalCertificates}"
  '';

  get-istio-resources = pkgs.writeShellScriptBin "get-istio-resources.sh" ''
    KUBECOLOR="${lib.getExe pkgs.kubecolor}"
    GUM="${lib.getExe pkgs.gum}"
    ISTIO_RESOURCES="gateways virtualservices authorizationpolicies peerauthentications requestauthentications destinationrules"

    $GUM style --padding "0 5" --border=rounded --border-foreground 240 --faint --bold --align=center "Istio resources"

    for RES in $ISTIO_RESOURCES; do
      $GUM format -- "## $RES"
      $KUBECOLOR get "$RES" "$@"
      echo
    done
  '';

  get-prometheus-kube-resources = pkgs.writeShellScriptBin "get-prometheus-kube-resources.sh" ''
    KUBECOLOR="${lib.getExe pkgs.kubecolor}"
    GUM="${lib.getExe pkgs.gum}"
    PROM_RESOURCES="podmonitors probes prometheusagents prometheuses prometheusrules scrapeconfigs servicemonitors"

    # Excluded:
    # alertmanagerconfigs
    # alertmanagers
    # thanosrulers

    $GUM style --padding "0 5" --border=rounded --border-foreground 240 --faint --bold --align=center "Prometheus resources"

    for R in $PROM_RESOURCES; do
      $GUM format -- "# $R"
      $KUBECOLOR get "$R" "$@"
      echo
    done
  '';
in {
  home.packages = [
    shell-generic-os76cfg-values
    get-istio-resources
    get-prometheus-kube-resources
  ];
}
