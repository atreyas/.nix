{ pkgs, user, config, ... }:

let
  # Git credential helper that uses agenix secret
  git-credential-agenix = pkgs.writeShellScriptBin "git-credential-agenix" ''
    # Read the command (get, store, erase)
    action="$1"

    if [ "$action" = "get" ]; then
      # Read input to check if this is for github.com
      input=$(cat)

      if echo "$input" | grep -q "host=github.com"; then
        # Check if the secret file exists
        if [ -f /run/agenix/github-token ]; then
          token=$(cat /run/agenix/github-token)
          echo "protocol=https"
          echo "host=github.com"
          echo "username=git"
          echo "password=$token"
        fi
      fi
    fi
    # Ignore store and erase actions for this credential helper
  '';
in
{
  programs.git = {
    enable = true;
    includes = [ { path = "./gitconfig"; } ];
    settings = {
      user.name = "Atreya Srivathsan";
      user.email = "${user.email}";
      # Use agenix credential helper for GitHub
      credential.helper = "${git-credential-agenix}/bin/git-credential-agenix get";
    };
    lfs.enable = true;
  };
  programs.difftastic = {
    enable = true;
    options = {
      color = "auto";
      background = "dark";
      display = "inline";
    };
  };
  programs.diff-so-fancy = {
    enable = false;
    settings.changeHunkIndicators = true;
  };

  home.packages = with pkgs; [
    git-credential-agenix
  ];
}
