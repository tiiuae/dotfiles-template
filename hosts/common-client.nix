# SPDX-License-Identifier: MIT
{
  self,
  inputs,
  lib,
  ...
}: {
  imports = lib.flatten [
    (with self.nixosModules; [
      audio
      desktop-manager
      emacs
      libreoffice
      locale-font
      yubikey
    ])
    [
      inputs.home-manager.nixosModules.home-manager
      {
        home-manager.useGlobalPkgs = true;
        home-manager.useUserPackages = true;
        home-manager.extraSpecialArgs = {inherit inputs;};
        home-manager.users.brian = {
          imports = [(import ../home/home.nix)];
        };
      }
    ]
    [
      ./common.nix
    ]
  ];

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
}
