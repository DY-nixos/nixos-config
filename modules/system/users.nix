{ config, pkgs, ... }:

{
  users.users.dy = {
    isNormalUser = true;
    description = "dy";
    extraGroups = [
      "networkmanager" "wheel" "libvirtd" "kvm"
      "storage" "disk" "video"
      "docker" "render" "bluetooth"
    ];
  };
}
