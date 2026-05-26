{ config, pkgs, ... }: {

  programs.fish = {
    enable = true;
    shellInit = "set -g fish_greeting ''";
    interactiveShellInit = "fastfetch";
    shellAliases = { ll = "ls -l"; };
  };

}