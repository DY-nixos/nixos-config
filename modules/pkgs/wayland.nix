{ config, pkgs, lib, ... }:
{
  programs.niri.enable = true;
  programs.xwayland.enable = true;
  programs.uwsm.enable = true;
  programs.dconf.enable = true;
  
  programs.uwsm.waylandCompositors.niri = {
    binPath = "/run/current-system/sw/bin/niri-session";
    comment = "Niri (UWSM managed)";
    prettyName = "Niri";
  };

  services.gvfs.enable = true;
  services.udisks2.enable = true;
  services.tumbler.enable = true;
  security.polkit.enable = true;
  services.dbus.enable = true;
  services.udev.enable = true;

  xdg.portal = {
    enable = true;
    xdgOpenUsePortal = true;
    extraPortals = [
      pkgs.xdg-desktop-portal-gtk
    ];
    config = {
      hyprland = {
        default = ["hyprland" "gtk"];
      };
      niri = {
        default = ["gnome" "gtk"];
      };
    };
  };

  environment.variables = {
    NIXOS_OZONE_WL = "1";
  };
}