{ config, hostname, lib, pkgs, system, user, ... }:

{
  imports =
    [
      ./hardware-configuration.nix
    ];

  boot = {
    loader = {
      systemd-boot.enable = true;
      systemd-boot.configurationLimit = 20;
      efi.canTouchEfiVariables = true;
      timeout = 2;
    };
    kernelPackages = pkgs.linuxPackages_latest;
    extraModulePackages = [ ];
    # BBR congestion control
    kernel.sysctl."net.core.default_qdisc" = "fq";
    kernel.sysctl."net.ipv4.tcp_congestion_control" = "bbr";
    tmp.useTmpfs = true;
  };

  zramSwap.enable = true;

  systemd.coredump.enable = true;
  systemd.coredump.extraConfig = ''
    Storage=none
  '';

  services.fwupd.enable = true;
  hardware.enableAllFirmware = true;

  networking.hostName = "${hostname}";
  networking.networkmanager.enable = true;

  time.timeZone = "America/Los_Angeles";

  i18n.defaultLocale = "en_US.UTF-8";
  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_US.UTF-8";
    LC_IDENTIFICATION = "en_US.UTF-8";
    LC_MEASUREMENT = "en_US.UTF-8";
    LC_MONETARY = "en_US.UTF-8";
    LC_NAME = "en_US.UTF-8";
    LC_NUMERIC = "en_US.UTF-8";
    LC_PAPER = "en_US.UTF-8";
    LC_TELEPHONE = "en_US.UTF-8";
    LC_TIME = "en_US.UTF-8";
  };

  nixpkgs.config.allowUnfree = true;

  users.mutableUsers = false;
  users.users.${user.name} = {
    isNormalUser = true;
    uid = 1000;
    initialHashedPassword = lib.mkDefault "$6$lT2E4HJwyBLkYSck$WLiug.IQ7fD3omg8X0XXSlF3AQwdd.rGl3i29Bp6UZxbtPl79x1rmo.fur2rx9F8sFUfFrnyN6K1YYvNPsv16/";
    hashedPasswordFile = "/etc/hashed-passwords/${user.name}";
    extraGroups = [ "wheel" "networkmanager" ];
    shell = pkgs.zsh;
  };
  users.defaultUserShell = pkgs.zsh;

  environment.shells = [ pkgs.bashInteractive pkgs.zsh ];
  environment.systemPackages = with pkgs; [
    git
    vim
    wget
    lsof
    pciutils
    usbutils
    lshw
    hwinfo
    comma
  ];

  programs = {
    vim.defaultEditor = true;
    vim.enable = true;
    zsh.enable = true;
    mosh.enable = true;
  };

  nix = {
    package = pkgs.nixVersions.latest;
    optimise.automatic = true;
    settings = {
      experimental-features = [ "nix-command" "flakes" ];
      auto-optimise-store = true;
    };
    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 30d";
    };
  };

  services.openssh = {
    enable = false;
    startWhenNeeded = false;
  };
  systemd.services.sshd.wantedBy = lib.mkForce [];

  services.journald.extraConfig = ''
    Storage=volatile
    RuntimeMaxUse=64M
  '';

  networking.firewall.enable = false;

  system.stateVersion = "23.11";
}
