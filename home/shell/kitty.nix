{pkgs, ...}: {
  programs = {
    kitty = {
      enable = true;
      font = {
        package = pkgs.fira-code;
        name = "FiraCode";
      };
      shellIntegration.enableBashIntegration = true;
      theme = "Dracula";
      settings = {
        enable_audio_bell = false;
        enabled_layouts = "grid,stack,horizontal,tall";
      };
      extraConfig = "
          map ctrl+alt+g goto_layout grid
          map ctrl+alt+x goto_layout stack
";
    };
  };
}
