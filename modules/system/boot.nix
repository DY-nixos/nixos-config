{ config, pkgs, ... }:

{
  boot.kernelPackages = pkgs.linuxPackages_latest;

  boot.loader = {
    timeout = -1;
    efi.canTouchEfiVariables = true;
    efi.efiSysMountPoint = "/boot";
    grub = {
      enable = true;
      device = "nodev";
      efiSupport = true;
      efiInstallAsRemovable = false;
      useOSProber = false;
      configurationLimit = 10;
    };
  };

  boot.supportedFilesystems = [ "ntfs" "exfat" "vfat" "ext4" ];
}
