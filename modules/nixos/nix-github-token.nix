{config, lib, ...}: {
  sops.secrets.nix_github_token = {
    mode = "0440";
    owner = "root";
    group = "nixbld";
  };

  sops.templates.nix-access-tokens = {
    owner = "root";
    group = "nixbld";
    mode = "0440";
    content = ''
      access-tokens = github.com=${config.sops.placeholder.nix_github_token}
    '';
  };

  nix.extraOptions = lib.mkAfter ''
    !include ${config.sops.templates.nix-access-tokens.path}
  '';
}
