{ config, pkgs, lib, ... }:

let
  mkOutOfStoreSymlink = config.lib.file.mkOutOfStoreSymlink;
  # 必须用字符串，不能是路径字面量，否则 "${configDir}" 会被复制到 /nix/store
  configDir = "/home/dy/nixos-config";
in {
  xdg.configFile."hypr/hyprland.lua" = {
    source = mkOutOfStoreSymlink "${configDir}/dotfiles/hypr/hyprland.lua";
    force = true;
  };
}