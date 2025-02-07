{
  description = "R3's NIX system config";

  inputs = {
    # Nix Packages
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    # Primarily for 1password
    nixpkgs-unfree.url = "github:numtide/nixpkgs-unfree";
    # Community maintained common hardware config
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";
    # Flake-parts
    flake-parts.url = "github:hercules-ci/flake-parts";
    # Home Manager
    home-manager = {
      url = "github:nix-community/home-manager/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    # Nix-Doom-Emacs fix pending upstream pull for supporting emacs > 28
    # nix-straight = {
    #   url = "github:codingkoi/nix-straight.el?ref=codingkoi/apply-librephoenixs-fix";
    #   flake = false;
    # };
    # doom-emacs = {
    #   url = "github:nix-community/nix-doom-emacs";
    #   inputs.nix-straight.follows = "nix-straight";
    # };
    # Impermanence
    impermanence.url = "github:nix-community/impermanence/master"; 
    # Stylix theming
    stylix.url = "github:danth/stylix";
    # Mozilla/Firefox
    mozilla-pkgs = {
      url = "github:mozilla/nixpkgs-mozilla";
      flake = false;
    };
    firefox-addons = {
      url = "gitlab:rycee/nur-expressions?dir=pkgs/firefox-addons";
      inputs.nixpkgs.follows = "nixpkgs-unfree";
    };
    rippkgs = {
      url = "github:replit/rippkgs";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.flake-parts.follows = "flake-parts";
    };
  };

  outputs = {
    self,
    nixpkgs,
    nixos-hardware,
    flake-parts,
    home-manager,
    impermanence,
    ...
  } @ inputs:
  let
    system = "x86_64-linux";
    pkgs = import nixpkgs {
      inherit system ;
      config = {
        allowUnfree = true;
        permittedInsecurePackages = [
          "electron-25.9.0"
        ];
      };
    };
    # Overlays can go here
    lib = nixpkgs.lib;
    user = rec {
      name = "atreyas";
      email = name + "@gmail.com";
    };
    defaultModules = [
      ./system/configuration.nix
      impermanence.nixosModules.impermanence
      ./system/impermanence.nix
      home-manager.nixosModules.home-manager
      { # This is separate from the above
        home-manager = {
          useGlobalPkgs = true;
          useUserPackages = true;
          users = {
            ${user.name} = ./users/${user.name};
          };
          extraSpecialArgs = { inherit inputs system user; };
          backupFileExtension = "hm-backup";
        };
      }
    ];
  in {
    nixosConfigurations = {
      "r3-fw13-nix" =
      let
        hostname = "r3-fw13-nix";
      in lib.nixosSystem {
        inherit system;

        modules = [
          #nixos-hardware.nixosModules.framework-13-7040-amd
          ./system/hosts/r3-fw13-nix/system-configuration.nix
        ] ++ defaultModules;
        specialArgs = { inherit inputs hostname system user; };
      };
      "primus" =
      let
        hostname = "primus";
      in lib.nixosSystem {
        inherit system;

        modules = [
          ./system/hosts/primus/system-configuration.nix
        ] ++ defaultModules;
        specialArgs = { inherit inputs hostname system user; };
      };
    };
  };
}
