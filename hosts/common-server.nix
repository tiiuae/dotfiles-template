# SPDX-License-Identifier: Apache-2.0
{
  self,
  inputs,
  lib,
  config,
  pkgs,
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
      pkgs.kitty.terminfo
    ];

    services.openssh = {
      enable = true;
      settings = {
        #PermitRootLogin = lib.mkForce "no";
        PasswordAuthentication = false;
        KbdInteractiveAuthentication = false;
        ClientAliveInterval = lib.mkDefault 60;
        LogLevel = "VERBOSE"; #needed for fail2ban
      };
      hostKeys = [
        {
          path = "/etc/ssh/ssh_host_ed25519_key";
          type = "ed25519";
        }
      ];
    };
  };
}
