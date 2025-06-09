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
  };
}
