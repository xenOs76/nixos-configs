{
  description = "A simple NixOS flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-24.11";
    home-manager = {
      url = "github:nix-community/home-manager/release-24.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixvim = {
      url = "github:nix-community/nixvim/nixos-24.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = {
    self,
    nixpkgs,
    home-manager,
    nixvim,
    sops-nix,
    ...
  } @ inputs: let
    system = "aarch64-linux";
    pkgs = nixpkgs.legacyPackages.${system};
  in {
    nixosConfigurations = {
      zero = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          ./hosts/zero/configuration.nix
          ./modules/nixos
          ./modules/nixos/zero
          nixvim.nixosModules.nixvim
          sops-nix.nixosModules.sops
          {
            sops.age.sshKeyPaths = ["/etc/ssh/ssh_host_ed25519_key"];
            sops.age.keyFile = "/var/lib/sops-nix/key.txt";
            sops.age.generateKey = true;
            sops.defaultSopsFile = ./secrets/hosts/zero/secrets.yaml;
          }
          home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.backupFileExtension = "backup";
            home-manager.sharedModules = [
              inputs.sops-nix.homeManagerModules.sops
            ];
            home-manager.users.xeno = import ./home-xeno.nix;
            home-manager.users.root = import ./home-root.nix;
          }
        ];
      };

      slim = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
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
          home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.backupFileExtension = "backup";
            home-manager.sharedModules = [
              inputs.sops-nix.homeManagerModules.sops
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
