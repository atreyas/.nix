# Quick Start Guide

## Step 1: Initial Setup

Run the setup script to configure your SSH keys:

```bash
cd ~/.nix/secrets
./setup.sh
```

This will:
- Generate an SSH key if you don't have one
- Get your system's host key
- Update `secrets.nix` with both keys

## Step 2: Update Flake and Rebuild

```bash
cd ~/.nix
nix flake update
sudo nixos-rebuild switch --flake .
```

## Step 3: Create Your First Secret

Let's create a user password as an example:

```bash
cd ~/.nix/secrets

# First, uncomment "user-password.age" in secrets.nix
# Then create the secret:
agenix -e user-password.age
```

In the editor that opens, paste your password hash:
```bash
# Generate the hash first:
mkpasswd -m sha-512
# Enter your password when prompted
# Copy the output hash and paste it in the agenix editor
```

## Step 4: Use the Secret

Edit `~/.nix/system/secrets.nix`:

```nix
age.secrets.user-password = {
  file = ../secrets/user-password.age;
  mode = "600";
};
```

Edit `~/.nix/system/configuration.nix` to replace line 135:

```nix
# Replace:
hashedPasswordFile = "/etc/hashed-passwords/${user.name}";

# With:
hashedPasswordFile = config.age.secrets.user-password.path;
```

## Step 5: Rebuild Again

```bash
sudo nixos-rebuild switch --flake ~/.nix
```

Done! Your password is now managed by agenix.

## Common Secrets to Set Up

### GitHub Token

```bash
# 1. Add to secrets/secrets.nix:
"github-token.age".publicKeys = allKeys;

# 2. Create the secret:
agenix -e github-token.age
# Paste your GitHub token

# 3. Add to system/secrets.nix:
age.secrets.github-token = {
  file = ../secrets/github-token.age;
  owner = user.name;
};

# 4. Use in git config (home-manager):
programs.git.extraConfig.github.token =
  builtins.readFile config.age.secrets.github-token.path;
```

### Environment Variables

```bash
# 1. Add to secrets/secrets.nix:
"app-env.age".publicKeys = allKeys;

# 2. Create the secret:
agenix -e app-env.age
# Enter your env vars:
# API_KEY=secret123
# DATABASE_URL=postgresql://...

# 3. Add to system/secrets.nix:
age.secrets.app-env = {
  file = ../secrets/app-env.age;
  owner = user.name;
};

# 4. Use in systemd service:
systemd.services.myapp.serviceConfig.EnvironmentFile =
  config.age.secrets.app-env.path;
```

## Tips

- Secrets are stored encrypted in git (safe to commit)
- Decrypted secrets live in `/run/agenix/` (tmpfs)
- With impermanence, secrets are wiped on reboot
- Re-run `agenix -r` to re-encrypt all secrets after adding new keys

See README.md for complete documentation.
