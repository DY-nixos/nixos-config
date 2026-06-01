{ config, ... }:

{
  sops = {
    age.keyFile = "${config.home.homeDirectory}/.config/sops/age/keys.txt";
    defaultSopsFile = ../secrets/secrets.yaml;  # 取消注释
    secrets = {
      GITHUB_TOKEN = { };  # 替换为 GITHUB_TOKEN
    };
  };
  
  # 作为环境变量
  home.sessionVariables = {
    GITHUB_TOKEN = "${config.sops.secrets.GITHUB_TOKEN.path}";
  };
}

# 1. 编辑加密文件
#sops users/secrets/secrets.yaml
# 添加：NEW_TOKEN: value

# 2. 修改 users/dy/sops.nix
#sops.secrets.NEW_TOKEN = { };
#home.sessionVariables.NEW_TOKEN = config.sops.secrets.NEW_TOKEN.path;

# 3. 重新构建
#sudo nixos-rebuild switch --flake .#dynx