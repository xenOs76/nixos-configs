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

    mkcert_default_root_ca_cert = {
      path = "/home/xeno/.config/mkcert/star.home.arpa-RootCA-cert.pem";
    };

    mkcert_default_root_ca_key = {
      path = "/home/xeno/.config/mkcert/star.home.arpa-RootCA-key.pem";
    };

    mkcert_star_home_arpa_cert = {
      path = "/home/xeno/.config/mkcert/star.home.arpa-cert.pem";
    };

    mkcert_star_home_arpa_key = {
      path = "/home/xeno/.config/mkcert/star.home.arpa-key.pem";
    };

    jwtinfo_test_auth0_req_values = {
      path = "/home/xeno/.config/https-wrench/jwtinfo_test_auth0_req_values.json";
    };

    jwtinfo_test_keycloak_req_values = {
      path = "/home/xeno/.config/https-wrench/jwtinfo_test_keycloak_req_values.json";
    };
  };
}
