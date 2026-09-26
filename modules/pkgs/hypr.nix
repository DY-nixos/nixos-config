# users/dy/config/hypr.nix
{ config, pkgs, inputs, ... }: {
  programs.hyprland = {
     enable = true;
     xwayland.enable = true;
     withUWSM = true;
     package = inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.hyprland;
  };
}