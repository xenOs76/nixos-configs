{
  config,
  lib,
  ...
}: {
  options.os76.nix.githubToken = {
    enable = lib.mkEnableOption "GitHub token for Nix access-tokens (via sops-nix)";
  };

  config = {
    sops.secrets.nix_github_token = lib.mkIf config.os76.nix.githubToken.enable {
      mode = "0440";
      owner = "root";
      group = "nixbld";
    };

    sops.templates.nix-access-tokens = lib.mkIf config.os76.nix.githubToken.enable {
      owner = "root";
      group = "nixbld";
      mode = "0440";
      content = ''
        access-tokens = github.com=${config.sops.placeholder.nix_github_token}
      '';
    };

    nix.extraOptions = lib.mkIf config.os76.nix.githubToken.enable (
      lib.mkAfter ''
        !include ${config.sops.templates.nix-access-tokens.path}
      ''
    );
  };
}
