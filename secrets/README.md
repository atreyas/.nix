# Secrets Management with agenix

This directory contains encrypted secrets for your NixOS configuration using [agenix](https://github.com/ryantm/agenix).

## Initial Setup

### 1. Generate SSH Key (if you don't have one)

```bash
ssh-keygen -t ed25519 -C "atreyas@gmail.com"
```

### 2. Get Your SSH Public Keys

Get your user SSH public key:
```bash
cat ~/.ssh/id_ed25519.pub
```

Get your system's SSH host key:
```bash
sudo cat /etc/ssh/ssh_host_ed25519_key.pub
```

### 3. Update secrets.nix

Edit `secrets/secrets.nix` and replace the placeholder with your actual SSH public keys:

```nix
let
  atreyas = "ssh-ed25519 AAAA... your-actual-key";

  users = [ atreyas ];
  systems = [
    "ssh-ed25519 BBBB... your-system-host-key"
  ];
  allKeys = users ++ systems;
in
{
  "user-password.age".publicKeys = allKeys;
  "github-token.age".publicKeys = allKeys;
}
```

### 4. Rebuild Flake Lock

```bash
cd ~/.nix
nix flake update
```

## Creating Secrets

### Method 1: Using agenix CLI

After rebuilding your system, you'll have the `agenix` command available:

```bash
# Create/edit a secret
cd ~/.nix/secrets
agenix -e user-password.age

# This will open your $EDITOR to enter the secret
```

### Method 2: Using age directly

```bash
# Encrypt a file
cat secret.txt | age -r "ssh-ed25519 AAAA..." > secret.age

# Encrypt with multiple recipients
cat secret.txt | age -r key1 -r key2 > secret.age
```

## Using Secrets in Your Config

### 1. Define the secret in system/secrets.nix

```nix
age.secrets.github-token = {
  file = ../secrets/github-token.age;
  owner = user.name;
  mode = "600";
};
```

### 2. Reference it in your configuration

Secrets are decrypted to `/run/agenix/` at boot:

```nix
# In any Nix config file
config.age.secrets.github-token.path
# => "/run/agenix/github-token"
```

### 3. Use in services or programs

```nix
systemd.services.example = {
  script = ''
    export GITHUB_TOKEN=$(cat ${config.age.secrets.github-token.path})
    # your script here
  '';
};
```

## Common Secret Types

### User Password

```bash
# Generate hashed password
mkpasswd -m sha-512 > /tmp/password-hash

# Encrypt it
agenix -e user-password.age
# Paste the hash, save and quit

# Use in configuration
users.users.atreyas.hashedPasswordFile = config.age.secrets.user-password.path;
```

### API Tokens

```bash
# Create the secret
agenix -e github-token.age
# Enter your token, save and quit

# Use in home-manager or systemd services
programs.git.extraConfig.github.oauth-token =
  builtins.readFile config.age.secrets.github-token.path;
```

### SSH Private Keys

```bash
# Encrypt existing private key
agenix -e ssh-deploy-key.age
# Paste your private key, save and quit

# Deploy to user's .ssh directory
age.secrets.ssh-deploy-key = {
  file = ../secrets/ssh-deploy-key.age;
  path = "/home/atreyas/.ssh/deploy_key";
  owner = "atreyas";
  mode = "600";
};
```

### Environment Files

```bash
# Create env file with multiple secrets
agenix -e app-env.age
# Enter:
# DATABASE_URL=postgresql://...
# API_KEY=secret123
# Save and quit

# Use in services
systemd.services.myapp.serviceConfig.EnvironmentFile =
  config.age.secrets.app-env.path;
```

## Re-keying Secrets

If you add a new machine or user, update `secrets.nix` with the new public key, then re-encrypt all secrets:

```bash
cd ~/.nix/secrets
agenix -r
```

This will re-encrypt all secrets with the updated recipient list.

## Security Notes

- Secrets are encrypted in the repo (safe to commit)
- Private keys NEVER go into the Nix store
- Secrets are decrypted at boot into `/run/agenix/` (tmpfs)
- With impermanence, decrypted secrets are wiped on reboot
- Only the system and authorized users can decrypt

## Troubleshooting

### "no such identity" error

Make sure your SSH key is added to ssh-agent:
```bash
ssh-add ~/.ssh/id_ed25519
```

### Permission denied reading host key

You need sudo to read system host keys:
```bash
sudo cat /etc/ssh/ssh_host_ed25519_key.pub
```

### Secret not decrypting at boot

Check that:
1. The secret is listed in `system/secrets.nix`
2. The system's host key is in `secrets/secrets.nix`
3. You've rebuilt the system after making changes
