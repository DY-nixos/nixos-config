{ config, pkgs, lib, ... }:
let
  mkOutOfStoreSymlink = config.lib.file.mkOutOfStoreSymlink;
  configDir = "/home/dy/nixos-config";
in {
  xdg.configFile = {
    "noctalia/settings.json".source = mkOutOfStoreSymlink "${configDir}/dotfiles/noctalia/settings.json";
  };
}