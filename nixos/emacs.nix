{
  config,
  lib,
  pkgs,
  ...
}:
with lib; {
  services.emacs.enable = false;
  services.emacs.package = with pkgs; ((emacsPackagesFor emacs29-pgtk).emacsWithPackages
    (epkgs: [epkgs.vterm epkgs.pdf-tools epkgs.org-pdftools]));

  #TODO Remove rec not needed here
  environment.sessionVariables = rec {
    EDITOR = "emacs";
    PATH = ["$XDG_CONFIG_HOME/emacs/bin"];
  };

  #fonts.packages = [pkgs.emacs-all-the-icons-fonts];

  # :grammar support through language tool
  services.languagetool.enable = true;

  environment.systemPackages = with pkgs; [
    ((emacsPackagesFor emacs29-pgtk).emacsWithPackages
      (epkgs:
        with epkgs; [
          vterm
          pdf-tools
          org-pdftools
          treesit-grammars.with-all-grammars
        ]))

    #native-comp emacs needs 'as' binary from binutils
    binutils

    zstd # for undo-fu-session/undo-tree compression

    ## Module dependencies
    # :checkers spell
    (aspellWithDicts (ds: with ds; [en en-computers en-science]))
    # :lookup
    wordnet

    # :tools editorconfig
    editorconfig-core-c # per-project style config

    # :tools lookup & :lang org +roam
    sqlite

    # :formating
    dockfmt
    libxml2
    tree-sitter

    # :lang markdown
    python3.pkgs.grip
  ];

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
