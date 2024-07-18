# SPDX-License-Identifier: Apache-2.0
{
  flake.nixosModules = {
    user-<CHANGE_ME> = import ./bmg.nix;
    user-groups = import ./groups.nix;
    user-root = import ./root.nix;
  };
}
