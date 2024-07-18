{...}: {
  imports = [
    ./apps
    ./browsers
    ./development
    ./security
    ./shell
  ];

  home = {
    username = "<CHANGE_ME"; #config.users.users.brian.name;
    homeDirectory = "/home/<CHANGE_ME>"; #config.users.users.brian.home;
    stateVersion = "24.05";
  };

  ### A tidy $HOME is a tidy mind
  xdg.enable = true;

  programs = {
    home-manager.enable = true;
  };
}
