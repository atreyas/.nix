let
  # Define your users and systems here
  atreyas = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIPlaceholderKeyReplaceWithYourActualSSHPublicKey";

  users = [ atreyas ];
  systems = [
    # Add your system's SSH host keys here
    # You can find them in /etc/ssh/ssh_host_ed25519_key.pub
  ];
  allKeys = users ++ systems;
in
{
  # Example secrets - uncomment and modify as needed
  # "user-password.age".publicKeys = allKeys;
  # "github-token.age".publicKeys = allKeys;
  # "ssh-key.age".publicKeys = allKeys;
  # "example-env.age".publicKeys = allKeys;
}
