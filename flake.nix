# SPDX-License-Identifier: MIT

{
  description = "First honest attempt to declare a system";

  inputs = {
    # Nix Packages, following unstable (rolling release)
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    # dotfiles-esque package management
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Track more recent emacs additions e.g. native compiled
    #emacs-overlay.url = "github:nix-community/emacs-overlay";
    nixos-hardware.url = "github:nixos/nixos-hardware";
  };

  outputs = inputs@{ self, home-manager, nixpkgs, nixos-hardware, ... }:
    let user = "brian";
    in {
      nixosConfigurations = ( # for NixOS based systems
        import ./hosts { # imports ./hosts/default.nix
          inherit (nixpkgs) lib;
          inherit inputs nixpkgs home-manager user nixos-hardware;
        });
    };
}
