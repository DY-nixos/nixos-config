{ config, pkgs, lib, ... }: {

  networking.networkmanager.enable = true;

  environment.systemPackages = with pkgs; [
    clash-verge-rev
    mihomo
  ];
  programs.clash-verge = {
    enable = true;
    autoStart = true;   
    serviceMode = true;
    tunMode = true; 
  };
  
  #networking.proxy.default = "http://127.0.0.1:7897/";
  #networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  networking.firewall.enable = true;
  networking.firewall.allowedTCPPorts = [ 3000 ];
  networking.firewall.trustedInterfaces = [ "docker0" ];
}