{ config, lib, pkgs, ... }:

{
  home.packages = with pkgs; [
    minicom
    usbutils
  ];

}
