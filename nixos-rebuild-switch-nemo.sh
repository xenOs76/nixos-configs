#!/usr/bin/env bash

test "$(hostname)" == "nemo" || exit 1
sudo nixos-rebuild switch --flake ./#nemo
