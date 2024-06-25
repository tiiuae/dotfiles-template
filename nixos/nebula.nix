{
  config,
  lib,
  pkgs,
  ...
}: {
  environment.systemPackages = [pkgs.nebula];
}
