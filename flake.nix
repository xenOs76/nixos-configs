{
  description = "Homelab NixOS flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.11";

    nixpkgsUnstable.url = "github:NixOS/nixpkgs/nixpkgs-unstable";

    home-manager = {
      url = "github:nix-community/home-manager/release-25.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nvf = {
      url = "github:notashelf/nvf/v0.8";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nvfOs76 = {
      url = "github:xenos76/os76-nvf/0.0.3";
      # url = "git+https://git.priv.os76.xyz/xeno/os76-nvf.git";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    catppuccin = {
      # url = "github:catppuccin/nix/release-25.11";
      url = "github:catppuccin/nix";
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
    nvf,
    nvfOs76,
    catppuccin,
    home-manager,
    sops-nix,
    ...
  } @ inputs: let
    system = "x86_64-linux";
    pkgs = nixpkgs.legacyPackages.${system};
    pkgsUnstable = import nixpkgsUnstable {inherit system;};

    # os76PrivPkgs = import nurOs76Priv {pkgs = pkgs;};
    os76Pkgs = import nurOs76 {inherit pkgs;};

    nvfOs76Ide = nvf.lib.neovimConfiguration {
      inherit pkgs;
      modules = [
        "${nvfOs76}/modules/nvim/default.nix"
        "${nvfOs76}/modules/nvim/ide/default.nix"
      ];
    };
  in {
    exportedInputs = inputs;
    nixosConfigurations = {
      zero = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
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
            sops = {
              age = {
                sshKeyPaths = ["/etc/ssh/ssh_host_ed25519_key"];
                keyFile = "/var/lib/sops-nix/key.txt";
                generateKey = true;
              };
              defaultSopsFile = ./secrets/hosts/zero/secrets.yaml;
            };
          }
          catppuccin.nixosModules.catppuccin
          home-manager.nixosModules.home-manager
          {
            home-manager = {
              useGlobalPkgs = true;
              useUserPackages = true;
              backupFileExtension = "backup";
              extraSpecialArgs = {inherit pkgsUnstable;};
            };
            home-manager.sharedModules = [
              inputs.sops-nix.homeManagerModules.sops
              inputs.catppuccin.homeModules.catppuccin
              {home.packages = [nvfOs76Ide.neovim];}
            ];
            home-manager.users.xeno = import ./home-xeno.nix;
            home-manager.users.root = import ./home-root.nix;
          }
        ];
      };

      slim = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = {
          inherit inputs pkgsUnstable;
        };
        modules = [
          ./hosts/slim/configuration.nix
          ./modules/nixos
          ./modules/nixos/slim
          sops-nix.nixosModules.sops
          {
            sops = {
              age = {
                sshKeyPaths = ["/etc/ssh/ssh_host_ed25519_key"];
                keyFile = "/var/lib/sops-nix/key.txt";
                generateKey = true;
              };
              defaultSopsFile = ./secrets/hosts/slim/secrets.yaml;
            };
          }
          catppuccin.nixosModules.catppuccin
          home-manager.nixosModules.home-manager
          {
            home-manager = {
              useGlobalPkgs = true;
              useUserPackages = true;
              backupFileExtension = "backup";
              extraSpecialArgs = {inherit pkgsUnstable;};
            };
            home-manager.sharedModules = [
              inputs.sops-nix.homeManagerModules.sops
              inputs.catppuccin.homeModules.catppuccin
              {home.packages = [nvfOs76Ide.neovim];}
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
  };
}
