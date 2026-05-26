{ config, pkgs, ... }:

{
  imports = [
    ../common/default.nix
    ./hardware.nix
  ];

  networking.hostName = "dynix";
}