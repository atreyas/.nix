#!/usr/bin/env bash
set -e

echo "=== Agenix Secrets Setup ==="
echo

# Check for SSH key
if [ ! -f ~/.ssh/id_ed25519.pub ]; then
    echo "No SSH key found. Generating one..."
    ssh-keygen -t ed25519 -C "atreyas@gmail.com"
    echo
fi

# Get user SSH public key
USER_KEY=$(cat ~/.ssh/id_ed25519.pub)
echo "Your SSH public key:"
echo "$USER_KEY"
echo

# Get system host key
echo "Getting system host key (requires sudo)..."
SYSTEM_KEY=$(sudo cat /etc/ssh/ssh_host_ed25519_key.pub)
echo "$SYSTEM_KEY"
echo

# Update secrets.nix
echo "Updating secrets/secrets.nix with your keys..."
cat > secrets.nix <<EOF
let
  # Your user SSH public key
  atreyas = "$USER_KEY";

  users = [ atreyas ];
  systems = [
    # System SSH host key
    "$SYSTEM_KEY"
  ];
  allKeys = users ++ systems;
in
{
  # Define your secrets here
  # Uncomment the ones you want to use:

  # "user-password.age".publicKeys = allKeys;
  # "github-token.age".publicKeys = allKeys;
  # "ssh-key.age".publicKeys = allKeys;
  # "example-env.age".publicKeys = allKeys;
}
EOF

echo "✓ secrets.nix updated!"
echo
echo "Next steps:"
echo "1. Edit secrets.nix and uncomment the secrets you want to use"
echo "2. Run: nix flake update (in ~/.nix)"
echo "3. Rebuild your system: sudo nixos-rebuild switch --flake ~/.nix"
echo "4. Create secrets with: agenix -e <secret-name>.age"
echo
echo "See README.md for detailed usage instructions."
