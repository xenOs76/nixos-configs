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
      url = "git+https://git.priv.os76.xyz/xeno/os76-nvf?ref=refs/tags/0.0.20";
      # inputs.nixpkgs.follows = "nixpkgs";
    };

    gitlineage-nvim = {
      # url = "github:LionyxML/gitlineage.nvim";
      url = "github:zenangst/gitlineage.nvim?ref=fix/file-not-tracked-by-git";
      flake = false;
    };

    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    catppuccin = {
      url = "github:catppuccin/nix/release-25.11";
    };

    nur = {
      url = "github:nix-community/NUR";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nurOs76Priv = {
      url = "git+https://git.priv.os76.xyz/xeno/nur";
    };

    nurOs76 = {
      url = "github:xenos76/nur-packages";
    };

    nixpkgs-terraform.url = "github:stackbuilders/nixpkgs-terraform";
    antigravity.url = "github:jacopone/antigravity-nix";
  };

  nixConfig = {
    extra-substituters = [
      "https://cache.nixos.org"
      "https://nix-community.cachix.org"
      "https://nixpkgs-terraform.cachix.org"
      "https://nvf.cachix.org"
    ];
    extra-trusted-public-keys = [
      "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
      "nixpkgs-terraform.cachix.org-1:8Sit092rIdAVENA3ZVeH9hzSiqI/jng6JiCrQ1Dmusw="
      "nvf.cachix.org-1:GMQWiUhZ6ux9D5CvFFMwnc2nFrUHTeGaXRlVBXo+naI="
    ];
  };

  outputs = {
    # self,
    nixpkgs,
    nixpkgsUnstable,
    nur,
    nurOs76Priv,
    nurOs76,
    nvf,
    nvfOs76,
    catppuccin,
    home-manager,
    nixpkgs-terraform,
    sops-nix,
    antigravity,
    ...
  } @ inputs: let
    system = "x86_64-linux";
    pkgs = nixpkgs.legacyPackages.${system};
    pkgsUnstable = import nixpkgsUnstable {inherit system;};
    nurpkgs = nur.legacyPackages.${system};
    os76PrivPkgs = import nurOs76Priv {pkgs = pkgs;};
    os76Pkgs = import nurOs76 {inherit pkgs;};

    gitlineage-repo = inputs.gitlineage-nvim;

    os76Cfg = {
      checkValue = "from flake";
      firefoxAdditionalCertificates = ["/home/xeno/.config/mkcert/star.home.arpa-RootCA-cert.pem"];
    };

    ### NVF/Neovim config ###
    os76NvfCfg = {
      terraformVersion = "1.14";
      terraformAutoformat = true;
      yamlAutoformat = true;
    };

    nvfOs76Ide = nvf.lib.neovimConfiguration {
      inherit pkgs;
      modules = [
        "${nvfOs76}/modules/nvim/default.nix"
        {inherit os76NvfCfg;}

        "${nvfOs76}/modules/nvim/ide/default.nix"
      ];
      extraSpecialArgs = {
        inherit nixpkgs-terraform;
        inherit gitlineage-repo;
      };
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
              os76Pkgs.kubectl-netshoot
              os76Pkgs.kubectl-netdrill
              os76Pkgs.kubectl-crdlist
              #os76Pkgs.aws-probe
            ];
          }
          ./hosts/zero/configuration.nix
          ./modules/nixos
          ./modules/nixos/zero
          nur.modules.nixos.default
          (
            {pkgs, ...}: {
              environment.systemPackages = with pkgs.nur.repos.charmbracelet; [
                crush
                vhs
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
              extraSpecialArgs = {
                inherit pkgsUnstable;
                inherit nurpkgs;
                inherit os76Cfg;
                inherit antigravity;
              };
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
              extraSpecialArgs = {
                inherit pkgsUnstable;
                inherit nurpkgs;
                inherit os76Cfg;
                inherit antigravity;
              };
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
