{ config, lib, pkgs, ... }:

{
  home.packages = with pkgs; [ slack element-desktop ];
}
