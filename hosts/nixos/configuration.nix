# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).
{
  config,
  lib,
  pkgs,
  inputs,
  user,
  ...
}: {
  imports = [
    ../../modules/environment/xdg.nix
    ../../modules/environment/desktop-manager.nix
    ../../modules/security/yubikey.nix
    ../../modules/security/ssh_config.nix
    ../../modules/editors/emacs # ! Comment this out on first install !
  ];

  # Add the plugdev group with no members
  users.groups.plugdev = {};

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users."${user}" = {
    isNormalUser = true;
    description = "${user}";
    extraGroups = ["networkmanager" "wheel" "dialout" "plugdev"];
    packages = with pkgs; [google-chrome];
  };

  # Set your time zone.
  #time.timeZone = "Asia/Dubai";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.utf8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_IE.utf8";
    LC_IDENTIFICATION = "en_IE.utf8";
    LC_MEASUREMENT = "en_IE.utf8";
    LC_MONETARY = "en_IE.utf8";
    LC_NAME = "en_IE.utf8";
    LC_NUMERIC = "en_IE.utf8";
    LC_PAPER = "en_IE.utf8";
    LC_TELEPHONE = "en_IE.utf8";
    LC_TIME = "en_IE.utf8";
  };

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable sound with pipewire.
  sound.enable = true;
  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;

  fonts.fonts = with pkgs; [
    # Fonts
    carlito # NixOS
    vegur # NixOS
    liberation_ttf
    fira-code
    fira-code-symbols
    font-awesome # Icons
    (nerdfonts.override {
      # Nerdfont Icons override
      fonts = ["FiraCode"];
    })
  ];

  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  # Only allow users to be declared declarativly, not imperative (i.e. adduser and similar tools will not work only config.nix)
  # users.mutableUsers = false;

  nix = {
    # Nix Package Manager settings
    settings = {
      auto-optimise-store = true; # Optimise syslinks

      # trusted-substituters = [
      #     "http://cache.vedenemo.dev"
      #   ];

      #   substituters = [
      #     "http://cache.vedenemo.dev"
      #   ];

      #   trusted-public-keys = [
      #     "cache.vedenemo.dev:RGHheQnb6rXGK5v9gexJZ8iWTPX6OcSeS56YeXYzOcg="
      #   ];
    };

    gc = {
      # Automatic garbage collection
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 7d";
    };

    registry.nixpkgs.flake = inputs.nixpkgs;

    extraOptions = ''
      experimental-features    = nix-command flakes
      keep-outputs             = true
      keep-derivations         = true
      # optional, useful when the builder has a faster internet connection than yours
      ###builders-use-substitutes = true
    '';

    #https://nixos.wiki/wiki/Distributed_build#NixOS
    buildMachines = [
      {
        hostName = "awsarm";
        system = "aarch64-linux";
        maxJobs = 8;
        speedFactor = 1;
        supportedFeatures = ["nixos-test" "benchmark" "big-parallel" "kvm"];
        mandatoryFeatures = [];
        sshUser = "brian";
        sshKey = "/root/.ssh/id_rsa";
      }
    ];

    distributedBuilds = true;
  };

  # Allow unfree packages
  nixpkgs.config = {
    allowUnfree = true;
    allowBroken = false;
  };

  hardware.enableRedistributableFirmware = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    git
    wireguard-tools
  ];

  sops.defaultSopsFile = ./secrets/common.yaml;

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "22.05"; # Did you read the comment?
}
