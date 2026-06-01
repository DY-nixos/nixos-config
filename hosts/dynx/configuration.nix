{ config, pkgs, ... }:

{
  imports = [
    ../common/default.nix
    ./hardware.nix
  ];
  users.users.secrets = {
    isSystemUser = true;  # 系统用户
    group = "secrets";
    createHome = true;
    home = "/var/lib/secrets";
  };
  
  users.groups.secrets = {};

  networking.hostName = "dynx";

}