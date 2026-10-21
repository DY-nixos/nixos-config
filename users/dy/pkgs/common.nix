{ config, pkgs, ... }: {

  imports = [
    ./desktop.nix
    ./media.nix
    ./screenshot.nix
  ];

  home.sessionVariables = {
    STEAM_FORCE_DESKTOPUI_SCALING = "1.5";
  };
}
