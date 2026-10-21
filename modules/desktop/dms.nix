{ config, pkgs, inputs, ... }:

{
  # 系统级导入 DMS 模块
  imports = [
    inputs.dms.nixosModules.dank-material-shell
  ];

  # 系统级 DMS 配置
  programs.dank-material-shell = {
    enable = true;
    enableSystemMonitoring = false;
    enableDynamicTheming = false;
    enableCalendarEvents = false;
    enableAudioWavelength = false;
    
    # 可选：配置用户（如果需要指定用户）
    # users = [ "dy" ];
  };
}