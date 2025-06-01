#!/usr/bin/env bash

test "$(hostname)" == "slim" || exit 1
sudo nixos-rebuild switch --flake ./#slim
