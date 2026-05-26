{ config, pkgs, lib, ... }:

let
  mkOutOfStoreSymlink = config.lib.file.mkOutOfStoreSymlink;
  configDir = "/home/dy/nixos-config";
in {
  xdg.configFile."niri/config.kdl" = {
    source = mkOutOfStoreSymlink "${configDir}/dotfiles/niri/config.kdl";
    force = true;
  };
}
