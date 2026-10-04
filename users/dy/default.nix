{ config, pkgs, lib, ... }:

{
  home.username = "dy";
  home.homeDirectory = "/home/dy";
  home.stateVersion = "24.11";
  
  gtk.enable = lib.mkForce false;
  home.pointerCursor.enable = false;
}