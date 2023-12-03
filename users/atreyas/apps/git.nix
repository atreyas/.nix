{
  programs.git = {
    enable = true;
    userName = "Atreya Srivathsan";
    userEmail = "atreyas@gmail.com";
    lfs.enable = true;
    extraConfig = {
      credential.helper = "manager";
    };
  };
  programs.git-credential-manager.enable = true;
}
