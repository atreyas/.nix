{ config, pkgs, user, ... }:

{
  boot = {
    loader.systemd-boot.memtest86.enable = true;
    # LUKS for desktop machines
    initrd.luks.devices."root" = {
      device = "/dev/disk/by-label/NIX-ENC";
      allowDiscards = true;
    };
    supportedFilesystems = [ "btrfs" "ext4" ];
    kernelModules = [ "coretemp" "kvm-amd" ];
  };

  services.flatpak.enable = true;

  services = {
    xserver.enable = true;
    xserver.xkb.layout = "us";

    displayManager.gdm.enable = true;
    desktopManager.gnome.enable = true;

    fprintd.enable = true;
    printing.enable = true;

    pulseaudio.enable = false;
    pipewire = {
      enable = true;
      alsa = {
        enable = true;
        support32Bit = true;
      };
      pulse.enable = true;
      jack.enable = true;
    };
  };
  security.rtkit.enable = true;

  # Add desktop-specific groups
  users.users.${user.name}.extraGroups = [ "audio" "video" ];

  environment.systemPackages = with pkgs; [
    gparted
    perf
    config.boot.kernelPackages.tmon
  ];
}
