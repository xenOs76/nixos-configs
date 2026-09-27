{inputs, pkgs, ...}: {
  home-manager.users.xeno = {
    home.packages = [
      inputs.nixpkgs-terraform.packages.${pkgs.system}."terraform-1.14"
    ];
  };
}
