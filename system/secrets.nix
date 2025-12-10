{ config, pkgs, user, inputs, system, ... }:

{
  # Make agenix CLI available
  environment.systemPackages = [
    inputs.agenix.packages.${system}.default
  ];

  # Define your secrets here
  # Each secret will be decrypted at boot and placed in /run/agenix/
  age.secrets = {
    # Example: User password file
    # user-password = {
    #   file = ../secrets/user-password.age;
    #   # Optional: specify owner, group, mode
    #   # owner = user.name;
    #   # group = "users";
    #   # mode = "600";
    # };

    # Example: GitHub token
    # github-token = {
    #   file = ../secrets/github-token.age;
    #   owner = user.name;
    # };

    # Example: SSH private key
    # ssh-key = {
    #   file = ../secrets/ssh-key.age;
    #   owner = user.name;
    #   mode = "600";
    # };

    # Example: Environment file
    # example-env = {
    #   file = ../secrets/example-env.age;
    #   owner = user.name;
    # };
  };

  # Example: Use secret as hashed password file
  # Uncomment once you've created the user-password.age secret
  # users.users.${user.name}.hashedPasswordFile = config.age.secrets.user-password.path;
}
