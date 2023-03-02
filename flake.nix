# SPDX-License-Identifier: MIT

{
  description = "First honest attempt to declare a system";

  inputs = {
    # Nix Packages, following unstable (rolling release)
    nixpkgs.url = "nixpkgs/nixos-unstable"; # primary nixpkgs
    #    nixpkgs-unstable.url = "nixpkgs/nixpkgs-unstable";  # for packages on the edge

    # dotfiles-esque package management
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Track more recent emacs additions e.g. native compiled
    #emacs-overlay.url = "github:nix-community/emacs-overlay";
    nixos-hardware.url = "github:nixos/nixos-hardware";

    # for provisioning secrets that can be embedded in the configuration
    sops-nix = {
      url = github:Mic92/sops-nix;
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.nixpkgs-stable.follows = "nixpkgs";
    };

    # TODO add nixos-generators
  };

  outputs = inputs@{ self, home-manager, nixpkgs, nixos-hardware, sops-nix, ... }:
    let
      user = "brian";
      system = "x86_64-linux";
      pkgs = import <nixpkgs> { };
    in
    {
      nixosConfigurations = (
        # for NixOS based system
        import ./hosts {
          # imports ./hosts/default.nix
          inherit (nixpkgs) lib;
          inherit inputs nixpkgs home-manager user nixos-hardware sops-nix;
        }
      );

      devShell."${system}" = import ./shell.nix { inherit pkgs; };
    };
}
