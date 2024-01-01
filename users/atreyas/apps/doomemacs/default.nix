{ inputs, pkgs, system, ... }:
{
  imports = [ inputs.doom-emacs.hmModule ];
  services.emacs.enable = true;
  programs.doom-emacs = {
    enable = true;
    doomPrivateDir = ./doom.d;
  };
}
