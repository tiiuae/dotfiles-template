{ config, lib, pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    yubikey-manager
    age-plugin-yubikey
    yubikey-touch-detector
  ];

  services.pcscd.enable = true;
  services.udev.packages = with pkgs; [ yubikey-manager ];
}
