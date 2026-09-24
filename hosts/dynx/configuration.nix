{ config, pkgs, ... }:

{
  imports = [
    ../common/default.nix
    ./hardware.nix
    ./sops.nix
  ];

  networking.hostName = "dynx";

}