{
  # Reuse the GitHub token already provisioned for goproxy.
  sops.secrets.nix_github_token = {
    key = "goproxy_github_token";
  };
}
