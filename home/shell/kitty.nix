{
  config,
  lib,
  pkgs,
  ...
}: {
  programs = {
    kitty = {
      enable = true;
      font = {
        package = pkgs.fira-code;
        name = "FiraCode";
      };
      shellIntegration.enableBashIntegration = true;
      theme = "Dracula";
    };
  };
}
