# SPDX-License-Identifier: MIT

{ lib, inputs, nixpkgs, home-manager, user, nixos-hardware, sops-nix, alejandra, ... }:

let
  system = "x86_64-linux"; # system architecture

  pkgs = import nixpkgs {
    inherit system;
    config.allowUnfree = true;
  };

  lib = nixpkgs.lib;
in
{
  arcadia = lib.nixosSystem
    {
      inherit system;
      specialArgs = { inherit inputs user; };
      modules = [
        ./arcadia
        ./configuration.nix
        sops-nix.nixosModules.sops

        {
          environment.systemPackages = [ alejandra.defaultPackage.${system} ];
        }

        home-manager.nixosModules.home-manager
        {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          home-manager.extraSpecialArgs = { inherit user; };
          home-manager.users.${user} = {
            programs.bash.enable = true;
            imports = [ (import ./home.nix) ] ++ [ (import ./arcadia/home.nix) ];
          };
        }
      ];
    };

  hades = lib.nixosSystem
    {
      inherit system;
      specialArgs = { inherit inputs user; };
      modules = [
        ./hades
        ./configuration.nix

        {
          environment.systemPackages = [ alejandra.defaultPackage.${system} ];
        }

        home-manager.nixosModules.home-manager
        {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          home-manager.extraSpecialArgs = { inherit user; };
          home-manager.users.${user} = {
            programs.bash.enable = true;
            imports = [ (import ./home.nix) ] ++ [ (import ./hades/home.nix) ];
          };
        }
      ];
    };

  minerva = lib.nixosSystem
    {
      inherit system;
      specialArgs = { inherit inputs user; };
      modules = [
        ./minerva
        ./configuration.nix
        # TODO move this to common
        sops-nix.nixosModules.sops

        # add your model from this list: https://github.com/NixOS/nixos-hardware/blob/master/flake.nix
        nixos-hardware.nixosModules.lenovo-thinkpad-x1-9th-gen

        {
          environment.systemPackages = [ alejandra.defaultPackage.${system} ];
        }

        home-manager.nixosModules.home-manager
        {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          home-manager.extraSpecialArgs = { inherit user; };
          home-manager.users.${user} = {
            programs.bash.enable = true;
            imports = [ (import ./home.nix) ] ++ [ (import ./minerva/home.nix) ];
          };
        }
      ];
    };
}
