{ config, pkgs, ... }: {

  home.packages = with pkgs; [
    alacritty
    yazi
    fuzzel
    mpv
    obs-studio
    loupe
    fsearch
    mupdf
    
    kdePackages.partitionmanager
    xwayland-satellite
    nerd-fonts.jetbrains-mono
    capitaine-cursors
    grim
    slurp
    wl-clipboard
    satty
  ];

  home.sessionVariables = {
    STEAM_FORCE_DESKTOPUI_SCALING = "1.5";
  };
}
