# SPDX-License-Identifier: Apache-2.0
{
  inputs,
  self,
  lib,
  ...
}: {
  flake.nixosModules = {
    # shared modules
    common-client = import ./common-client.nix;
    common-server = import ./common-server.nix;

    # host modules
    host-minerva = import ./minerva {inherit self inputs lib;};
  };

  flake.nixosConfigurations = let
    # make self and inputs available in nixos modules
    specialArgs = {inherit self inputs;};
  in {
    minerva = lib.nixosSystem {
      inherit specialArgs;
      modules = [self.nixosModules.host-minerva];
    };
  };
}
