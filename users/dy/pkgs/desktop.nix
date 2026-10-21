{ config, pkgs, ... }: {

  home.packages = with pkgs; [
    loupe
    fsearch
    kdePackages.partitionmanager
    capitaine-cursors
  ];
}
