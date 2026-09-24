{ config, ... }:

{
  # sops-nix 系统级配置（模块已由 flake.nix 中的 nixosModules.sops 提供）
  sops = {
    age.keyFile = "/var/lib/sops-nix/age/keys.txt";
    defaultSopsFile = ../../secrets/secrets.yaml;
    secrets = {
      GITHUB_TOKEN = {
        owner = "dy";
      };
      # 给 root 的 nix 配置：绕过 GitHub API 限流（token 明文不进 git）
      NIX_ACCESS_TOKENS = {
        owner = "root";
        mode = "0644";
        path = "/root/.config/nix/nix.conf";
      };
    };
  };

  # 把 token 暴露为 dy 的会话变量（引用系统级 secret 路径）
  home-manager.users.dy.home.sessionVariables = {
    GITHUB_TOKEN = config.sops.secrets.GITHUB_TOKEN.path;
  };
}
