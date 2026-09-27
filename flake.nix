{
  description = "Homelab NixOS flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-26.05";

    nixpkgsUnstable.url = "github:NixOS/nixpkgs/nixpkgs-unstable";

    home-manager = {
      url = "github:nix-community/home-manager/release-26.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nvf = {
      url = "github:NotAShelf/nvf/07d5eb208b8f16306b10342b634da7e07e926fa5"; # 2026-07-24
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nvfOs76 = {
      url = "git+https://git.priv.os76.xyz/xeno/os76-nvf?ref=refs/tags/0.0.32";
      inputs.nixpkgs.follows = "nixpkgs";
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
      url = "github:catppuccin/nix/release-26.05";
      inputs.nixpkgs.follows = "nixpkgs";
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
  };

  nixConfig = {
    extra-substituters = [
      "https://cache.nixos.org"
      "https://nix-community.cachix.org"
      "https://nixpkgs-terraform.cachix.org"
      "https://nvf.cachix.org"
      "https://catppuccin.cachix.org"
    ];
    extra-trusted-public-keys = [
      "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
      "nixpkgs-terraform.cachix.org-1:8Sit092rIdAVENA3ZVeH9hzSiqI/jng6JiCrQ1Dmusw="
      "nvf.cachix.org-1:GMQWiUhZ6ux9D5CvFFMwnc2nFrUHTeGaXRlVBXo+naI="
      "catppuccin.cachix.org-1:noG/4HkbhJb+lUAdKrph6LaozJvAeEEZj4N732IysmU="
    ];
  };

  outputs =
    {
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
      ...
    }@inputs:
    let
      system = "x86_64-linux";

      gitlineage-repo = inputs.gitlineage-nvim;

      os76CfgDefaults = {
        checkValue = "from flake";
      };

      os76CfgFor = hostCfg: nixpkgs.lib.recursiveUpdate os76CfgDefaults hostCfg;

      os76CfgZero = os76CfgFor { };
      os76CfgNemo = os76CfgFor {
        desktopFonts = {
          ui = {
            size = 11;
          };
          mono = {
            size = 11;
          };
          dpi = 96;
          cursorSize = 24;
        };
        firefoxFonts = {
          ui = {
            size = 15;
          };
          mono = {
            size = 15;
          };
        };
      };

      ### NVF/Neovim config ###
      os76NvfCfg = {
        # terraformVersion = "1.14";
        terraformAutoformat = true;
        yamlAutoformat = true;
      };

      nixpkgsConfig = {
        allowUnfree = true;
        permittedInsecurePackages = [
          "pnpm-9.15.9"
        ];
      };

      nvfOs76Ide = nvf.lib.neovimConfiguration {
        pkgs = import nixpkgs {
          inherit system;
          config = nixpkgsConfig;
        };
        modules = [
          "${nvfOs76}/modules/nvim/default.nix"
          { inherit os76NvfCfg; }

          "${nvfOs76}/modules/nvim/ide/default.nix"
        ];
        extraSpecialArgs = {
          inherit nixpkgs-terraform;
          pkgsUnstable = import nixpkgsUnstable {
            inherit system;
            config.allowUnfree = true;
          };
          inherit gitlineage-repo;
        };
      };
    in
    {
      exportedInputs = inputs;
      nixosConfigurations = {
        zero = nixpkgs.lib.nixosSystem {
          specialArgs = {
            inherit inputs;
          };
          modules = [
            {
              nixpkgs.pkgs = import nixpkgs {
                localSystem = system;
                config = nixpkgsConfig;
              };
            }
            (
              {
                inputs,
                pkgs,
                ...
              }:
              {
                _module.args = {
                  pkgsUnstable = import nixpkgsUnstable {
                    inherit (pkgs) system;
                    config.allowUnfree = true;
                  };
                  nurpkgs = nur.legacyPackages.${pkgs.system};
                  os76Pkgs = import nurOs76 { inherit pkgs; };
                  os76PrivPkgs = import nurOs76Priv { inherit pkgs; };
                };
              }
            )
            ({ os76Pkgs, os76PrivPkgs, ... }: {
              environment.systemPackages = [
                os76PrivPkgs.https-wrench
                os76Pkgs.kubectl-netshoot
                os76Pkgs.kubectl-netdrill
                os76Pkgs.kubectl-crdlist
                os76Pkgs.aws-probe
              ];
            })
            ./hosts/zero/configuration.nix
            ./modules/nixos
            ./modules/nixos/zero
            nur.modules.nixos.default
            ({ pkgs, ... }: {
              environment.systemPackages = with pkgs.nur.repos.charmbracelet; [
                crush
                vhs
              ];
            })
            sops-nix.nixosModules.sops
            {
              sops = {
                age = {
                  sshKeyPaths = [ "/etc/ssh/ssh_host_ed25519_key" ];
                  keyFile = "/var/lib/sops-nix/key.txt";
                  generateKey = true;
                };
                defaultSopsFile = ./secrets/hosts/zero/secrets.yaml;
              };
            }
            catppuccin.nixosModules.catppuccin
            home-manager.nixosModules.home-manager
            (
              {
                pkgsUnstable,
                nurpkgs,
                ...
              }:
              {
                home-manager = {
                  useGlobalPkgs = true;
                  useUserPackages = true;
                  backupFileExtension = "backup";
                  overwriteBackup = true;
                  extraSpecialArgs = {
                    inherit inputs pkgsUnstable nurpkgs;
                    os76Cfg = os76CfgZero;
                  };
                };
                home-manager.sharedModules = [
                  inputs.sops-nix.homeManagerModules.sops
                  inputs.catppuccin.homeModules.catppuccin
                  ./modules/common/catppuccin-whiskers.nix
                  { home.packages = [ nvfOs76Ide.neovim ]; }
                ];
                home-manager.users.xeno = import ./home-xeno.nix;
                home-manager.users.root = import ./home-root.nix;
              }
            )
          ];
        };

        nemo = nixpkgs.lib.nixosSystem {
          specialArgs = {
            inherit inputs;
          };
          modules = [
            {
              nixpkgs.pkgs = import nixpkgs {
                localSystem = system;
                config = nixpkgsConfig;
              };
            }
            (
              {
                inputs,
                pkgs,
                ...
              }:
              {
                _module.args = {
                  pkgsUnstable = import nixpkgsUnstable {
                    inherit (pkgs) system;
                    config.allowUnfree = true;
                  };
                  nurpkgs = nur.legacyPackages.${pkgs.system};
                  os76Pkgs = import nurOs76 { inherit pkgs; };
                };
              }
            )
            ./hosts/nemo/configuration.nix
            ./modules/nixos
            ./modules/nixos/nemo
            sops-nix.nixosModules.sops
            {
              sops = {
                age = {
                  sshKeyPaths = [ "/etc/ssh/ssh_host_ed25519_key" ];
                  keyFile = "/var/lib/sops-nix/key.txt";
                  generateKey = true;
                };
                defaultSopsFile = ./secrets/hosts/nemo/secrets.yaml;
              };
            }
            catppuccin.nixosModules.catppuccin
            home-manager.nixosModules.home-manager
            (
              {
                pkgsUnstable,
                nurpkgs,
                ...
              }:
              {
                home-manager = {
                  useGlobalPkgs = true;
                  useUserPackages = true;
                  backupFileExtension = "backup";
                  overwriteBackup = true;
                  extraSpecialArgs = {
                    inherit inputs pkgsUnstable nurpkgs;
                    os76Cfg = os76CfgNemo;
                  };
                };
                home-manager.sharedModules = [
                  inputs.sops-nix.homeManagerModules.sops
                  inputs.catppuccin.homeModules.catppuccin
                  ./modules/common/catppuccin-whiskers.nix
                  { home.packages = [ nvfOs76Ide.neovim ]; }
                ];
                home-manager.users.xeno = import ./home-xeno.nix;
                home-manager.users.root = import ./home-root.nix;
              }
            )
          ];
        };

        xor = nixpkgs.lib.nixosSystem {
          system = "aarch64-linux";
          specialArgs = { inherit inputs; };
          modules = [ ./hosts/xor/configuration.nix ];
        };
      };
    };
}
