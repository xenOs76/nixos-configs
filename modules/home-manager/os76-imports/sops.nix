{
  sops.secrets = {
    minio_client = {
      path = "/home/xeno/.mc/config.json";
    };
    goreleaser_gitea_token = {
      path = "/home/xeno/.config/goreleaser/gitea_token";
    };
    goreleaser_github_token = {
      path = "/home/xeno/.config/goreleaser/github_token";
    };
    velero_aws_creds_k3s_secret = {
      path = "/home/xeno/.kube/velero_aws_credentials";
    };
    os76_ansible_vault_password = {
      path = "/home/xeno/.config/os76_ansible_vault_password";
    };
    gemini_api_key_cli_testing = {
      path = "/home/xeno/.config/gemini_api_key_cli_testing";
    };
  };
}
