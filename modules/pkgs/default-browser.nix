# 把 Firefox 锁为默认浏览器。
#
# 三层:
#   1. 本文件: /etc/xdg/mimeapps.list  —— XDG_CONFIG_DIRS 里的系统级兜底,
#      任何时候(哪怕 ~/.config/mimeapps.list 被删掉/被别的程序清空)解析
#      http/https/HTML 都回落到 firefox.desktop。
#   2. users/dy/browsers.nix: ~/.config/mimeapps.list 由 home-manager 生成,
#      每次 `home-manager switch` / `nixos-rebuild switch` 重新声明一次。
#   3. users/dy/browsers.nix: xdg-settings / xdg-mime 拦截 shim,
#      静默拒绝任何程序改写默认浏览器/邮件客户端。
#
# 关联表只覆盖 http(s) 与 HTML 这一类, 其余类型(PDF/图片/文本/压缩包…)保持
# xdg 默认行为, 交给各程序自己选。
#
# 本文件的关联表是"兜底", 优先级低于 ~/.config/mimeapps.list(见上面第 2 层),
# 所以两边即使不完全一致也不会影响正常解析; 改关联时顺手改一下即可。

{ config, pkgs, lib, ... }:

let
  browser = "firefox.desktop";

  mimeTypes = [
    "x-scheme-handler/http"
    "x-scheme-handler/https"
    "text/html"
    "application/xhtml+xml"
    "application/x-extension-html"
    "application/x-extension-htm"
    "application/x-extension-shtml"
    "application/x-extension-xhtml"
    "application/x-extension-xht"
  ];

  mimeapps = pkgs.writeText "mimeapps.list" ''
    [Default Applications]
    ${lib.concatStringsSep "\n" (map (m: "${m}=${browser}") mimeTypes)}
  '';
in
{
  environment.etc."xdg/mimeapps.list".source = mimeapps;
}
