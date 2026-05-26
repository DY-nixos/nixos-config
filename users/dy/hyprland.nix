{ config, pkgs, lib, ... }:

let
  mkOutOfStoreSymlink = config.lib.file.mkOutOfStoreSymlink;
  configDir = "/home/dy/nixos-config";
in {
  xdg.configFile."hypr/hyprland.conf" = {
    source = mkOutOfStoreSymlink "${configDir}/dotfiles/hypr/hyprland.conf";
    force = true;
  };
}
