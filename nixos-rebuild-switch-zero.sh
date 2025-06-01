#!/usr/bin/env bash

test "$(hostname)" == "zero" || exit 1
sudo nixos-rebuild switch --flake ./#zero
