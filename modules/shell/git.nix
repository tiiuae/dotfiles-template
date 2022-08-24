{ config, lib, pkgs, ... }:

{
  # TODO add conf file and settings
  #
  programs = {
    git = {
      enable = true;
      userName = "Brian McGillion";
      userEmail = "bmg.avoin@gmail.com";
      delta.enable = true; # see diff in a new light
      ignores = [ "*~" "*.swp" ];
    };
  };
}
