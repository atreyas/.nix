{ pkgs, user, ... }:

{
  programs.git = {
    enable = true;
    includes = [ { path = "./gitconfig"; } ];
    userName = "Atreya Srivathsan";
    userEmail = "${user.email}";
    diff-so-fancy = {
      enable = false;
      changeHunkIndicators = true;
    };
    difftastic = {
      enable = true;
      background = "dark";
      color = "auto";
      display = "inline";

    };
    lfs.enable = true;
    extraConfig = {
      credential.helper = "manager";
    };
  };
  home.packages = with pkgs; [ git-credential-manager ];
}
