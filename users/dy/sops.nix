# users/dy/default.nix 或具体的用户配置
{ config, ... }:

{
  # 引用 sops 模块
  sops.age.keyFile = "${config.home.homeDirectory}/.config/sops/age/keys.txt";
  sops.defaultSopsFile = ../secrets/secrets.yaml;
  
  sops.secrets = {
    EXAMPLE_API_KEY = { };
    DATABASE_PASSWORD = { };
  };
  
  # 作为环境变量
  home.sessionVariables = {
    API_KEY = "${config.sops.secrets.EXAMPLE_API_KEY.path}";
  };
}