# Setting Up Nix Config on Ubuntu

This guide will help you set up your Nix configuration on an Ubuntu laptop using standalone home-manager.

## Step 1: Install Nix

On your Ubuntu laptop, run:

```bash
# Install Nix (multi-user installation recommended)
sh <(curl -L https://nixos.org/nix/install) --daemon

# After installation, restart your shell or source the profile
. /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh
```

## Step 2: Enable Flakes

Configure Nix to enable flakes and the nix command:

```bash
mkdir -p ~/.config/nix
cat > ~/.config/nix/nix.conf << EOF
experimental-features = nix-command flakes
EOF
```

## Step 3: Clone Your Nix Config

```bash
# Clone your nix configuration to the same location
git clone <your-repo-url> ~/.nix
cd ~/.nix
```

## Step 4: Install Home Manager

```bash
# Install home-manager using your flake
nix run home-manager/master -- init --switch --flake ~/.nix#atreyas@ubuntu
```

Or if you already have the flake set up:

```bash
nix run home-manager/master -- switch --flake ~/.nix#atreyas@ubuntu
```

## Step 5: Set Up Shell Integration

Add this to your `~/.bashrc` or `~/.zshrc`:

```bash
# Source home-manager session variables
. ~/.nix-profile/etc/profile.d/hm-session-vars.sh
```

## Updating Your Configuration

After making changes to your config:

```bash
cd ~/.nix
home-manager switch --flake .#atreyas@ubuntu
```

## Syncing Between Machines

To sync your configuration between your NixOS machines and Ubuntu laptop:

1. Commit and push changes from any machine:
   ```bash
   cd ~/.nix
   git add .
   git commit -m "Update configuration"
   git push
   ```

2. Pull and apply on other machines:
   ```bash
   cd ~/.nix
   git pull
   # On NixOS:
   sudo nixos-rebuild switch --flake .#r3-fw13-nix
   # On Ubuntu:
   home-manager switch --flake .#atreyas@ubuntu
   ```

## Ubuntu-Specific Customization

If you need Ubuntu-specific settings, edit the `homeConfigurations."${user.name}@ubuntu"` section in `flake.nix`.

For example, to disable certain apps or features on Ubuntu:

```nix
homeConfigurations = {
  "${user.name}@ubuntu" = home-manager.lib.homeManagerConfiguration {
    inherit pkgs;
    modules = [
      ./users/${user.name}
      {
        # Ubuntu overrides
        programs.some-nixos-only-program.enable = false;
        # Add Ubuntu-specific packages
        home.packages = with pkgs; [
          # Ubuntu-specific tools
        ];
      }
    ];
    extraSpecialArgs = { inherit inputs system user; };
  };
};
```

## Troubleshooting

### "error: experimental Nix feature 'nix-command' is disabled"
Make sure you've created `~/.config/nix/nix.conf` with the experimental features enabled.

### "error: getting status of '/nix/var/nix/profiles/per-user/atreyas/home-manager'"
Run the home-manager init command first (see Step 4).

### Programs not in PATH
Make sure you've sourced the hm-session-vars.sh file in your shell rc file.

## Notes

- Your agenix secrets won't work on Ubuntu (they're NixOS-specific)
- System-level services won't work (use systemd user services via home-manager instead)
- Some NixOS-specific modules may need to be conditionally disabled
