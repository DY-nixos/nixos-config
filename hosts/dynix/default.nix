{ config, lib, pkgs, ... }:

{
  imports = [
    ../../modules/system
    ../../modules/desktop
    ../../modules/gpu/amd.nix

    ../../modules/apps/programs.nix
    ../../modules/apps/cli.nix
    ../../modules/desktop/network.nix

    ./hardware.nix
  ];

  networking.hostName = "dynix";
  networking.firewall.checkReversePath = "loose";

  home-manager.users.dy.imports = [
    ../../users/dy/pkgs/dynix.nix
  ];

  boot.kernelParams = [ "usbcore.autosuspend=-1" ];
}
