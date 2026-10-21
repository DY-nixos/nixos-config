{ config, pkgs, ... }:

{
  programs.niri.enable = true;

  programs.uwsm.waylandCompositors.niri = {
    binPath = "/run/current-system/sw/bin/niri-session";
    comment = "Niri (UWSM managed)";
    prettyName = "Niri";
  };
}
