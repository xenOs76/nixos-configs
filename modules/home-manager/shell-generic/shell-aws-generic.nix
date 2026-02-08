{
  pkgs,
  lib,
  config,
  ...
}: let
  shell-aws-generic-ckecks = pkgs.writeShellScriptBin "shell-aws-generic-ckecks" ''
    echo "config.os76Cfg values in shell-aws-generic-ckecks.nix import file:"
    echo "defKubeNamespace = ${config.os76Cfg.defKubeNamespace}"
    echo "defAwsRegionList = ${lib.strings.concatStringsSep " " config.os76Cfg.defAwsRegionList}"
  '';

  aws-ec2-list-instances = pkgs.writeShellScriptBin "aws-ec2-list-instances" ''
    AWS="${lib.getExe pkgs.awscli2}";
    DEFAULT_AWS_REGION_LIST="${lib.strings.concatStringsSep " " config.os76Cfg.defAwsRegionList}"
    FZF="${lib.getExe pkgs.fzf}";
    FZF_OPTIONS="--preview-window=hidden --height=80%";
    GUM="${lib.getExe pkgs.gum}"

    AWS_QUERY="Reservations[*].Instances[*].{Name:Tags[?Key=='Name']|[0].Value,InstanceID:InstanceId,Status:State.Name,PublicIp:PublicIpAddress,PrivateIp:PrivateIpAddress,SSHKey:KeyName}"
    AWS_FILTERS="Name=tag:Name,Values='*'"
    FZF_OPTIONS="$FZF_OPTIONS --query=running"

    $GUM format -- "Choose AWS region:"
    REGION=$($GUM choose $DEFAULT_AWS_REGION_LIST)

    $AWS ec2 describe-instances --region $REGION --query $AWS_QUERY --filters $AWS_FILTERS --output table | $FZF $FZF_OPTIONS
  '';

  aws-eks-switch-cluster = pkgs.writeShellScriptBin "aws-eks-switch-cluster" ''
    AWS="${lib.getExe pkgs.awscli2}";
    DEFAULT_AWS_REGION_LIST="${lib.strings.concatStringsSep " " config.os76Cfg.defAwsRegionList}"
    DEFAULT_K8S_NS="${config.os76Cfg.defKubeNamespace}"
    FZF="${lib.getExe pkgs.fzf}";
    FZF_OPTIONS="--preview-window=hidden --height=80%";
    GUM="${lib.getExe pkgs.gum}"
    JQ="${lib.getExe pkgs.jq}";
    KUBENS="${pkgs.kubectx}/bin/kubens";

    $GUM format -- "Choose AWS region:"
    REGION=$($GUM choose $DEFAULT_AWS_REGION_LIST)
    CLUSTERS=$($AWS eks list-clusters --region $REGION | $JQ -r '.clusters[]')

    if [ -z "$CLUSTERS" ]; then echo "No EKS cluster found" && exit 0; fi

    CLUSTER=$($GUM choose $CLUSTERS)

    $GUM format -- "Switching k8s context to cluster: **$CLUSTER** ($REGION)"
    $AWS eks update-kubeconfig --name $CLUSTER --region $REGION
    if [ $? -ne 0 ]; then exit 1; fi

    $GUM format -- "Setting default namespace to **$DEFAULT_K8S_NS**"
    $KUBENS $DEFAULT_K8S_NS
  '';

  select-aws-profile = pkgs.writeShellScriptBin "select-aws-profile" ''
    FZF="${lib.getExe pkgs.fzf}";
    FZF_OPTIONS="--preview-window=hidden --height=80%";
    RG="${lib.getExe pkgs.ripgrep}";
    SED="${pkgs.gnused}/bin/sed";

    PROFILE=$($RG profile ~/.aws/config | $SED -E 's/\[profile\s(\S+)\]/\1/g' | $FZF $FZF_OPTIONS)
    echo "export AWS_PROFILE=$PROFILE" > ~/.aws_selected_profile
  '';

  select-aws-region = pkgs.writeShellScriptBin "select-aws-region" ''
    GUM="${lib.getExe pkgs.gum}"
    DEFAULT_AWS_REGION_LIST="${lib.strings.concatStringsSep " " config.os76Cfg.defAwsRegionList}"

    $GUM format -- "Choose AWS region:"
    REGION=$($GUM choose $DEFAULT_AWS_REGION_LIST)
    echo "export AWS_REGION=$REGION" > ~/.aws_selected_region
  '';
in {
  home.packages = [
    shell-aws-generic-ckecks
    select-aws-profile
    select-aws-region
    aws-ec2-list-instances
    aws-eks-switch-cluster
  ];

  programs.bash = {
    shellAliases = {
      aws-whoami = "aws sts get-caller-identity";
      aws-unset = "unset AWS_PROFILE && unset AWS_REGION";
      aws-select-profile = "select-aws-profile && source ~/.aws_selected_profile";
      aws-select-region = "select-aws-region && source ~/.aws_selected_region";
      noaws = "aws sso logout && unset AWS_PROFILE";
      aws-unset-profile = "unset AWS_PROFILE";
      aws-switch-region = "select-aws-region && source ~/.aws_selected_region";
    };
  };
}
