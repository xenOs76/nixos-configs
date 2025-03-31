{pkgs, ...}: let
  aws-ec2-list-instances = pkgs.writeShellScriptBin "aws-ec2-list-instances" ''
    AWS=${pkgs.awscli2}/bin/aws
    GUM=${pkgs.gum}/bin/gum
    FZF=${pkgs.fzf}/bin/fzf

    AWS_QUERY="Reservations[*].Instances[*].{Name:Tags[?Key=='Name']|[0].Value,InstanceID:InstanceId,Status:State.Name,PublicIp:PublicIpAddress,PrivateIp:PrivateIpAddress,SSHKey:KeyName}"
    AWS_FILTERS="Name=tag:Name,Values='*'"
    FZF_OPTIONS="--preview-window=hidden --height=80% --query=running"

    $GUM format -- "Choose AWS region:"
    REGION=$($GUM choose eu-central-1 eu-west-1 us-east-1)

    $AWS ec2 describe-instances --region $REGION --query $AWS_QUERY --filters $AWS_FILTERS --output table | $FZF $FZF_OPTIONS
  '';

  aws-eks-switch-cluster = pkgs.writeShellScriptBin "aws-eks-switch-cluster" ''
    GUM=${pkgs.gum}/bin/gum
    AWS=${pkgs.awscli2}/bin/aws
    JQ=${pkgs.jq}/bin/jq
    KUBENS=${pkgs.kubectx}/bin/kubens
    REGIONS="eu-central-1 us-east-1 eu-west-1"
    DEFAULT_NS="default"

    $GUM format -- "Choose AWS region:"
    REGION=$($GUM choose $REGIONS)
    CLUSTERS=$($AWS eks list-clusters --region $REGION | $JQ -r '.clusters[]')

    if [ -z "$CLUSTERS" ]; then echo "No EKS cluster found" && exit 0; fi

    CLUSTER=$($GUM choose $CLUSTERS)

    $GUM format -- "Switching k8s context to cluster: **$CLUSTER** ($REGION)"
    $AWS eks update-kubeconfig --name $CLUSTER --region $REGION
    if [ $? -ne 0 ]; then exit 1; fi

    $GUM format -- "Setting default namespace to **$DEFAULT_NS**"
    $KUBENS $DEFAULT_NS
  '';

  select-aws-profile = pkgs.writeShellScriptBin "select-aws-profile" ''
    RG=${pkgs.ripgrep}/bin/rg
    SED=${pkgs.gnused}/bin/sed
    FZF=${pkgs.fzf}/bin/fzf

    FZF_OPTIONS="--preview-window=hidden --height=80%"
    PROFILE=$($RG profile ~/.aws/config | $SED -E 's/\[profile\s(\S+)\]/\1/g' | $FZF $FZF_OPTIONS)
    echo "export AWS_PROFILE=$PROFILE" > ~/.aws_selected_profile
  '';

  select-aws-region = pkgs.writeShellScriptBin "select-aws-region" ''
    GUM=${pkgs.gum}/bin/gum
    REGIONS="eu-central-1 us-east-1 eu-west-1"

    $GUM format -- "Choose AWS region:"
    REGION=$($GUM choose $REGIONS)
    echo "export AWS_REGION=$REGION" > ~/.aws_selected_region
  '';

  k3s_config_ro_path = "/home/xeno/.kube/config-ro";
  k3s-sync-config-from-secret = pkgs.writeShellScriptBin "k3s-sync-config-from-secret" ''
    cat ${k3s_config_ro_path} > ~/.kube/config && chmod 700 ~/.kube/config
  '';

  plasmashell-replace = pkgs.writeShellScriptBin "plasmashell-replace" ''
    plasmashell --replace &
  '';
in {
  sops.secrets.k3s_config = {
    path = k3s_config_ro_path;
  };

  home.packages = [
    select-aws-profile
    select-aws-region
    aws-ec2-list-instances
    aws-eks-switch-cluster
    k3s-sync-config-from-secret
    plasmashell-replace
  ];

  programs.bash.shellAliases = {
    aws-unset = "unset AWS_PROFILE && unset AWS_REGION";
    aws-select-profile = "select-aws-profile && source ~/.aws_selected_profile";
    aws-select-region = "select-aws-region && source ~/.aws_selected_region";
  };
}
