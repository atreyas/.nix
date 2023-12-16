# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).

{ config, lib, pkgs, system, user, ... }:

{
  imports =
    [ 
      ./hardware-configuration.nix # Include the results of the hardware scan.
    ];

  # Use the systemd-boot EFI boot loader.
  boot.loader = {
    systemd-boot.enable = true;
    systemd-boot.memtest86.enable = true;
    systemd-boot.configurationLimit=10;
    efi.canTouchEfiVariables = true;
    timeout = 2;
  };
  boot = {
    supportedFilesystems = [ "btrfs" "ext4" ];

    # Upgrade kernel to latest
    kernelPackages = pkgs.linuxPackages_latest;
    kernelModules = [ "coretemp" "kvm-amd" ];
    extraModulePackages = [ ];
    # Use fq for BBR
    kernel.sysctl."net.core.default_qdisc" = "fq";
    kernel.sysctl."net.ipv4.tcp_congestion_control" = "bbr";
    # Use tmpfs for tmp. This is redundant with impermanence.
    tmp.useTmpfs = true;
  };

  zramSwap.enable = true;

  # Add ephemeral systemd logs
  systemd.coredump.enable = true;
  systemd.coredump.extraConfig = ''
    Storage=none
  '';

#  powerManagement.enable = true;
#  powerManagement.cpuFreqGovernor = "schedutil";
#  powerManagement.powertop.enable = false;
#  services.auto-cpufreq.enable = true;
#  services.thermald.enable = true;
  services.fwupd.enable = true;
  hardware.enableAllFirmware = true;

  networking.hostName = "r3-fw13-nix"; # Define your hostname.
  # Pick only one of the below networking options.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.
  networking.networkmanager.enable = true;  # Easiest to use and most distros use this by default.

  # Set your time zone.
  time.timeZone = "America/Los_Angeles";

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Select internationalisation properties.
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
  # console = {
  #   font = "Lat2-Terminus16";
  #   keyMap = "us";
  #   useXkbConfig = true; # use xkb.options in tty.
  # };

  # Enable the X11 windowing system.
  services.xserver.enable = true;

  # Enable the GNOME Desktop Environment.
  services.xserver.displayManager.gdm.enable = true;
  services.xserver.desktopManager.gnome.enable = true;
  
  services.fprintd = {
    enable = true;
  };

  # Configure keymap in X11
  services.xserver.xkb.layout = "us";

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable sound.
  # Use PipeWire instead of pulse/alsa
  #sound.enable = true;
  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # If you want to use JACK applications, uncomment this
    #jack.enable = true;
  };

  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;

  nixpkgs.config.allowUnfree = true;

  users.mutableUsers = false;
  # Define a user account.
  users.users.${user.name} = {
    isNormalUser = true;
    uid = 1000;
    initialHashedPassword = "$6$lT2E4HJwyBLkYSck$WLiug.IQ7fD3omg8X0XXSlF3AQwdd.rGl3i29Bp6UZxbtPl79x1rmo.fur2rx9F8sFUfFrnyN6K1YYvNPsv16/";
    hashedPasswordFile = "/etc/hashed-passwords/${user.name}"; # Generate this with your password
    extraGroups = [ "wheel" "networkmanager" "audio" "video" ]; # wheel = ‘sudo’ for the user.
    shell = pkgs.zsh;
  };
  users.defaultUserShell = pkgs.zsh;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.shells = [ pkgs.bashInteractive pkgs.zsh ];
  environment.systemPackages = with pkgs; [
    vim
    wget
    lsof
    usbutils
    git
    lshw
    hwinfo
  ];

  programs = {
    vim.defaultEditor = true;
    zsh.enable = true;
    mosh.enable = true;
  };

  nix = {
    package = pkgs.nixFlakes;
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

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;
  services.journald.extraConfig = ''
    Storage=volatile
    RuntimeMaxUse=64M
  '';

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  networking.firewall.enable = false;

  # Copy the NixOS configuration file and link it from the resulting system
  # (/run/current-system/configuration.nix). This is useful in case you
  # accidentally delete configuration.nix.
  # system.copySystemConfiguration = true;

  # This option defines the first version of NixOS you have installed on this particular machine,
  # and is used to maintain compatibility with application data (e.g. databases) created on older NixOS versions.
  #
  # Most users should NEVER change this value after the initial install, for any reason,
  # even if you've upgraded your system to a new NixOS release.
  #
  # This value does NOT affect the Nixpkgs version your packages and OS are pulled from,
  # so changing it will NOT upgrade your system.
  #
  # This value being lower than the current NixOS release does NOT mean your system is
  # out of date, out of support, or vulnerable.
  #
  # Do NOT change this value unless you have manually inspected all the changes it would make to your configuration,
  # and migrated your data accordingly.
  #
  # For more information, see `man configuration.nix` or https://nixos.org/manual/nixos/stable/options#opt-system.stateVersion .
  system.stateVersion = "23.11"; # Did you read the comment?

}

