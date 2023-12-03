#!/bin/sh
pushd ~/.nix
home-manager switch --flake ./users/atreyas/;
#... other users ...
popd
