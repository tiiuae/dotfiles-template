# SPDX-License-Identifier: Apache-2.0
{
  pkgs,
  self,
  inputs,
  config,
  ...
}: {
  imports = [
    ./common.nix
    self.nixosModules.user-root
    inputs.disko.nixosModules.disko
  ];

  config = {
    setup.device.isServer = true;

    environment.systemPackages = [
      #Tmux with a nice wrapper
      pkgs.byobu
      pkgs.tmux
    ];

    services.openssh.enable = true;
  };
}
