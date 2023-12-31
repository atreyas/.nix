# Do not modify this file!  It was generated by ‘nixos-generate-config’
# and may be overwritten by future invocations.  Please make changes
# to /etc/nixos/configuration.nix instead.
{ config, lib, pkgs, system, modulesPath, ... }:

{
  imports =
    [ (modulesPath + "/installer/scan/not-detected.nix")
    ];

  fileSystems =
  let
    btrfsOptions = [ "defaults" "compress-force=zstd" "noatime" "ssd" ];
  in {
    "/" = {
      device = "none";
      fsType = "tmpfs";
      options = [ "defaults" "mode=755" ];
      neededForBoot = true;
    };

    "/boot" = {
      device = "/dev/disk/by-label/BOOT";
      fsType = "vfat";
      options = [ "defaults" "umask=0077" ];
    };

    "/persist" = {
      device = "/dev/disk/by-label/NIX";
      fsType = "btrfs";
      options = btrfsOptions ++ [ "subvol=persist" ];
      neededForBoot = true;
    };

    "/nix" = {
      device = "/dev/disk/by-label/NIX";
      fsType = "btrfs";
      options = btrfsOptions ++ [ "subvol=nix" ];
      neededForBoot = true;
    };

    "/home" = {
      device = "/dev/disk/by-label/NIX";
      fsType = "btrfs";
      options = btrfsOptions ++ [ "subvol=home" ];
    };
  };

  swapDevices = [ ];

  # Enables DHCP on each ethernet and wireless interface. In case of scripted networking
  # (the default) this is the recommended approach. When using systemd-networkd it's
  # still possible to use this option, but it's recommended to use it in conjunction
  # with explicit per-interface declarations with `networking.interfaces.<interface>.useDHCP`.
  networking.useDHCP = lib.mkDefault true;
  # networking.interfaces.eno1.useDHCP = lib.mkDefault true;
  # networking.interfaces.eno2.useDHCP = lib.mkDefault true;
  # networking.interfaces.wlp7s0.useDHCP = lib.mkDefault true;

  nixpkgs.hostPlatform = lib.mkDefault "${system}";
  hardware.cpu.amd.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
}
