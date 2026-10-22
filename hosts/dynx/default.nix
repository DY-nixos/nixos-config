{ config, lib, pkgs, ... }:

{
  imports = [
    ../../modules/gpu/nvidia.nix
    ../../modules/system
    ../../modules/desktop
    ../../modules/desktop/niri.nix
    ../../modules/desktop/noctalia.nix
    ../../modules/desktop/network.nix
    
    ../../modules/apps/programs.nix
    ../../modules/apps/appimage.nix
    ../../modules/apps/blender.nix
    ../../modules/apps/default-browser.nix
    ../../modules/apps/flatpak.nix
    ../../modules/apps/opencode.nix
    ../../modules/apps/qBittorrent.nix
    ../../modules/apps/steam.nix

    ./hardware.nix
    ./sops.nix
  ];

  networking.hostName = "dynx";

  nixpkgs.config.android_sdk.accept_license = true;

  boot.kernelParams = [ "usbcore.autosuspend=-1" "quiet" ];
  boot.consoleLogLevel = 3;
  boot.initrd.verbose = false;

  boot.loader.grub.extraEntries = ''
    menuentry "Windows" {
        search --file --no-floppy --set=root /EFI/Microsoft/Boot/bootmgfw.efi
        chainloader (''${root})/EFI/Microsoft/Boot/bootmgfw.efi
    }
  '';



  home-manager.users.dy.imports = [
    ../../users/dy/pkgs/dynx.nix
    ../../users/dy/niri.nix
    ../../users/dy/obs.nix
  ];
}
