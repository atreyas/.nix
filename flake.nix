{
  description = "R3's NIX system config";

  inputs = {
    # Nix Packages
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    # Community maintained common hardware config
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";
    # Flake-parts
    flake-parts.url = "github:hercules-ci/flake-parts";
    # Home Manager
    home-manager = {
      url = "github:nix-community/home-manager/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    # Impermanence
    impermanence.url = "github:nix-community/impermanence/master"; 
  };

  outputs = {
    self,
    nixpkgs,
    nixos-hardware,
    flake-parts,
    home-manager,
    impermanence } @ inputs:
  let
    system = "x86_64-linux";
    user = "atreyas"; # Maybe more later
    pkgs = import nixpkgs {
      inherit system;
      config = { allowUnfree = true; };
    };
    # Overlays can go here
    lib = nixpkgs.lib;

  in {
    nixosConfigurations = {
      "r3-fw13-nix" = lib.nixosSystem {
        inherit system;

        modules = [
	  nixos-hardware.nixosModules.framework-13-7040-amd
          ./system/configuration.nix
          impermanence.nixosModules.impermanence
          ./system/impermanence.nix
	  home-manager.nixosModules.home-manager
	  { # This is separate from the above
	    home-manager = {
              useGlobalPkgs = true;
	      useUserPackages = true;
	      users = {
                ${user} = ./users/${user};
	      };
	    };
	  }
        ];
	specialArgs = { inherit inputs system user; };
      };
    };
  };
}
