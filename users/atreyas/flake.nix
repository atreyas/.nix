{
  description = "atreyas Home Manager configuration";

  inputs = {
    # Specify the source of Home Manager and Nixpkgs.
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    mozilla = {
      url = "github:mozilla/nixpkgs-mozilla";
      flake = false;
    };
  };

  outputs = { nixpkgs, home-manager, ... } @ inputs:
    let
      system = "x86_64-linux";
      user = {
        name = "atreyas";
	email = "atreyas.gmail.com";
      };
      pkgs = import nixpkgs {
        inherit system;
        config.allowUnfree = true;
      };
      lib = nixpkgs.lib;
    in {
      homeConfigurations.${user.name} = home-manager.lib.homeManagerConfiguration {
        inherit pkgs;

        # Specify your home configuration modules here, for example,
        # the path to your home.nix.
        modules = [ . ];
        extraSpecialArgs = { inherit inputs system user; };

        # Optionally use extraSpecialArgs
        # to pass through arguments to home.nix
      };
    };
}
