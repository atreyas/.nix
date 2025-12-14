{ config, pkgs, user, inputs, system, ... }:

{
  # Make agenix CLI available
  environment.systemPackages = [
    inputs.agenix.packages.${system}.default
  ];

  # Tell agenix where to find the decryption key
  age.identityPaths = [ "/home/${user.name}/.config/age/keys.txt" ];

  # Define your secrets here
  # Each secret will be decrypted at boot and placed in /run/agenix/
  age.secrets = {
    github-token = {
      file = ../secrets/github-token.age;
      owner = user.name;
      mode = "600";
    };
  };

  # Example: Use secret as hashed password file
  # Uncomment once you've created the user-password.age secret
  # users.users.${user.name}.hashedPasswordFile = config.age.secrets.user-password.path;
}
