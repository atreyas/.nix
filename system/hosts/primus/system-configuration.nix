{ config, pkgs, ... }:

{
  boot.initrd = {
    availableKernelModules = [ "nvme" "thunderbolt" "xhci_pci" "ahci" "usbhid" "usb_storage" "sd_mod" ];
  };

  # NVIDIA drivers
  services.xserver.videoDrivers = [ "nvidia" ];

  hardware.nvidia = {
    modesetting.enable = true;
    powerManagement.enable = false;
    open = false; # Use proprietary drivers (better CUDA support)
    nvidiaSettings = true;
    package = config.boot.kernelPackages.nvidiaPackages.stable;
  };

  hardware.graphics = {
    enable = true;
    enable32Bit = true;
  };

  # Ollama - local LLM runner with CUDA acceleration
  services.ollama = {
    enable = true;
    package = pkgs.ollama-cuda;
  };

  # vLLM - high-throughput OpenAI-compatible inference server
  environment.systemPackages = with pkgs; [
    python313Packages.vllm
  ];
}
