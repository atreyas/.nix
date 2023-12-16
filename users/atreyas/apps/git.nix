{config, user, ...}:
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
  programs.git-credential-manager.enable = true;
}
