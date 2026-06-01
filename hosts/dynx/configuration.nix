{ config, pkgs, ... }:

{
  imports = [
    ../common/default.nix
    ./hardware.nix
  ];

  sops.age.sshKeyPaths = [ "/etc/ssh/ssh_host_ed25519_key" ];
  networking.hostName = "dynx";

}