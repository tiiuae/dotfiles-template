{ pkgs, ... }:

{
  
  home = {                                # Specific packages for desktop
    packages = with pkgs; [
      # Applications
      libreoffice       # Office Packages
    ];
  };

}