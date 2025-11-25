{
  description = "A simple NixOS flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.05";
    nixpkgsUnstable.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    home-manager = {
      url = "github:nix-community/home-manager/release-25.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixvim = {
      # url = "github:nix-community/nixvim";
      url = "github:nix-community/nixvim/nixos-25.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    catppuccin = {
      url = "github:catppuccin/nix/release-25.05";
    };
    nur = {
      url = "github:nix-community/NUR";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nurOs76Priv = {
      url = "git+https://git.priv.os76.xyz/xeno/nur.git";
    };
    nurOs76 = {
      url = "github:xenos76/nur-packages";
    };
  };

  outputs = {
    # self,
    nixpkgs,
    nixpkgsUnstable,
    nur,
    # nurOs76Priv,
    nurOs76,
    catppuccin,
    home-manager,
    nixvim,
    sops-nix,
    ...
  } @ inputs: let
    # TODO: need generic system to manage multi-arch pkgs
    system = "x86_64-linux";
    pkgs = nixpkgs.legacyPackages.${system};
    pkgsUnstable = import nixpkgsUnstable {inherit system;};
    # os76PrivPkgs = import nurOs76Priv {pkgs = pkgs;};
    os76Pkgs = import nurOs76 {pkgs = pkgs;};
  in {
    nixosConfigurations = {
      zero = nixpkgs.lib.nixosSystem {
        # system = "x86_64-linux";
        specialArgs = {
          inherit inputs pkgsUnstable;
        };
        modules = [
          {
            environment.systemPackages = [
              os76Pkgs.https-wrench
            ];
          }
          ./hosts/zero/configuration.nix
          ./modules/nixos
          ./modules/nixos/zero
          nixvim.nixosModules.nixvim
          nur.modules.nixos.default
          (
            {pkgs, ...}: {
              environment.systemPackages = with pkgs.nur.repos.charmbracelet; [
                gum
                vhs
                freeze
                crush
              ];
            }
          )
          sops-nix.nixosModules.sops
          {
            sops.age.sshKeyPaths = ["/etc/ssh/ssh_host_ed25519_key"];
            sops.age.keyFile = "/var/lib/sops-nix/key.txt";
            sops.age.generateKey = true;
            sops.defaultSopsFile = ./secrets/hosts/zero/secrets.yaml;
          }
          catppuccin.nixosModules.catppuccin
          home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.backupFileExtension = "backup";
            home-manager.extraSpecialArgs = {
              inherit pkgsUnstable;
            };
            home-manager.sharedModules = [
              inputs.sops-nix.homeManagerModules.sops
              inputs.catppuccin.homeModules.catppuccin
            ];
            home-manager.users.xeno = import ./home-xeno.nix;
            home-manager.users.root = import ./home-root.nix;
          }
        ];
      };

      slim = nixpkgs.lib.nixosSystem {
        # system = "x86_64-linux";
        specialArgs = {
          inherit inputs pkgsUnstable;
        };
        modules = [
          ./hosts/slim/configuration.nix
          ./modules/nixos
          ./modules/nixos/slim
          nixvim.nixosModules.nixvim
          sops-nix.nixosModules.sops
          {
            sops.age.sshKeyPaths = ["/etc/ssh/ssh_host_ed25519_key"];
            sops.age.keyFile = "/var/lib/sops-nix/key.txt";
            sops.age.generateKey = true;
            sops.defaultSopsFile = ./secrets/hosts/slim/secrets.yaml;
          }
          catppuccin.nixosModules.catppuccin
          home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.backupFileExtension = "backup";
            home-manager.extraSpecialArgs = {inherit pkgsUnstable;};
            home-manager.sharedModules = [
              inputs.sops-nix.homeManagerModules.sops
              inputs.catppuccin.homeModules.catppuccin
            ];
            home-manager.users.xeno = import ./home-xeno.nix;
            home-manager.users.root = import ./home-root.nix;
          }
        ];
      };

      xor = nixpkgs.lib.nixosSystem {
        system = "aarch64-linux";
        modules = [./hosts/xor/configuration.nix];
      };
    };

    homeConfigurations = {
      xeno-hm = home-manager.lib.homeManagerConfiguration {
        inherit pkgs;
        modules = [
          ./home-xeno-servers.nix
          nixvim.homeManagerModules.nixvim
        ];
      };
    };
  };
}
