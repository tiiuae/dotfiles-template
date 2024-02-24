{pkgs, ...}: let
  rebuild-arcadia = pkgs.writeScriptBin "rebuild-arcadia" ''
    sudo nixos-rebuild switch --flake .#arcadia
  '';
  rebuild-nephele = pkgs.writeScriptBin "rebuild-nephele" ''
    nixos-rebuild switch --flake .#nephele --target-host "root@nephele"
  '';
  rebuild-x1 = pkgs.writeScriptBin "rebuild-x1" ''
    nixos-rebuild --flake .#lenovo-x1-carbon-gen11-debug --target-host "root@ghaf-host" --fast switch
  '';
  #https://discourse.nixos.org/t/install-shell-script-on-nixos/6849/10
  #ownfile = pkgs.callPackage ./ownfile.nix {};
in {
  environment.systemPackages = with pkgs; [
    rebuild-arcadia
    rebuild-nephele
    rebuild-x1
    #ownfile
  ];
}
