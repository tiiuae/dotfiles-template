{ config, lib, pkgs, ... }:

{
  services.emacs.enable = true;
  services.emacs.package = with pkgs;
    ((emacsPackagesFor emacs).emacsWithPackages
      (epkgs: [ epkgs.vterm epkgs.pdf-tools ]));

  # TODO can the XDG_CONFIG be generalised higher up?
  environment.sessionVariables = rec {
    EDITOR = "emacs";
    XDG_CONFIG_HOME = "\${HOME}/.config";
    PATH = "$PATH:$XDG_CONFIG_HOME/emacs/bin";
  };

  fonts.fonts = [ pkgs.emacs-all-the-icons-fonts ];

  environment.systemPackages = with pkgs; [
    ((emacsPackagesFor emacs).emacsWithPackages
      (epkgs: [ epkgs.vterm epkgs.pdf-tools ]))

    # TODO Use some secrets managment tool to lock sensitive conf files.
    gnutls # for TLS connectivity

    imagemagick # for image-dired
    zstd # for undo-fu-session/undo-tree compression

    ## Module dependencies
    # :checkers spell
    (aspellWithDicts (ds: with ds; [ en en-computers en-science ]))

    # :tools editorconfig
    editorconfig-core-c # per-project style config

    # :tools lookup & :lang org +roam
    sqlite

    # :lang latex & :lang org (latex previews)
    texlive.combined.scheme-medium

    # :lang org & :org-roam2
    graphviz
    gnuplot

  ]; # Dependencies

  system.userActivationScripts = {
    installDoomEmacs = ''
      source ${config.system.build.setEnvironment}
      if [ ! -d "$XDG_CONFIG_HOME/emacs" ]; then
        git clone https://github.com/doomemacs/doomemacs.git "$XDG_CONFIG_HOME/emacs"
        git clone https://github.com/brianmcgillion/doomd.git "$XDG_CONFIG_HOME/doom"
      fi
    '';
  };

}
