#!/bin/sh
pushd ~/.nix
sudo nixos-rebuild switch --flake .#
popd
