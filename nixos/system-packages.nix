{pkgs, ...}: {
  environment.systemPackages = with pkgs; [
    alejandra
    cachix
    wget
    curl
    git
    htop
    nix-info
    wireguard-tools
    tree
  ];
}
