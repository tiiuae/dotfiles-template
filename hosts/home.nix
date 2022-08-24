{ config, lib, pkgs, user, ... }:

{
  imports = (import ../modules/shell) ++ (import ../modules/apps)
    ++ (import ../modules/browsers) ++ (import ../modules/development)
    ++ (import ../modules/editors);

  home = {
    username = "${user}";
    homeDirectory = "/home/${user}";

    stateVersion = "22.11";
  };

  programs = { home-manager.enable = true; };
}
