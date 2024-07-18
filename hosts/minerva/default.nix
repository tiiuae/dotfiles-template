# SPDX-License-Identifier: MIT
{
  self,
  lib,
  inputs,
  ...
}: {
  #Set the baseline with common.nix
  # <CHANGE_ME> which nixos-hardware
  imports = [self.nixosModules.common-client self.nixosModules.sshd inputs.nixos-hardware.nixosModules.lenovo-thinkpad-x1-9th-gen];

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";

  # Origionally in hardware-configuration.nix
  boot = {
    initrd.availableKernelModules = ["xhci_pci" "nvme" "usb_storage" "sd_mod" "sdhci_pci"];
    initrd.kernelModules = [];
    kernelModules = ["kvm-intel"];
    extraModulePackages = [];
    # Setup keyfile
    # <CHANGE_ME> This is the keyfile for the encrypted disk and the DISK ID
    initrd.secrets = {"/crypto_keyfile.bin" = null;};
    initrd.luks.devices."luks-beb21201-376c-48a7-bd8f-d1fe91210548".device = "/dev/disk/by-uuid/beb21201-376c-48a7-bd8f-d1fe91210548";
  };

  # <CHANGE_ME> The disk names
  fileSystems."/" = {
    device = "/dev/disk/by-uuid/f9a590f0-3553-4e57-a477-91d291999797";
    fsType = "ext4";
  };

  fileSystems."/boot/efi" = {
    device = "/dev/disk/by-uuid/C0B0-A8A8";
    fsType = "vfat";
    options = ["umask=0077" "defaults"];
  };

  swapDevices = [];

  #  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  powerManagement = {
    enable = true;
    cpuFreqGovernor = lib.mkDefault "conservative";
  };

  hardware.cpu.intel.updateMicrocode = true;

  # The global useDHCP flag is deprecated, therefore explicitly set to false
  # here. Per-interface useDHCP will be mandatory in the future, so this
  # generated config replicates the default behaviour.
  networking.interfaces.wlp0s20f3.useDHCP = true;

  #TODO Replace this with the name of the nixosConfiguration so it can be common
  # Define your hostname
  networking.hostName = "<CHANGE_ME>";

  # Configure keymap in X11
  services.xserver.xkb = {
    #options = "ctrl:swapcaps";
    #gsettings set org.gnome.desktop.input-sources xkb-options "['ctrl:swapcaps']"
    #gsettings reset org.gnome.desktop.input-sources xkb-options
    #gsettings reset org.gnome.desktop.input-sources sources
    #localectl
  };

  console.useXkbConfig = true;

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  system.stateVersion = "24.05";
}
