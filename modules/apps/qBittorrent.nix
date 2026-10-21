# /etc/nixos/configuration.nix
{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    qbittorrent
  ];
  services.qbittorrent = {
    enable = true;
    # 可选：开启防火墙端口
    openFirewall = true;
  };
}