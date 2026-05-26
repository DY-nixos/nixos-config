{ config, pkgs, ... }:

{
  programs.thunar = {
    enable = true;
    plugins = with pkgs; [
      thunar-volman
      thunar-archive-plugin
    ];
  };
  programs.xfconf.enable = true;
  environment.systemPackages = with pkgs; [
    gst_all_1.gst-plugins-bad
    gst_all_1.gst-plugins-ugly
  ];
}