{ config, lib, pkgs, ... }:
{
  boot = {
    initrd.availableKernelModules = [ "xhci_pci" "thunderbolt" "nvme" "usb_storage" "usbhid" "sd_mod" ];
    kernelModules = [ "kvm-intel" ];
    kernelPackages = lib.mkForce pkgs.linuxPackages;
    initrd.luks.devices."root".device = "/dev/disk/by-uuid/9dbb05f9-fa9c-42b9-b660-004e2ffd9567";
  };

  hardware.cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;

  # SSH access for headless server
  services.openssh = {
    enable = true;
    settings = {
      PasswordAuthentication = false;
      PermitRootLogin = "no";
    };
  };
}
