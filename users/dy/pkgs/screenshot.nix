{ config, pkgs, ... }: {

  home.packages = with pkgs; [
    grim
    slurp
    wl-clipboard
    satty
  ];
}
