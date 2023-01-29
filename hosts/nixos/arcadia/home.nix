{ pkgs, ... }:

{
  home = {
    # Specific packages for arcadia
    packages = with pkgs;
      [
        # Applications
        #        libreoffice # Office Packages
      ];
  };

}
