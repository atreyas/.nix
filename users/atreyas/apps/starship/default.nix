{ config, lib, ... }:
# let
#   lang = icon: color: {
#     symbol = icon;
#     format = "[$symbol ]($({color})";
#   };
# in
{
  home.sessionVariables.STARSHIP_CACHE = "${config.xdg.cacheHome}/starship";
  programs.starship = {
    enable = true;
    settings = {
      add_newline = true;
      # format = lib.strings.concatStrings [
      #   "$nix_shell"
      #   "$os"
      #   "$directory"
      #   "$git_branch $git_status"
      #   "$python"
      #   "$nodejs"
      #   "$lua"
      #   "$rust"
      #   "$java"
      # ];
      git_status = {
        deleted = "✗";
        modified = "✶";
        staged = "✓";
        stashed = "≡";
      };

      nix_shell = {
        symbol = " ";
        heuristic = true;
      };
    };
  };
}
