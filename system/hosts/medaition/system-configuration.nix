{
  imports = [
    ./hardware-configuration.nix
  ];

  # SSH access for headless server
  services.openssh = {
    enable = true;
    settings = {
      PasswordAuthentication = false;
      PermitRootLogin = "no";
    };
  };
}
