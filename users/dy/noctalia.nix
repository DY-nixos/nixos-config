# 默认未启用。需要时把本文件加入 users/dy/default.nix 的 imports，或加入主机的
# home-manager.users.dy.imports。
{ config, pkgs, lib, ... }:

let
  mkOutOfStoreSymlink = config.lib.file.mkOutOfStoreSymlink;
  configDir = "/home/dy/nixos-config";
in {
  xdg.configFile = {
    "noctalia/config.cpp".source = mkOutOfStoreSymlink "${configDir}/dotfiles/noctalia/config.cpp";
  };
}
