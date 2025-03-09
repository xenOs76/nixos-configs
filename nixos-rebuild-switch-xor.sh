#!/usr/bin/env bash
#
#  Run a nixos-rebuild switch on a Rpi3 from a remote host.
#  Requires the following settings in the host running this script:
#   boot.binfmt.emulatedSystems = [ "aarch64-linux" ];
#
nixos-rebuild --target-host xeno@xor.home.arpa --use-remote-sudo switch --flake ./#xor
