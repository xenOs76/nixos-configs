{
  inputs,
  pkgs,
  lib,
  ...
}: let
  whiskersBinary = pkgs.stdenv.mkDerivation {
    pname = "whiskers";
    version = "2.9.0";
    src = pkgs.fetchurl {
      url = "https://github.com/catppuccin/whiskers/releases/download/v2.9.0/whiskers-x86_64-unknown-linux-gnu";
      hash = "sha256-BaNoZr2SCvOwWIVs8rkv3SINpMT/vfikOLXv0dFOEcc=";
    };
    dontUnpack = true;
    nativeBuildInputs = [pkgs.autoPatchelfHook];
    buildInputs = [pkgs.gcc-unwrapped.lib];
    installPhase = ''
      mkdir -p $out/bin
      cp $src $out/bin/whiskers
      chmod +x $out/bin/whiskers
    '';
  };
in {
  catppuccin.sources = lib.mkForce (
    inputs.catppuccin.packages.${pkgs.system}.overrideScope (
      final: prev: {
        whiskers =
          if pkgs.stdenv.isLinux && pkgs.stdenv.isx86_64
          then whiskersBinary
          else prev.whiskers;
      }
    )
  );
}
