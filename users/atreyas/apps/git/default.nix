{ pkgs, user, ... }:

{
  programs.git = {
    enable = true;
    userName = "Atreya Srivathsan";
    userEmail = "${user.email}";
    lfs.enable = true;
    extraConfig = {
      credential.helper = "manager";
    };
  };
  home.packages = with pkgs; [ git-credential-manager ];
}
