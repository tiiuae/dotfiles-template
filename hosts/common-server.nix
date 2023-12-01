# SPDX-License-Identifier: Apache-2.0
{
  pkgs,
  self,
  inputs,
  ...
}: {
  imports = [
    ./common.nix
    self.nixosModules.user-root
    inputs.disko.nixosModules.disko
  ];

  environment.systemPackages = [
    #Tmux with a nice wrapper
    pkgs.byobu
  ];

  services.openssh.enable = true;
}
