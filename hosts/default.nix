# SPDX-License-Identifier: Apache-2.0
{
  inputs,
  self,
  lib,
  ...
}: {
  flake.nixosModules = {
    # shared modules
    common = import ./common.nix;

    # host modules
    host-arcadia = import ./arcadia;
    host-minerva = import ./minerva;
    #host-hades = import ./hades;
  };

  flake.nixosConfigurations = let
    # make self and inputs available in nixos modules
    specialArgs = {inherit self inputs;};
  in {
    arcadia = lib.nixosSystem {
      inherit specialArgs;
      modules = [self.nixosModules.host-arcadia];
    };

    minerva = lib.nixosSystem {
      inherit specialArgs;
      modules = [self.nixosModules.host-minerva];
    };

    # hades = lib.nixosSystem {
    #   inherit specialArgs;
    #   modules = [self.nixosModules.host-hades];
    # };
  };
}
