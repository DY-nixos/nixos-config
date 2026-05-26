{ config, pkgs, inputs, ... }: {
  programs.hyprland = {
     enable = true;
     withUWSM = true;
  };
}