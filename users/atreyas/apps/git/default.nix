{ pkgs, user, ... }:

{
  programs.git = {
    enable = true;
    includes = [ { path = "./gitconfig"; } ];
    settings = {
      user.name = "Atreya Srivathsan";
      user.email = "${user.email}";
      credential.helper = "manager";
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

  home.packages = with pkgs; [ git-credential-manager ];
}
