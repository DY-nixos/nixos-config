{ pkgs, ... }:

{
  services.flatpak.enable = true;

  environment.systemPackages = with pkgs; [
    flatpak
    gnome-software
    bazaar
  ];

  systemd.services.configure-flatpak-repo = {
    description = "Configure Flatpak Domestic Mirrors";
    wantedBy = [ "multi-user.target" ];
    after = [ "network-online.target" ];
    wants = [ "network-online.target" ];
    path = [ pkgs.flatpak pkgs.curl ];
    # 使用列表形式，更清晰的错误处理
    script = ''
      set -e
      
      # 镜像源列表：名称 URL Repo地址
      MIRRORS=(
        "tuna:https://mirrors.tuna.tsinghua.edu.cn/flathub:https://mirrors.tuna.tsinghua.edu.cn/flathub/flathub.flatpakrepo"
        "sjtu:https://mirror.sjtu.edu.cn/flathub:https://mirror.sjtu.edu.cn/flathub/flathub.flatpakrepo"
        "bfsu:https://mirrors.bfsu.edu.cn/flathub:https://mirrors.bfsu.edu.cn/flathub/flathub.flatpakrepo"
      )
      
      CONFIGURED=0
      
      for mirror in "''${MIRRORS[@]}"; do
        IFS=':' read -r name url repo <<< "$mirror"
        echo "检查 $name 镜像..."
        
        # 使用 curl 测试，设置超时
        if curl -s -f -o /dev/null --connect-timeout 10 --max-time 30 "$repo"; then
          echo "配置 $name 镜像..."
          flatpak remote-add --if-not-exists "flathub-$name" "$repo"
          flatpak remote-modify "flathub-$name" --url="$url"
          echo "✓ 成功配置 $name 镜像"
          CONFIGURED=1
        else
          echo "✗ $name 镜像不可用"
        fi
      done
      
      # 总是配置官方源作为后备
      echo "配置官方源作为后备..."
      flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
      
      if [ $CONFIGURED -eq 1 ]; then
        echo "✓ Flatpak 多镜像配置完成"
      else
        echo "⚠ 未配置任何镜像源，仅使用官方源"
      fi
      
      flatpak update --appstream
    '';
  };

  fonts.fontconfig.enable = true;
}