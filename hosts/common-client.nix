# SPDX-License-Identifier: MIT
{
  self,
  inputs,
  lib,
  config,
  ...
}: {
  imports = lib.flatten [
    (with self.nixosModules; [
      audio
      desktop-manager
      emacs-ui
      libreoffice
      locale-font
      yubikey
    ])
    [
      ./common.nix
    ]
  ];

  config = {
    setup.device.isClient = true;

    # Bootloader, seems server is MBR in most cases.
    boot = {
      loader.systemd-boot.enable = true;
      loader.systemd-boot.configurationLimit = 5;
      loader.efi.canTouchEfiVariables = true;
      loader.efi.efiSysMountPoint = "/boot/efi";
    };

    # Common network configuration
    # The global useDHCP flag is deprecated, therefore explicitly set to false
    # here. Per-interface useDHCP will be mandatory in the future, so this
    # generated config replicates the default behaviour.
    networking = {
      networkmanager.enable = true;
      #Open ports in the firewall?
      firewall = {
        allowedTCPPorts = [];
        allowedUDPPorts = [];
      };
    };

    #By default the client devices to not provide inbound ssh
    services.openssh.startWhenNeeded = false;
  };
}
