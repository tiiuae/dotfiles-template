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
    self.nixosModules.fail2ban
    inputs.disko.nixosModules.disko
  ];

  config = {
    setup.device.isServer = true;

    environment.systemPackages = [
    ];

    services.openssh = {
      enable = true;
      settings = {
        PasswordAuthentication = false;
      };
    };
  };
}
