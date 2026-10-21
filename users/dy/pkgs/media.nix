{ config, pkgs, ... }: {

  home.packages = with pkgs; [
    mpv
    mupdf
  ];
}
