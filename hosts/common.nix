# SPDX-License-Identifier: Apache-2.0
{
  self,
  inputs,
  lib,
  config,
  pkgs,
  ...
}: let
  cfg = config.setup.device;
in {
  imports = lib.flatten [
    (with self.nixosModules;
      [
        hardening
        system-packages
        user-bmg
        user-groups
        xdg
        scripts
        nebula
      ]
      ++ [inputs.nix-index-database.nixosModules.nix-index])
    [
      inputs.home-manager.nixosModules.home-manager
      {
        home-manager.useGlobalPkgs = true;
        home-manager.useUserPackages = true;
        home-manager.extraSpecialArgs = {inherit inputs;};
        home-manager.users.brian = {
          imports =
            lib.optionals cfg.isClient [(import ../home/home-client.nix)]
            ++ lib.optionals cfg.isServer [(import ../home/home-server.nix)]
            ++ [inputs.nix-index-database.hmModules.nix-index];
        };
      }
    ]
  ];

  options = {
    setup.device.isClient = lib.mkEnableOption "System is a client device";
    setup.device.isServer = lib.mkEnableOption "System is a server (headless device)";
  };

  config = {
    nixpkgs.config.allowUnfree = true;
    # Enable developer documentation (man 3) pages
    documentation = {
      dev.enable = true;
      # This is slow for the first build
      # man.generateCaches = true;
    };

    nix = {
      # This will add each flake input as a registry
      # To make nix3 commands consistent with your flake
      registry = lib.mapAttrs (_: value: {flake = value;}) inputs;
      # This will additionally add your inputs to the system's legacy channels
      # Making legacy nix commands consistent as well
      nixPath = lib.mapAttrsToList (key: value: "${key}=${value.to.path}") config.nix.registry;

      settings = {
        # Enable flakes and new 'nix' command
        experimental-features = "nix-command flakes";
        system-features = ["nixos-test" "benchmark" "big-parallel" "kvm"];

        # Avoid copying unecessary stuff over SSH
        builders-use-substitutes = true;
        trusted-users = ["root" "brian"];
        auto-optimise-store = true; # Optimise syslinks
        keep-outputs = true; # Keep outputs of derivations
        keep-derivations = true; # Keep derivations
      };

      # Garbage collection
      optimise.automatic = true;
      gc = {
        automatic = true;
        dates = "weekly";
        options = pkgs.lib.mkDefault "--delete-older-than 7d";
      };

      # extraOptions = ''
      #   plugin-files = ${pkgs.nix-doc}/lib/libnix_doc_plugin.so
      # '';

      #https://nixos.wiki/wiki/Distributed_build#NixOS
      buildMachines = [
        {
          hostName = "hetzarm";
          system = "aarch64-linux";
          maxJobs = 8;
          speedFactor = 1;
          supportedFeatures = ["nixos-test" "benchmark" "big-parallel" "kvm"];
          mandatoryFeatures = [];
          #TODO <CHANGE_ME> Fix this
          sshUser = "bmg";
          sshKey = "/home/brian/.ssh/builder-key";
        }
        {
          hostName = "vedenemo-builder";
          system = "x86_64-linux";
          maxJobs = 8;
          speedFactor = 1;
          supportedFeatures = ["nixos-test" "benchmark" "big-parallel" "kvm"];
          mandatoryFeatures = [];
          #TODO <CHANGE_ME> Fix this
          sshUser = "bmg";
          sshKey = "/home/brian/.ssh/builder-key";
        }
      ];

      distributedBuilds = true;
    };

    # Sometimes it fails if a store path is still in use.
    # This should fix intermediate issues.
    systemd.services.nix-gc.serviceConfig = {
      Restart = "on-failure";
    };

    # Common network configuration
    # The global useDHCP flag is deprecated, therefore explicitly set to false
    # here. Per-interface useDHCP will be mandatory in the future, so this
    # generated config replicates the default behaviour.
    networking = {
      useDHCP = false;
      enableIPv6 = false;
      #Open ports in the firewall?
      firewall = {
        enable = true;
      };
      nftables.enable = true;
    };

    ## Local config
    ##
    programs = {
      ssh = {
        startAgent = true;
        extraConfig = ''
          Host hetzarm
               user <CHANGE_ME>
               HostName 65.21.20.242
          host ghaf-net
               user ghaf
               IdentityFile ~/.ssh/builder-key
               #hostname 192.168.10.108
               hostname 192.168.10.45
          host ghaf-host
               user ghaf
               IdentityFile ~/.ssh/builder-key
               hostname 192.168.101.2
               proxyjump ghaf-net
          host vedenemo-builder
               user <CHANGE_ME>
               hostname builder.vedenemo.dev
        '';
        knownHosts = {
          hetzarm-ed25519 = {
            hostNames = ["65.21.20.242"];
            publicKey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAILx4zU4gIkTY/1oKEOkf9gTJChdx/jR3lDgZ7p/c7LEK";
          };
          vedenemo-builder = {
            hostNames = ["builder.vedenemo.dev"];
            publicKey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIHSI8s/wefXiD2h3I3mIRdK+d9yDGMn0qS5fpKDnSGqj";
          };
        };
      };
      # Disable in favor of nix-index-database
      command-not-found = {
        enable = false;
      };
    };

    # Contents of the user and group files will be replaced on system activation
    # Ref: https://search.nixos.org/options?channel=unstable&show=users.mutableUsers
    users.mutableUsers = false;

    hardware.enableRedistributableFirmware = true;
    hardware.enableAllFirmware = true;

    boot = {
      # use the bleeding edge kernel
      # should this be changed for the nvidia issues
      kernelPackages = pkgs.linuxPackages_latest;
      binfmt.emulatedSystems = [
        "riscv64-linux"
        "aarch64-linux"
      ];
    };
  };
  #TODO Enable and/or move
  #sops.defaultSopsFile = ./secrets/common.yaml;
}
